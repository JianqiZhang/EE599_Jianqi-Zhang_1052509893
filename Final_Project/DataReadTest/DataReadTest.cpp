#include "stdio.h"
#include <iostream>
#include <fstream>
#include<stdlib.h>
/* run this program using the console pauser or add your own getch, system("pause") or input loop */
using namespace std;
void initialize_array(short array[], const long int rows, const long int columns, char* filename)
{
	fstream infile;
	infile.open(filename);
	for (int i = 0; i < rows; ++i)
		for (int j = 0; j < columns; j++) {
			char temp;
			infile >> array[i * columns + j];
			temp = array[i*columns + j];
			printf("%d\t", temp);
			//cout<<temp;
			//cout<<'\t';
		}

	infile.close();
}

void print_matrix(char A[], int hA, int wA)
{
  for(int i=0; i < hA; ++i) {
    for(int j=0; j < wA; ++j) {
		printf("%d\t", A[i*wA + j]);
    }
    printf("\n");
  }
}

void print_matrix_int(int A[], int hA, int wA)
{
  for(int i=0; i < hA; ++i) {
    for(int j=0; j < wA; ++j) {
      printf("%d\t", A[i*wA + j]);
    }
    printf("\n");
  }
}

int main(int argc, char** argv) {

    const int III = 49;
    const int JJJ = 2;
    const int KKK = 3;
    const int II = 8;
    const int JJ = 4;
    const int KK = 3;
    const int I = 32;
    const int J = 4;
    const int K = 3;
    short *B;
    B = (short*)malloc(I*II*III*K*KK*KKK*sizeof(short));
	int *C;
    char temp;
    printf("Hello world!");
    fstream infile;
	infile.open("col_kernal.txt");
    //initialize_array(A, I*II*III, K*KK*KKK, "col_featuremap.txt");
    infile >> temp;
    printf("%c\t", temp);
    infile >> temp;
    printf("%c\t", temp);
    infile >> temp;
    printf("%c\t", temp);
	    infile >> temp;
    printf("%c\t", temp);    
    //printf("%d  %d\n",K*KK*KKK,J*JJ*JJJ);
    //initialize_array(B, K*KK*KKK, J*JJ*JJJ, "col_kernal.txt");
    //printf("Hello world!");
    //print_matrix(A, I*II*III, K*KK*KKK);
    //print_matrix(B, K*KK*KKK, J*JJ*JJJ);
	return 0;
}
