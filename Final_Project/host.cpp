#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>
#include <cassert>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <sstream>
#include <string>
#include <time.h>
#include <sys/time.h>
#include <CL/opencl.h>
#include <stdlib.h>

#define STR_HELPER(x) #x
#define STR(x) STR_HELPER(x)

#define DPRINTF(...) printf(__VA_ARGS__); fflush(stdout);

#define NUM_QUEUES_TO_CREATE 3
#define NUM_KERNELS_TO_CREATE 3


#define CHECK(status)                                                           \
        if (status != CL_SUCCESS)                                               \
{                                                                       \
        printf("error %d in line %d.\n", status, __LINE__);    \
        exit(1);                                                        \
}  

#define ACL_ALIGNMENT 64
using namespace std;
void* acl_aligned_malloc (size_t size) {
    void *result = NULL;
    posix_memalign (&result, ACL_ALIGNMENT, size);
    return result;
}

const int num_Aargs = 2; 
const int A_args[2] = {J*JJ*JJJ,I*II*III};
const int num_Bargs = 2;
const int B_args[2] = {J*JJ*JJJ,I*II*III};
const int num_Cargs = 2;
const int C_args[2] = {J*JJ*JJJ,I*II*III};

const char* kernel_name[] = {
"kernel_A_loader_channel",
"kernel_B_loader_channel",
"kernel_C_unloader"
};

double compute_kernel_execution_time(cl_event &event, double &start_d, double &end_d)
{
  cl_ulong start, end;
    
  clGetEventProfilingInfo(event, CL_PROFILING_COMMAND_END, sizeof(cl_ulong), &end, NULL);
  clGetEventProfilingInfo(event, CL_PROFILING_COMMAND_START, sizeof(cl_ulong), &start, NULL);
    
  start_d = (double)1.0e-9 * start;
  end_d   = (double)1.0e-9 * end;
  //return (double)(end-start);
  return (double)1.0e-9 * (end - start); // nanoseconds to seconds
}

void print_matrix(char * A, int hA, int wA)
{
  for(int i=0; i < hA; ++i) {
    for(int j=0; j < wA; ++j) {
      printf("%d\t", A[i*wA + j]);
    }
    printf("\n");
  }
}

void print_matrix_int(int * A, int hA, int wA)
{
  for(int i=0; i < hA; ++i) {
    for(int j=0; j < wA; ++j) {
      printf("%d\t", A[i*wA + j]);
    }
    printf("\n");
  }
}

void initialize_array(char* array, const long int rows, const long int columns, char* filename)
{
	fstream infile;
	infile.open(filename);
	while(!infile.eof())
	{
		for (int i = 0; i < rows; ++i)
			for (int j = 0; j < columns; j++) {
				infile >> array[i * columns + j];
		}
	}
	infile.close();
}

void randomize_array(float* array, const long int size)
{
    for (int i = 0; i < size; ++i)
    {
        array[i] = (float)rand() / (float)RAND_MAX;
    }
}

bool compare_L2_norm(const float* ref_array, const float* output_array, const unsigned int size, const float epsilon)
{
    // compute the L^2-Norm of the difference between the output array and reference array
    // and compare it against the L^2-Norm of the reference.
    float diff = 0.0f;
    float ref = 0.0f;
    for (int i = 0; i < size; ++i) {
        const float o = output_array[i];
        const float r = ref_array[i];
        const float d = o - r;
        diff += d * d;
        ref += r * r;
    }

    const float diff_l2norm = sqrtf(diff);
    const float ref_l2norm = sqrtf(ref);
    const float error = diff_l2norm / ref_l2norm;
    const bool pass = error < epsilon;

    return pass;
}


int main() {
    char *A, *B;
	int *C;
    long int  num_elem_A = (long int) (I*II*III)*(K*KK*KKK);
    long int  num_elem_B = (long int) (K*KK*KKK)*(J*JJ*JJJ);
    long int  num_elem_C = (long int) (I*II*III)*(J*JJ*JJJ);
    if((A = (char*)acl_aligned_malloc(num_elem_A*sizeof(char))) == NULL) {
        perror("Failed malloc of matrix A");
    }
    if((B = (char*)acl_aligned_malloc(num_elem_B*sizeof(char))) == NULL) {
        perror("Failed malloc of matrix B");
    }
    if((C = (int*)acl_aligned_malloc(num_elem_C*sizeof(int))) == NULL) {
        perror("Failed malloc of matrix C");
    }

    //randomize_array(serialized_A, num_elem_A);
    //randomize_array(serialized_B, num_elem_B);
    initialize_array(A, I*II*III, K*KK*KKK, "col_featuremap.txt");
    initialize_array(B, K*KK*KKK, J*JJ*JJJ, "col_kernal.txt");

    // Serialize A and B according to the T2S specification:
    //   A_serializer.reorder(kkk,ii,iii,kk,k,i);
    //   B_serializer.reorder(kkk,jjj,jj,kk, k,j);
    char *serialized_A, *serialized_B;
    if((serialized_A = (char*)acl_aligned_malloc(num_elem_A*sizeof(char))) == NULL) {
        perror("Failed malloc of matrix serialized_A");
    }
    if((serialized_B = (char*)acl_aligned_malloc(num_elem_B*sizeof(char))) == NULL) {
        perror("Failed malloc of matrix serialized_B");
    }
    long int indexA = 0;
    for (int i = 0; i < I; i++)
        for (int k = 0; k < K; k++)
            for (int kk = 0; kk < KK; kk++)
                for (int iii = 0; iii < III; iii++)
                    for (int ii = 0; ii < II; ii++)
                        for (int kkk = 0; kkk < KKK; kkk++) {
                            serialized_A[indexA++] = A[(i*II*III + ii*III + iii)*K*KK*KKK + k*KK*KKK + kk*KKK + kkk];
                        }

    long int indexB = 0;
    for (int j = 0; j < J; j++)
        for (int k = 0; k < K; k++)
            for (int kk = 0; kk < KK; kk++)
                for (int jj = 0; jj < JJ; jj++)
                    for (int jjj = 0; jjj < JJJ; jjj++)
                        for (int kkk = 0; kkk < KKK; kkk++) {
                            serialized_B[indexB++] = B[(k*KK*KKK + kk*KKK + kkk)*J*JJ*JJJ + j*JJ*JJJ + jj*JJJ + jjj];
                        }


    DPRINTF("\n===== Host-CPU setting up the OpenCL platform and device ======\n\n");

    // Use this to check the output of each API call
    cl_int status;

    //----------------------------------------------
    // Discover and initialize the platforms
    //----------------------------------------------
    cl_uint numPlatforms = 0;
    cl_platform_id* platforms = NULL;

    // Use clGetPlatformIDs() to retrieve the
    // number of platforms
    status = clGetPlatformIDs(0, NULL, &numPlatforms);
    DPRINTF("Number of platforms = %d\n", numPlatforms);

    // Allocate enough space for each platform
  //  platforms = (cl_platform_id*) acl_aligned_malloc (numplatforms * sizeof(cl_platform_id));
    platforms = (cl_platform_id*) malloc (numPlatforms * sizeof(cl_platform_id));

    DPRINTF("Allocated space for Platform\n");

    // Fill in platforms with clGetPlatformIDs()
    status = clGetPlatformIDs(numPlatforms, platforms, NULL); CHECK(status);
    DPRINTF("Filled in platforms\n");

    //----------------------------------------------
    // Discover and initialize the devices
    //----------------------------------------------

    cl_uint numDevices = 0;

    // Device info
    char buffer[4096];
    unsigned int buf_uint;
    int device_found = 0;
    const cl_uint maxDevices = 4;
    cl_device_id devices[maxDevices];
    DPRINTF("Initializing IDs\n");
    for (int i=0; i<numPlatforms; i++) {
      status = clGetDeviceIDs(platforms[i],
              CL_DEVICE_TYPE_ALL,
              maxDevices,
              devices,
              &numDevices);

      if(status == CL_SUCCESS){
          clGetPlatformInfo(platforms[i],
                  CL_PLATFORM_NAME,
                  4096,
                  buffer,
                  NULL);
  #if defined(ALTERA_CL)
              if(strstr(buffer, "Altera") != NULL){
                  device_found = 1;
              }
              DPRINTF("%s\n", buffer);
  #elif defined(NVIDIA_CL)
              if(strstr(buffer, "NVIDIA") != NULL){
                  device_found = 1;
              }
  #else
              if(strstr(buffer, "Intel") != NULL){
                  device_found = 1;
              }
  #endif

              DPRINTF("Platform found : %s\n", buffer);
              device_found = 1;
          }
      }

      if(!device_found) {
          DPRINTF("failed to find a OpenCL device\n");
          exit(-1);
      }

      DPRINTF("Total number of devices: %d", numDevices);
      for (int i = 0; i < numDevices; i++) {
          clGetDeviceInfo(devices[i],
                  CL_DEVICE_NAME,
                  4096,
                  buffer,
                  NULL);
          DPRINTF("\nDevice Name: %s\n", buffer);

          clGetDeviceInfo(devices[i],
                  CL_DEVICE_VENDOR,
                  4096,
                  buffer,
                  NULL);
          DPRINTF("Device Vendor: %s\n", buffer);

          clGetDeviceInfo(devices[i],
                  CL_DEVICE_MAX_COMPUTE_UNITS,
                  sizeof(buf_uint),
                  &buf_uint,
                  NULL);
          DPRINTF("Device Computing Units: %u\n", buf_uint);

          clGetDeviceInfo(devices[i],
                  CL_DEVICE_GLOBAL_MEM_SIZE,
                  sizeof(unsigned long),
                  &buffer,
                  NULL);
          //DPRINTF("Global Memory Size: %i\n", *((unsigned long*)buffer));

          clGetDeviceInfo(devices[i],
                  CL_DEVICE_MAX_MEM_ALLOC_SIZE,
                  sizeof(unsigned long),
                  &buffer,
                  NULL);
          //DPRINTF("Global Memory Allocation Size: %i\n\n", *((unsigned long*)buffer));
      }



      //----------------------------------------------
      // Create a context
      //----------------------------------------------

      DPRINTF("\n===== Host-CPU setting up the OpenCL command queues ======\n\n");

      cl_context context = NULL;

      // Create a context using clCreateContext() and
      // associate it with the device

      context = clCreateContext(
              NULL,
              1,
              devices,
              NULL,
              NULL,
              &status); CHECK(status);

      //----------------------------------------------
      // Create command queues
      //---------------------------------------------

      cl_command_queue cmdQueue[NUM_QUEUES_TO_CREATE+1]; // extra queue for reading buffer D

      // Create a command queue using clCreateCommandQueue(),
      // and associate it with the device you want to execute on
      for(int i=0; i<NUM_QUEUES_TO_CREATE; i++) {
              //fDPRINTF(stdout,"cmdQueue i = %d\n", i);
              cmdQueue[i] = clCreateCommandQueue(
                  context,
                  devices[0],
                  CL_QUEUE_PROFILING_ENABLE,
                  &status); CHECK(status);
      }

      //fDPRINTF(stdout,"cmdQueue i = %d, a queue for reading the C buffer\n", i);
      cmdQueue[NUM_QUEUES_TO_CREATE] = clCreateCommandQueue(
                          context,
                          devices[0],
                          CL_QUEUE_PROFILING_ENABLE,
                          &status); CHECK(status);

      //----------------------------------------------
      // Create device buffers
      //----------------------------------------------

      cl_mem d_matrix_mul_outputC;
      cl_mem d_matrix_mul_inputA;
      cl_mem d_matrix_mul_inputB;


      DPRINTF("\n===== Host-CPU transferring matrices A,B to the FPGA device global memory (DDR4) via PCIe ======\n\n");
      d_matrix_mul_inputA = clCreateBuffer(
          context,
          //CL_MEM_READ_ONLY | CL_MEM_BANK_1_ALTERA,
          CL_MEM_READ_ONLY,
          num_elem_A*sizeof(cl_char),
          NULL,
          &status); CHECK(status);

      d_matrix_mul_inputB = clCreateBuffer(
          context,
          //CL_MEM_READ_ONLY | CL_MEM_BANK_2_ALTERA,
          CL_MEM_READ_ONLY,
          num_elem_B*sizeof(cl_char),
          NULL,
          &status); CHECK(status);

      d_matrix_mul_outputC = clCreateBuffer(
          context,
          //CL_MEM_WRITE_ONLY | CL_MEM_BANK_1_ALTERA,
          CL_MEM_WRITE_ONLY,
          num_elem_C*sizeof(cl_int),
          NULL,
          &status); CHECK(status);


      //----------------------------------------------
      // Write host data to device buffers
      //----------------------------------------------

          // blocking writes
      status = clEnqueueWriteBuffer(
          cmdQueue[0],
          d_matrix_mul_inputA,
          CL_TRUE,
          0,
          num_elem_A*sizeof(cl_char),
          serialized_A,
          0,
          NULL,
          NULL); CHECK(status);

      status = clEnqueueWriteBuffer(
          cmdQueue[1],
          d_matrix_mul_inputB,
          CL_TRUE,
          0,
          num_elem_B*sizeof(cl_char),
          serialized_B,
          0,
          NULL,
          NULL); CHECK(status);

      //----------------------------------------------
      // Create the program from binaries
      //----------------------------------------------
      DPRINTF("\n===== Host-CPU setting up OpenCL program and kernels ======\n\n");

      cl_program program;

      size_t binary_length;
      const unsigned char *binary;

      //DPRINTF("\nAOCX file: %s\n\n", AOCX_FILE);
      fflush(stdout);
      // create the program using binary already compiled offline using aoc (i.e. the .aocx file)
      //AOCX_FILE=$HOME/tmp/a.aocx
      char *aocx_file = getenv("AOCX_FILE");
      FILE *fp = fopen(aocx_file, "rb");

      if (fp == NULL) {
          DPRINTF("Failed to open the AOCX file (fopen).\n");
          return -1;
      }

      fseek(fp, 0, SEEK_END);
      binary_length = ftell(fp);
      binary = (unsigned char*) malloc(sizeof(unsigned char) * binary_length);
      assert(binary && "Malloc failed");
      rewind(fp);

      if (fread((void*)binary, binary_length, 1, fp) == 0) {
          DPRINTF("Failed to read from the AOCX file (fread).\n");
          return -1;
      }
      fclose(fp);

      DPRINTF("Create program with binary\n");
      // Create a program using clCreateProgramWithBinary()
      program = clCreateProgramWithBinary(
              context,
              1,
              devices,
              &binary_length,
              (const unsigned char **)&binary,
              &status,
              NULL); CHECK(status);


      //----------------------------------------------
      // Create the kernel
      //----------------------------------------------

      status = clBuildProgram(program, 0, NULL, NULL, NULL, NULL);
      if(status != CL_SUCCESS) {
          char log[128*1024] = {0};
          clGetProgramBuildInfo(program, devices[0], CL_PROGRAM_BUILD_LOG, 128*1024, log, NULL);
          DPRINTF("%s\n", log);
          CHECK(status);
      }

      cl_kernel kernel[NUM_KERNELS_TO_CREATE];


      for(int j=0; j<NUM_KERNELS_TO_CREATE; j++) {
          DPRINTF("Creating kernel[%d]: %s\n", j,kernel_name[j]);
          kernel[j] = clCreateKernel(program, (const char*)kernel_name[j], &status);
          CHECK(status);
      }
      DPRINTF("All kernels created\n");

    // serialized_A

      for (int i = 0; i < num_Aargs; i++) {
             status = clSetKernelArg(
                         kernel[0],
                         i,
                         sizeof(int),
                         (void*)&A_args[i]); CHECK(status);
       }
       status = clSetKernelArg(
                   kernel[0],
                   num_Aargs,
                   sizeof(cl_mem),
                   (void*)&d_matrix_mul_inputA); CHECK(status);
       status = clSetKernelArg(
                   kernel[0],
                   num_Aargs+1,
                   sizeof(cl_mem),
                   NULL); CHECK(status);

       // serialized_B
       for (int i = 0; i < num_Bargs; i++) {
             status = clSetKernelArg(
                         kernel[1],
                         i,
                         sizeof(int),
                         (void*)&B_args[i]); CHECK(status);
       }
       status = clSetKernelArg(
                   kernel[1],
                   num_Bargs,
                   sizeof(cl_mem),
                   (void*)&d_matrix_mul_inputB); CHECK(status);
       status = clSetKernelArg(
                   kernel[1],
                   num_Bargs+1,
                   sizeof(cl_mem),
                   NULL); CHECK(status);

       // D
       for (int i = 0; i < num_Cargs; i++) {
             status = clSetKernelArg(
                         kernel[2],
                         i,
                         sizeof(int),
                         (void*)&C_args[i]); CHECK(status);
       }
       status = clSetKernelArg(
                   kernel[2],
                   num_Cargs,
                   sizeof(cl_mem),
                   (void*)&d_matrix_mul_outputC); CHECK(status);
       status = clSetKernelArg(
                   kernel[2],
                   num_Cargs+1,
                   sizeof(cl_mem),
                   NULL); CHECK(status);


      //----------------------------------------------
      // Configure the work-item structure (using only tasks atm)
      //----------------------------------------------

      // Define the number of threads that will be created
      // as well as the number of work groups
      size_t globalWorkSize[1];
      size_t localWorkSize[1];


      //----------------------------------------------
      // Enqueue the kernel for execution
      //----------------------------------------------


          // all kernels are always tasks
      globalWorkSize[0] = 1;
      localWorkSize[0]  = 1;

      cl_event kernel_exec_event[NUM_KERNELS_TO_CREATE];

      DPRINTF("\n===== Host-CPU enqeuing the OpenCL kernels to the FPGA device ======\n\n");
      for(int i=0; i<NUM_KERNELS_TO_CREATE; i++) {
          // Alternatively, can use clEnqueueTaskKernel
          DPRINTF("clEnqueueNDRangeKernel[%d]: %s!\n", i,kernel_name[i]);
          status = clEnqueueNDRangeKernel(
                  cmdQueue[i],
                  kernel[i],
                  1,
                  NULL,
                  globalWorkSize,
                  localWorkSize,
                  0,
                  NULL,
                  &kernel_exec_event[i]);
                  CHECK(status);
      }
      DPRINTF(" *** FPGA execution started!\n");

      for(int i=0; i < NUM_KERNELS_TO_CREATE ; i++) {
          status = clFlush(cmdQueue[i]);
          CHECK(status);
      }

      for(int i=0; i < NUM_QUEUES_TO_CREATE; i++) {
         DPRINTF("cmd queue: %d\n", i);
         fflush(stdout);
         status = clFinish(cmdQueue[i]); CHECK(status);
      }
      DPRINTF(" *** FPGA execution finished!\n");
      DPRINTF("\n\n");

      double k_start_time[NUM_KERNELS_TO_CREATE];
      double k_end_time[NUM_KERNELS_TO_CREATE];
      double k_exec_time[NUM_KERNELS_TO_CREATE];
      double max_time = 0;
      for (int i=0; i < NUM_KERNELS_TO_CREATE; i++) {
          k_exec_time[i] = compute_kernel_execution_time(kernel_exec_event[i], k_start_time[i], k_end_time[i]);
          if (k_exec_time[i] > max_time) {
               max_time = k_exec_time[i];
          }
      }
      DPRINTF("Time taken: %lf sec\n\n", max_time);

      printf("\n===== Reporting measured throughput ======\n\n");
      double k_earliest_start_time = k_start_time[0];
      double k_latest_end_time     = k_end_time[0];

      for (int i=1; i< NUM_KERNELS_TO_CREATE; i++) {
       if (k_start_time[i] < k_earliest_start_time)
           k_earliest_start_time   = k_start_time[i];

       if (k_end_time[i]   > k_latest_end_time)
           k_latest_end_time = k_end_time[i];
      }

      // IMPORTANT: we care about the finish time of drain_C, once data is drained we are done
      k_latest_end_time           = k_end_time[NUM_KERNELS_TO_CREATE-1];

      for(int i=0; i< NUM_KERNELS_TO_CREATE; i++) {
        printf("  Kernel execution time on FPGA: %s, \n   \t\t\t\t\t\t\t\t\texec time = %.5f s, start=%.5f s, end=%.5f s\n", kernel_name[i], k_exec_time[i], k_start_time[i], k_end_time[i]);
      }

      double k_overall_exec_time = k_latest_end_time - k_earliest_start_time;

      printf("\n");
      printf("  Loader kernels start time\t\t= %.5f s\n", k_earliest_start_time);
      printf("  Drainer kernels end time\t\t= %.5f s\n", k_latest_end_time);
      printf("  FPGA MatMult exec time\t\t= %.5f s\n", k_overall_exec_time);

          // multiplied by 1.0e-9 to get G-FLOPs
      printf("\n");

      double num_operations = (double)2.0 * (K*KK*KKK) * (double)(I*II*III) * (double)(J*JJ*JJJ);

      printf("  # operations = %.0f\n", num_operations );
      printf("  Throughput: %.5f GFLOPS\n", (double)1.0e-9 * num_operations / k_overall_exec_time);

      DPRINTF("\n===== Host-CPU transferring result matrix C from the FPGA device global memory (DDR4) via PCIe ======\n\n");

      // Read the results back from the device, blocking read
      int *serialized_C;
      if((serialized_C = (int*)acl_aligned_malloc(num_elem_C*sizeof(int))) == NULL) {
          perror("Failed malloc of matrix serialized_C");
      }

      clEnqueueReadBuffer(
            //cmdQueue[KID_DRAIN_MAT_C],
            cmdQueue[NUM_KERNELS_TO_CREATE], // using a special queue for reading buffer C
            d_matrix_mul_outputC,
            CL_TRUE,
            0,
            num_elem_C*sizeof(cl_int),
            serialized_C,
            0,
            NULL,
            NULL); CHECK(status);


      // Deserialize the results into 2-D array according to the T2S specification
      //    C_deserializer.reorder(jj, ii, jjj, iii, j, i);
      long int indexC = 0;
      for (int i = 0; i < I; i++)
          for (int j = 0; j < J; j++)
                  for (int iii = 0; iii < III; iii++)
                      for (int jjj = 0; jjj < JJJ; jjj++)
                          for (int ii = 0; ii < II; ii++)
                              for (int jj = 0; jj < JJ; jj++) {
                                  C[(i*II*III + ii*III + iii)*J*JJ*JJJ + j*JJ*JJJ + jj*JJJ + jjj] = serialized_C[indexC++];
                              }


      // Calculate the golden results
      int *golden;
      if((golden = (int*)acl_aligned_malloc(num_elem_C*sizeof(int))) == NULL) {
          perror("Failed malloc of matrix golden");
      }
      for (int i = 0; i < I*II*III; i++) {
          for (int j = 0; j < J*JJ*JJJ; j++) {
              golden[i*J*JJ*JJJ + j] = 0;
              for (int k= 0; k < K*KK*KKK; k++) {
                  golden[i*J*JJ*JJJ + j] += A[i*K*KK*KKK + k] * B[k*J*JJ*JJJ + j];
              }
          }
      }

      int passed = 1;
      int total_mismatches=0;
      for (int i = 0; i < I*II*III; i++) {
          for (int j = 0; j < J*JJ*JJJ; j++) {
            if ( !( fabs(golden[i*J*JJ*JJJ + j] - C[i*J*JJ*JJJ + j]) <= (0.005*fabs(golden[i*J*JJ*JJJ + j])))) {
                 passed = 0;
                 if (total_mismatches < 10) {
                     printf("\n[FAILED]: golden[%d][%d]=%f, got:%f\n", i, j, golden[i*J*JJ*JJJ + j], C[i*J*JJ*JJJ + j]);
                 }
                 total_mismatches++;
            }
          }
      }

      if (passed) {
        printf("[PASSED]\n");
		printf("Matrix A: \n");
        print_matrix(A, I*II*III, K*KK*KKK);
        printf("\n\nMatrix B: \n");
        print_matrix(B, K*KK*KKK, J*JJ*JJJ);
        printf("Matrix C: \n");
        print_matrix_int(C, I*II*III, J*JJ*JJJ);
        printf("Golden: \n");
        print_matrix_int(golden, I*II*III, J*JJ*JJJ);
      } else {
        printf("[FAILED]\n");
        printf("Matrix A: \n");
        print_matrix(A, I*II*III, K*KK*KKK);
        printf("\n\nMatrix B: \n");
        print_matrix(B, K*KK*KKK, J*JJ*JJJ);
        printf("Matrix C: \n");
        print_matrix_int(C, I*II*III, J*JJ*JJJ);
        printf("Golden: \n");
        print_matrix_int(golden, I*II*III, J*JJ*JJJ);

      }
}

// Free the resources allocated during initialization
void cleanup() {
/*  for(unsigned i = 0; i < num_devices; ++i) {
    if(kernel && kernel[i]) {
      clReleaseKernel(kernel[i]);
    }
    if(queue && queue[i]) {
      clReleaseCommandQueue(queue[i]);
    }
#if USE_SVM_API == 0
    if(input_a_buf && input_a_buf[i]) {
      clReleaseMemObject(input_a_buf[i]);
    }
    if(input_b_buf && input_b_buf[i]) {
      clReleaseMemObject(input_b_buf[i]);
    }
    if(output_buf && output_buf[i]) {
      clReleaseMemObject(output_buf[i]);
    }
#else
    if(input_a[i].get())
      input_a[i].reset();
    if(input_b[i].get())
      input_b[i].reset();
    if(output[i].get())
      output[i].reset();
#endif // USE_SVM_API == 0
  }

  if(program) {
    clReleaseProgram(program);
  }
  if(context) {
    clReleaseContext(context);
  }*/
}
