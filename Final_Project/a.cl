/*OpenCL C*/
//AOCX:/homes/jianqiz/tmp/a.aocx 
#pragma OPENCL FP_CONTRACT ON
#pragma OPENCL EXTENSION cl_intel_channels : enable
float float_from_bits(unsigned int x) {return as_float(x);}
float nan_f32() { return NAN; }
float neg_inf_f32() { return -INFINITY; }
float inf_f32() { return INFINITY; }

#define DPRINTF(...) //printf(__VA_ARGS__); for ( int f = 0; f < 64*1024; f++ ) printf("");

#define sqrt_f32 sqrt 
#define sin_f32 sin 
#define cos_f32 cos 
#define exp_f32 exp 
#define log_f32 log 
#define abs_f32 fabs 
#define floor_f32 floor 
#define ceil_f32 ceil 
#define round_f32 round 
#define trunc_f32 trunc 
#define pow_f32 pow
#define asin_f32 asin 
#define acos_f32 acos 
#define tan_f32 tan 
#define atan_f32 atan 
#define atan2_f32 atan2
#define sinh_f32 sinh 
#define asinh_f32 asinh 
#define cosh_f32 cosh 
#define acosh_f32 acosh 
#define tanh_f32 tanh 
#define atanh_f32 atanh 
#define fast_inverse_f32 native_recip 
#define fast_inverse_sqrt_f32 native_rsqrt 
int halide_gpu_thread_barrier() {
  barrier(CLK_LOCAL_MEM_FENCE);
  return 0;
}
#define __address_space___shared __local

typedef struct {float data; bool drain_signal; } float_channel_drain_struct_;
channel char3 _A_loader_0_channel[8] __attribute__((depth(2))) ;
// Address spaces for kernel_A_loader_channel
#define __address_space__A_serializer_mem_channel __global
__kernel void kernel_A_loader_channel(
 const int _C_deserializer_extent_0,
 const int _C_deserializer_extent_1,
 __address_space__A_serializer_mem_channel const char3 *_A_serializer_mem_channel,
 __address_space___shared int16* __shared)
{
 int _A_loader_s0_k__x_k__x___k__x___kk__x___iii___ii__flattened_loop__no_loop_counter;
 int _0 = _C_deserializer_extent_1 + 783;
 int _1 = _0 / 392;
 int _2 = _1 * 392;
 int _3 = _0 - _2;
 int _4 = _3 >> 31;
 int _5 = 392 >> 31;
 int _6 = _4 & _5;
 int _7 = _1 - _6;
 int _8 = ~_5;
 int _9 = _4 & _8;
 int _10 = _7 + _9;
 for (int _A_loader_s0_i_i = 0; _A_loader_s0_i_i < 0 + _10; _A_loader_s0_i_i++)
 {
  int _11;
  int _12 = _C_deserializer_extent_1 + 391;
  int _13 = _12 / 392;
  int _14 = _13 * 392;
  int _15 = _12 - _14;
  int _16 = _15 >> 31;
  int _17 = 392 >> 31;
  int _18 = _16 & _17;
  int _19 = _13 - _18;
  int _20 = ~_17;
  int _21 = _16 & _20;
  int _22 = _19 + _21;
  bool _23 = _A_loader_s0_i_i == _22;
  if (_23)
  {
   _11 = 1;
  } // if _23
  else
  {
   int _24 = _C_deserializer_extent_0 + 7;
   int _25 = _24 >> 3;
   _11 = _25;
  } // if _23 else
  for (int _A_loader_s0_j_j = 0; _A_loader_s0_j_j < 0 + _11; _A_loader_s0_j_j++)
  {
   for (int _A_loader_s0_k__x_k__x___k__x___kk__x___iii___ii__flattened_loop__no_loop_counter = 0; _A_loader_s0_k__x_k__x___k__x___kk__x___iii___ii__flattened_loop__no_loop_counter < 0 + 8192; )
   {
    // block start
    int _26 = _A_loader_s0_i_i * 3;
    int _27 = _A_loader_s0_k__x_k__x___k__x___kk__x___iii___ii__flattened_loop__no_loop_counter >> 11;
    int _28 = _26 + _27;
    int _29 = _28 * 3;
    int _30 = _A_loader_s0_k__x_k__x___k__x___kk__x___iii___ii__flattened_loop__no_loop_counter & 2047;
    int _31 = _30 >> 9;
    int _32 = _29 + _31;
    int _33 = _32 * 49;
    int _34 = _A_loader_s0_k__x_k__x___k__x___kk__x___iii___ii__flattened_loop__no_loop_counter & 511;
    int _35 = _34 >> 3;
    int _36 = _33 + _35;
    int _37 = _36 * 8;
    int _38 = _A_loader_s0_k__x_k__x___k__x___kk__x___iii___ii__flattened_loop__no_loop_counter & 7;
    int _39 = _37 + _38;
    char3 _40 = _A_serializer_mem_channel[_39];
    DPRINTF ("A_loader: write_channel _A_loader_0_channel data: %f, %f, %f\n",_40[0],_40[1],_40[2]);
    write_channel_intel(_A_loader_0_channel[0], _40);
    // block start
        int _41 = _A_loader_s0_k__x_k__x___k__x___kk__x___iii___ii__flattened_loop__no_loop_counter + 1;
    _A_loader_s0_k__x_k__x___k__x___kk__x___iii___ii__flattened_loop__no_loop_counter = _41;
    // block start
    int _42 = _A_loader_s0_k__x_k__x___k__x___kk__x___iii___ii__flattened_loop__no_loop_counter & 511;
    bool _43 = _42 == 392;
    if (_43)
    {
          int _44 = _A_loader_s0_k__x_k__x___k__x___kk__x___iii___ii__flattened_loop__no_loop_counter + 120;
     _A_loader_s0_k__x_k__x___k__x___kk__x___iii___ii__flattened_loop__no_loop_counter = _44;
    } // if _43
    // block start
    int _45 = _A_loader_s0_k__x_k__x___k__x___kk__x___iii___ii__flattened_loop__no_loop_counter & 2047;
    bool _46 = _45 == 1536;
    if (_46)
    {
          int _47 = _A_loader_s0_k__x_k__x___k__x___kk__x___iii___ii__flattened_loop__no_loop_counter + 512;
     _A_loader_s0_k__x_k__x___k__x___kk__x___iii___ii__flattened_loop__no_loop_counter = _47;
    } // if _46
    int _48 = _A_loader_s0_k__x_k__x___k__x___kk__x___iii___ii__flattened_loop__no_loop_counter & 8191;
    bool _49 = _48 == 6144;
    if (_49)
    {
          int _50 = _A_loader_s0_k__x_k__x___k__x___kk__x___iii___ii__flattened_loop__no_loop_counter + 2048;
     _A_loader_s0_k__x_k__x___k__x___kk__x___iii___ii__flattened_loop__no_loop_counter = _50;
    } // if _49
    // block end
    // block end
    // block end
    // block end
   } // for _A_loader_s0_k__x_k__x___k__x___kk__x___iii___ii__flattened_loop__no_loop_counter
  } // for _A_loader_s0_j_j
 } // for _A_loader_s0_i_i
} // kernel kernel_A_loader_channel
#undef __address_space__A_serializer_mem_channel
channel char3 _A_feeder_0_channel[8][4] __attribute__((depth(2))) ;
// Address spaces for kernel_A_feeder_channel

__attribute__((max_global_work_dim(0)))__attribute__((autorun))

__attribute__((num_compute_units(8, 1, 1)))
__kernel void kernel_A_feeder_channel(
)
{
 int _51 = get_compute_id(0);
;
 char3 _A_feeder_0_ibuffer[2];
 bool _write_success;
 bool _read_success;
 int _first;
 int _A_feeder_s0_w;
 int _A_feeder_s0_r;
 int _A_feeder_s0__scatter_loop;
 int _A_feeder_s0__scatter_feed_loop__no_loop_counter;
 int _A_feeder_s0__feed_loop;
 // block start
  bool _52 = (bool)(0);
 _write_success = _52;
 // block start
  bool _53 = (bool)(0);
 _read_success = _53;
 // block start
  _first = 1;
 // block start
  _A_feeder_s0_w = 0;
 // block start
  _A_feeder_s0_r = 1;
 // block start
  _A_feeder_s0__scatter_loop = 0;
 // block start
  _A_feeder_s0__scatter_feed_loop__no_loop_counter = 0;
 // block start
  _A_feeder_s0__feed_loop = 0;
 int _A_feeder_s0_k__x_k__x___k__x___kk__x___iii__flattened_loop__no_loop_counter;
 while (1)
 {
  for (int _A_feeder_s0_k__x_k__x___k__x___kk__x___iii__flattened_loop__no_loop_counter = 0; _A_feeder_s0_k__x_k__x___k__x___kk__x___iii__flattened_loop__no_loop_counter < 0 + 1024; )
  {
   int _54 = 10 - _51;
   for (int _A_feeder_s0__scatter_feed_loop__no_loop_counter = 0; _A_feeder_s0__scatter_feed_loop__no_loop_counter < 0 + _54; )
   {
    // block start
    int _55 = 8 - _51;
    bool _56 = _A_feeder_s0__scatter_loop < _55;
    if (_56)
    {
     char3 _57;
     DPRINTF ("A_feeder(%d): To read_channel_nb _A_loader_0_channel\n",_51);
     _57 = read_channel_nb_intel(_A_loader_0_channel[_51], &_read_success);
     DPRINTF ("A_feeder(%d): read_channel_nb _A_loader_0_channel data: %f, %f, %f\n",_51,_57[0],_57[1],_57[2]);
     bool _58 = _A_feeder_s0__scatter_loop < 1;
     bool _59 = _read_success && _58;
     if (_59)
     {
      // block start
      _A_feeder_0_ibuffer[_A_feeder_s0_w] = _57;
      // block start
            int _60 = _A_feeder_s0__scatter_loop + 1;
      _A_feeder_s0__scatter_loop = _60;
            int _61 = _A_feeder_s0__scatter_feed_loop__no_loop_counter + 1;
      _A_feeder_s0__scatter_feed_loop__no_loop_counter = _61;
      // block end
      // block end
     } // if _59
     else
     {
      if (_read_success)
      {
       // block start
       int _62 = _51 + 1;
       DPRINTF ("A_feeder(%d): write_channel _A_loader_0_channel data: %f, %f, %f\n",_51,_57[0],_57[1],_57[2]);
       write_channel_intel(_A_loader_0_channel[_62], _57);
       // block start
              int _63 = _A_feeder_s0__scatter_loop + 1;
       _A_feeder_s0__scatter_loop = _63;
              int _64 = _A_feeder_s0__scatter_feed_loop__no_loop_counter + 1;
       _A_feeder_s0__scatter_feed_loop__no_loop_counter = _64;
       // block end
       // block end
      } // if _read_success
     } // if _59 else
    } // if _56
    // block start
    bool _65 = _A_feeder_s0__feed_loop < 2;
    if (_65)
    {
     // block start
     bool _66 = !(_first);
     if (_66)
     {
      char3 _67 = _A_feeder_0_ibuffer[_A_feeder_s0_r];
      DPRINTF ("A_feeder(%d): write_channel_nb _A_feeder_0_channel data: %f, %f, %f\n",_51,_67[0],_67[1],_67[2]);
      _write_success = write_channel_nb_intel(_A_feeder_0_channel[_51][0], _67);
      (void)_67;
     } // if _66
     bool _68 = _first || _write_success;
     if (_68)
     {
      // block start
            int _69 = _A_feeder_s0__feed_loop + 1;
      _A_feeder_s0__feed_loop = _69;
            int _70 = _A_feeder_s0__scatter_feed_loop__no_loop_counter + 1;
      _A_feeder_s0__scatter_feed_loop__no_loop_counter = _70;
      // block end
     } // if _68
     // block end
    } // if _65
    // block start
    int _71 = _A_feeder_s0__scatter_loop + _51;
    bool _72 = _71 == 8;
    bool _73 = _A_feeder_s0__feed_loop == 2;
    bool _74 = _72 && _73;
    if (_74)
    {
     // block start
          bool _75 = (bool)(0);
     _first = _75;
     // block start
          bool _76 = (bool)(_A_feeder_s0_w);
     bool _77 = !(_76);
     _A_feeder_s0_w = _77;
     // block start
          bool _78 = (bool)(_A_feeder_s0_r);
     bool _79 = !(_78);
     _A_feeder_s0_r = _79;
     // block start
          _A_feeder_s0__scatter_loop = 0;
          _A_feeder_s0__feed_loop = 0;
     // block end
     // block end
     // block end
     // block end
    } // if _74
    int _80 = _A_feeder_s0__scatter_feed_loop__no_loop_counter + _51;
    bool _81 = _80 == 9;
    if (_81)
    {
     // block start
          int _82 = _A_feeder_s0_k__x_k__x___k__x___kk__x___iii__flattened_loop__no_loop_counter + 1;
     _A_feeder_s0_k__x_k__x___k__x___kk__x___iii__flattened_loop__no_loop_counter = _82;
     // block start
     int _83 = _A_feeder_s0_k__x_k__x___k__x___kk__x___iii__flattened_loop__no_loop_counter & 63;
     bool _84 = _83 == 49;
     if (_84)
     {
            int _85 = _A_feeder_s0_k__x_k__x___k__x___kk__x___iii__flattened_loop__no_loop_counter + 15;
      _A_feeder_s0_k__x_k__x___k__x___kk__x___iii__flattened_loop__no_loop_counter = _85;
     } // if _84
     // block start
     int _86 = _A_feeder_s0_k__x_k__x___k__x___kk__x___iii__flattened_loop__no_loop_counter & 255;
     bool _87 = _86 == 192;
     if (_87)
     {
            int _88 = _A_feeder_s0_k__x_k__x___k__x___kk__x___iii__flattened_loop__no_loop_counter + 64;
      _A_feeder_s0_k__x_k__x___k__x___kk__x___iii__flattened_loop__no_loop_counter = _88;
     } // if _87
     int _89 = _A_feeder_s0_k__x_k__x___k__x___kk__x___iii__flattened_loop__no_loop_counter & 1023;
     bool _90 = _89 == 768;
     if (_90)
     {
            int _91 = _A_feeder_s0_k__x_k__x___k__x___kk__x___iii__flattened_loop__no_loop_counter + 256;
      _A_feeder_s0_k__x_k__x___k__x___kk__x___iii__flattened_loop__no_loop_counter = _91;
     } // if _90
     // block end
     // block end
     // block end
    } // if _81
    // block end
    // block end
    // block end
   } // for _A_feeder_s0__scatter_feed_loop__no_loop_counter
  } // for _A_feeder_s0_k__x_k__x___k__x___kk__x___iii__flattened_loop__no_loop_counter
 } // while _A_feeder_s0_i_i_infinite
 // block end
 // block end
 // block end
 // block end
 // block end
 // block end
 // block end
 // block end
} // kernel kernel_A_feeder_channel
channel char3 _B_loader_0_channel[4] __attribute__((depth(2))) ;
// Address spaces for kernel_B_loader_channel
#define __address_space__B_serializer_mem_channel __global
__kernel void kernel_B_loader_channel(
 const int _C_deserializer_extent_0,
 const int _C_deserializer_extent_1,
 __address_space__B_serializer_mem_channel const char3 *_B_serializer_mem_channel,
 __address_space___shared int16* __shared)
{
 int _B_loader_s0_k__x_k__x___k__x___kk__x___jj___jjj__flattened_loop__no_loop_counter;
 int _92 = _C_deserializer_extent_1 + 783;
 int _93 = _92 / 392;
 int _94 = _93 * 392;
 int _95 = _92 - _94;
 int _96 = _95 >> 31;
 int _97 = 392 >> 31;
 int _98 = _96 & _97;
 int _99 = _93 - _98;
 int _100 = ~_97;
 int _101 = _96 & _100;
 int _102 = _99 + _101;
 for (int _B_loader_s0_i_i = 0; _B_loader_s0_i_i < 0 + _102; _B_loader_s0_i_i++)
 {
  int _103;
  int _104 = _C_deserializer_extent_1 + 391;
  int _105 = _104 / 392;
  int _106 = _105 * 392;
  int _107 = _104 - _106;
  int _108 = _107 >> 31;
  int _109 = 392 >> 31;
  int _110 = _108 & _109;
  int _111 = _105 - _110;
  int _112 = ~_109;
  int _113 = _108 & _112;
  int _114 = _111 + _113;
  bool _115 = _B_loader_s0_i_i == _114;
  if (_115)
  {
   _103 = 1;
  } // if _115
  else
  {
   int _116 = _C_deserializer_extent_0 + 7;
   int _117 = _116 >> 3;
   _103 = _117;
  } // if _115 else
  for (int _B_loader_s0_j_j = 0; _B_loader_s0_j_j < 0 + _103; _B_loader_s0_j_j++)
  {
   for (int _B_loader_s0_k__x_k__x___k__x___kk__x___jj___jjj__flattened_loop__no_loop_counter = 0; _B_loader_s0_k__x_k__x___k__x___kk__x___jj___jjj__flattened_loop__no_loop_counter < 0 + 128; )
   {
    // block start
    int _118 = _B_loader_s0_j_j * 3;
    int _119 = _B_loader_s0_k__x_k__x___k__x___kk__x___jj___jjj__flattened_loop__no_loop_counter >> 5;
    int _120 = _118 + _119;
    int _121 = _120 * 3;
    int _122 = _B_loader_s0_k__x_k__x___k__x___kk__x___jj___jjj__flattened_loop__no_loop_counter & 31;
    int _123 = _122 >> 3;
    int _124 = _121 + _123;
    int _125 = _124 * 4;
    int _126 = _B_loader_s0_k__x_k__x___k__x___kk__x___jj___jjj__flattened_loop__no_loop_counter & 7;
    int _127 = _126 >> 1;
    int _128 = _125 + _127;
    int _129 = _128 * 2;
    int _130 = _B_loader_s0_k__x_k__x___k__x___kk__x___jj___jjj__flattened_loop__no_loop_counter & 1;
    int _131 = _129 + _130;
    char3 _132 = _B_serializer_mem_channel[_131];
    DPRINTF ("B_loader: write_channel _B_loader_0_channel data: %f, %f, %f\n",_132[0],_132[1],_132[2]);
    write_channel_intel(_B_loader_0_channel[0], _132);
    // block start
        int _133 = _B_loader_s0_k__x_k__x___k__x___kk__x___jj___jjj__flattened_loop__no_loop_counter + 1;
    _B_loader_s0_k__x_k__x___k__x___kk__x___jj___jjj__flattened_loop__no_loop_counter = _133;
    // block start
    int _134 = _B_loader_s0_k__x_k__x___k__x___kk__x___jj___jjj__flattened_loop__no_loop_counter & 31;
    bool _135 = _134 == 24;
    if (_135)
    {
          int _136 = _B_loader_s0_k__x_k__x___k__x___kk__x___jj___jjj__flattened_loop__no_loop_counter + 8;
     _B_loader_s0_k__x_k__x___k__x___kk__x___jj___jjj__flattened_loop__no_loop_counter = _136;
    } // if _135
    int _137 = _B_loader_s0_k__x_k__x___k__x___kk__x___jj___jjj__flattened_loop__no_loop_counter & 127;
    bool _138 = _137 == 96;
    if (_138)
    {
          int _139 = _B_loader_s0_k__x_k__x___k__x___kk__x___jj___jjj__flattened_loop__no_loop_counter + 32;
     _B_loader_s0_k__x_k__x___k__x___kk__x___jj___jjj__flattened_loop__no_loop_counter = _139;
    } // if _138
    // block end
    // block end
    // block end
   } // for _B_loader_s0_k__x_k__x___k__x___kk__x___jj___jjj__flattened_loop__no_loop_counter
  } // for _B_loader_s0_j_j
 } // for _B_loader_s0_i_i
} // kernel kernel_B_loader_channel
#undef __address_space__B_serializer_mem_channel
channel char3 _B_feeder_0_channel[4][8] __attribute__((depth(2))) ;
// Address spaces for kernel_B_feeder_channel__autorun__run_on_device_140

__attribute__((max_global_work_dim(0)))__attribute__((autorun))

__attribute__((num_compute_units(4, 1, 1)))
__kernel void kernel_B_feeder_channel__autorun__run_on_device_140(
)
{
 int _141 = get_compute_id(0);
;
 char3 _B_feeder_0_ibuffer[2][2];
 bool _write_success;
 bool _read_success;
 int _first;
 int _B_feeder_s0_w;
 int _B_feeder_s0_r;
 int _B_feeder_s0__scatter_loop;
 int _B_feeder_s0__scatter_feed_loop__no_loop_counter;
 int _B_feeder_s0__feed_loop;
 // block start
  bool _142 = (bool)(0);
 _write_success = _142;
 // block start
  bool _143 = (bool)(0);
 _read_success = _143;
 // block start
  _first = 1;
 // block start
  _B_feeder_s0_w = 0;
 // block start
  _B_feeder_s0_r = 1;
 // block start
  _B_feeder_s0__scatter_loop = 0;
 // block start
  _B_feeder_s0__scatter_feed_loop__no_loop_counter = 0;
 // block start
  _B_feeder_s0__feed_loop = 0;
 int _B_feeder_s0_k__x_k__x___k__x___kk__x__flattened_loop__no_loop_counter;
 while (1)
 {
  for (int _B_feeder_s0_k__x_k__x___k__x___kk__x__flattened_loop__no_loop_counter = 0; _B_feeder_s0_k__x_k__x___k__x___kk__x__flattened_loop__no_loop_counter < 0 + 16; )
  {
   int _144 = 4 - _141;
   int _145 = _144 * 2;
   int _146 = _145 + 98;
   for (int _B_feeder_s0__scatter_feed_loop__no_loop_counter = 0; _B_feeder_s0__scatter_feed_loop__no_loop_counter < 0 + _146; )
   {
    // block start
    int _147 = 4 - _141;
    int _148 = _147 * 2;
    bool _149 = _B_feeder_s0__scatter_loop < _148;
    if (_149)
    {
     char3 _150;
     DPRINTF ("B_feeder(%d): To read_channel_nb _B_loader_0_channel\n",_141);
     _150 = read_channel_nb_intel(_B_loader_0_channel[_141], &_read_success);
     DPRINTF ("B_feeder(%d): read_channel_nb _B_loader_0_channel data: %f, %f, %f\n",_141,_150[0],_150[1],_150[2]);
     bool _151 = _B_feeder_s0__scatter_loop < 2;
     bool _152 = _read_success && _151;
     if (_152)
     {
      // block start
      int _153 = _B_feeder_s0__scatter_loop & 1;
      _B_feeder_0_ibuffer[_B_feeder_s0_w][_153] = _150;
      // block start
            int _154 = _B_feeder_s0__scatter_loop + 1;
      _B_feeder_s0__scatter_loop = _154;
            int _155 = _B_feeder_s0__scatter_feed_loop__no_loop_counter + 1;
      _B_feeder_s0__scatter_feed_loop__no_loop_counter = _155;
      // block end
      // block end
     } // if _152
     else
     {
      if (_read_success)
      {
       // block start
       int _156 = _141 + 1;
       DPRINTF ("B_feeder(%d): write_channel _B_loader_0_channel data: %f, %f, %f\n",_141,_150[0],_150[1],_150[2]);
       write_channel_intel(_B_loader_0_channel[_156], _150);
       // block start
              int _157 = _B_feeder_s0__scatter_loop + 1;
       _B_feeder_s0__scatter_loop = _157;
              int _158 = _B_feeder_s0__scatter_feed_loop__no_loop_counter + 1;
       _B_feeder_s0__scatter_feed_loop__no_loop_counter = _158;
       // block end
       // block end
      } // if _read_success
     } // if _152 else
    } // if _149
    // block start
    bool _159 = _B_feeder_s0__feed_loop < 98;
    if (_159)
    {
     // block start
     bool _160 = !(_first);
     if (_160)
     {
      int _161 = _B_feeder_s0__feed_loop & 1;
      char3 _162 = _B_feeder_0_ibuffer[_B_feeder_s0_r][_161];
      DPRINTF ("B_feeder(%d): write_channel_nb _B_feeder_0_channel data: %f, %f, %f\n",_141,_162[0],_162[1],_162[2]);
      _write_success = write_channel_nb_intel(_B_feeder_0_channel[_141][0], _162);
      (void)_162;
     } // if _160
     bool _163 = _first || _write_success;
     if (_163)
     {
      // block start
            int _164 = _B_feeder_s0__feed_loop + 1;
      _B_feeder_s0__feed_loop = _164;
            int _165 = _B_feeder_s0__scatter_feed_loop__no_loop_counter + 1;
      _B_feeder_s0__scatter_feed_loop__no_loop_counter = _165;
      // block end
     } // if _163
     // block end
    } // if _159
    // block start
    int _166 = 4 - _141;
    int _167 = _166 * 2;
    bool _168 = _B_feeder_s0__scatter_loop == _167;
    bool _169 = _B_feeder_s0__feed_loop == 98;
    bool _170 = _168 && _169;
    if (_170)
    {
     // block start
          bool _171 = (bool)(0);
     _first = _171;
     // block start
          bool _172 = (bool)(_B_feeder_s0_w);
     bool _173 = !(_172);
     _B_feeder_s0_w = _173;
     // block start
          bool _174 = (bool)(_B_feeder_s0_r);
     bool _175 = !(_174);
     _B_feeder_s0_r = _175;
     // block start
          _B_feeder_s0__scatter_loop = 0;
          _B_feeder_s0__feed_loop = 0;
     // block end
     // block end
     // block end
     // block end
    } // if _170
    int _176 = 4 - _141;
    int _177 = _176 * 2;
    int _178 = _B_feeder_s0__scatter_feed_loop__no_loop_counter - _177;
    bool _179 = _178 == 97;
    if (_179)
    {
     // block start
          int _180 = _B_feeder_s0_k__x_k__x___k__x___kk__x__flattened_loop__no_loop_counter + 1;
     _B_feeder_s0_k__x_k__x___k__x___kk__x__flattened_loop__no_loop_counter = _180;
     // block start
     int _181 = _B_feeder_s0_k__x_k__x___k__x___kk__x__flattened_loop__no_loop_counter & 3;
     bool _182 = _181 == 3;
     if (_182)
     {
            int _183 = _B_feeder_s0_k__x_k__x___k__x___kk__x__flattened_loop__no_loop_counter + 1;
      _B_feeder_s0_k__x_k__x___k__x___kk__x__flattened_loop__no_loop_counter = _183;
     } // if _182
     int _184 = _B_feeder_s0_k__x_k__x___k__x___kk__x__flattened_loop__no_loop_counter & 15;
     bool _185 = _184 == 12;
     if (_185)
     {
            int _186 = _B_feeder_s0_k__x_k__x___k__x___kk__x__flattened_loop__no_loop_counter + 4;
      _B_feeder_s0_k__x_k__x___k__x___kk__x__flattened_loop__no_loop_counter = _186;
     } // if _185
     // block end
     // block end
    } // if _179
    // block end
    // block end
    // block end
   } // for _B_feeder_s0__scatter_feed_loop__no_loop_counter
  } // for _B_feeder_s0_k__x_k__x___k__x___kk__x__flattened_loop__no_loop_counter
 } // while _B_feeder_s0_i_i_infinite
 // block end
 // block end
 // block end
 // block end
 // block end
 // block end
 // block end
 // block end
} // kernel kernel_B_feeder_channel__autorun__run_on_device_140
channel int _C_0_channel[8][4] __attribute__((depth(2))) ;
// Address spaces for kernel_C_channel

__attribute__((max_global_work_dim(0)))__attribute__((autorun))

__attribute__((num_compute_units(8, 4, 1)))
__kernel void kernel_C_channel(
)
{
 bool first = true;
 char3 _rch_1;
 char3 _rch_0;
 int _187 = get_compute_id(0);
;
 int _188 = get_compute_id(1);
;
 int _C_0_ibuffer[98];
 // block start
 #pragma unroll
 for (int _C_s1_j_jj_jjj__scan_elem__C_s1_i_ii_iii__scan_elem_ = 0; _C_s1_j_jj_jjj__scan_elem__C_s1_i_ii_iii__scan_elem_ < 0 + 98; _C_s1_j_jj_jjj__scan_elem__C_s1_i_ii_iii__scan_elem_++)
 {
  _C_0_ibuffer[_C_s1_j_jj_jjj__scan_elem__C_s1_i_ii_iii__scan_elem_] = 0;
 } // for _C_s1_j_jj_jjj__scan_elem__C_s1_i_ii_iii__scan_elem_
 int _C_s1_k__x_k__x___k__x___kk__x___iii___jjj__flattened_loop__no_loop_counter;
 while (1)
 {
  for (int _C_s1_k__x_k__x___k__x___kk__x___iii___jjj__flattened_loop__no_loop_counter = 0; _C_s1_k__x_k__x___k__x___kk__x___iii___jjj__flattened_loop__no_loop_counter < 0 + 2048; )
  {
   // block start
   char3 _189;
   DPRINTF ("C(%d,%d): To read_channel _A_feeder_0_channel\n",_187,_188);
   _189 = read_channel_intel(_A_feeder_0_channel[_187][_188]);
   DPRINTF ("C(%d,%d): read_channel _A_feeder_0_channel data: %f, %f, %f\n",_187,_188,_189[0],_189[1],_189[2]);
   // block start
   bool _190 = _188 < 3;
   if (_190)
   {
    int _191 = _188 + 1;
    DPRINTF ("C(%d,%d): write_channel _A_feeder_0_channel data: %f, %f, %f\n",_187,_188,_189[0],_189[1],_189[2]);
    write_channel_intel(_A_feeder_0_channel[_187][_191], _189);
   } // if _190
      _rch_0 = _189;
   // block end
   // block start
   char3 _192;
   DPRINTF ("C(%d,%d): To read_channel _B_feeder_0_channel\n",_187,_188);
   _192 = read_channel_intel(_B_feeder_0_channel[_188][_187]);
   DPRINTF ("C(%d,%d): read_channel _B_feeder_0_channel data: %f, %f, %f\n",_187,_188,_192[0],_192[1],_192[2]);
   // block start
   bool _193 = _187 < 7;
   if (_193)
   {
    int _194 = _187 + 1;
    DPRINTF ("C(%d,%d): write_channel _B_feeder_0_channel data: %f, %f, %f\n",_187,_188,_192[0],_192[1],_192[2]);
    write_channel_intel(_B_feeder_0_channel[_188][_194], _192);
   } // if _193
      _rch_1 = _192;
   // block end
   // block start
   int _c;
   // block start
      int _195 = _C_0_ibuffer[0];
   _c = _195;
   // block start
   int _196 = _C_s1_k__x_k__x___k__x___kk__x___iii___jjj__flattened_loop__no_loop_counter >> 9;
   bool _197 = _196 == 0;
   int _198 = _C_s1_k__x_k__x___k__x___kk__x___iii___jjj__flattened_loop__no_loop_counter & 511;
   int _199 = _198 >> 7;
   bool _200 = _199 == 0;
   bool _201 = _197 && _200;
   if(!_197)
		first = false;
   if (_201 && !first)
   {
    DPRINTF ("C(%d,%d): write_channel _C_0_channel data: %f\n",_187,_188,_c);
    write_channel_intel(_C_0_channel[_187][_188], _c);
   } // if _201
   int _sum;
   // block start
      _sum = 0;
   // block start
   #pragma unroll
   for (int _C_s1_k__x_kk__x_kkk__x = 0; _C_s1_k__x_kk__x_kkk__x < 0 + 3; _C_s1_k__x_kk__x_kkk__x++)
   {
        char _202 = _rch_0[_C_s1_k__x_kk__x_kkk__x] * _rch_1[_C_s1_k__x_kk__x_kkk__x];
    int _203 = (int)(_202);
    int _204 = _sum + _203;
    _sum = _204;
   } // for _C_s1_k__x_kk__x_kkk__x
   // block start
   #pragma unroll
   for (int _C_s1_z_rot = 0; _C_s1_z_rot < 0 + 97; _C_s1_z_rot++)
   {
    int _205 = _C_s1_z_rot + 1;
    int _206 = _C_0_ibuffer[_205];
    _C_0_ibuffer[_C_s1_z_rot] = _206;
   } // for _C_s1_z_rot
   int _207;
   int _208 = _C_s1_k__x_k__x___k__x___kk__x___iii___jjj__flattened_loop__no_loop_counter >> 9;
   bool _209 = _208 == 0;
   int _210 = _C_s1_k__x_k__x___k__x___kk__x___iii___jjj__flattened_loop__no_loop_counter & 511;
   int _211 = _210 >> 7;
   bool _212 = _211 == 0;
   bool _213 = _209 && _212;
   if (_213)
   {
    _207 = _sum;
   } // if _213
   else
   {
    int _214 = _sum + _c;
    _207 = _214;
   } // if _213 else
   _C_0_ibuffer[97] = _207;
   // block end
   // block end
   // block end
   // block end
   // block end
   // block start
      int _215 = _C_s1_k__x_k__x___k__x___kk__x___iii___jjj__flattened_loop__no_loop_counter + 1;
   _C_s1_k__x_k__x___k__x___kk__x___iii___jjj__flattened_loop__no_loop_counter = _215;
   // block start
   int _216 = _C_s1_k__x_k__x___k__x___kk__x___iii___jjj__flattened_loop__no_loop_counter & 127;
   bool _217 = _216 == 98;
   if (_217)
   {
        int _218 = _C_s1_k__x_k__x___k__x___kk__x___iii___jjj__flattened_loop__no_loop_counter + 30;
    _C_s1_k__x_k__x___k__x___kk__x___iii___jjj__flattened_loop__no_loop_counter = _218;
   } // if _217
   // block start
   int _219 = _C_s1_k__x_k__x___k__x___kk__x___iii___jjj__flattened_loop__no_loop_counter & 511;
   bool _220 = _219 == 384;
   if (_220)
   {
        int _221 = _C_s1_k__x_k__x___k__x___kk__x___iii___jjj__flattened_loop__no_loop_counter + 128;
    _C_s1_k__x_k__x___k__x___kk__x___iii___jjj__flattened_loop__no_loop_counter = _221;
   } // if _220
   int _222 = _C_s1_k__x_k__x___k__x___kk__x___iii___jjj__flattened_loop__no_loop_counter & 2047;
   bool _223 = _222 == 1536;
   if (_223)
   {
        int _224 = _C_s1_k__x_k__x___k__x___kk__x___iii___jjj__flattened_loop__no_loop_counter + 512;
    _C_s1_k__x_k__x___k__x___kk__x___iii___jjj__flattened_loop__no_loop_counter = _224;
   } // if _223
   // block end
   // block end
   // block end
   // block end
   // block end
   // block end
  } // for _C_s1_k__x_k__x___k__x___kk__x___iii___jjj__flattened_loop__no_loop_counter
 } // while _C_s1_i_i_infinite
 // block end
} // kernel kernel_C_channel
channel int _C_drainer_0_channel[8][4] __attribute__((depth(2))) ;
// Address spaces for kernel_C_drainer_channel

__attribute__((max_global_work_dim(0)))__attribute__((autorun))

__attribute__((num_compute_units(8, 4, 1)))
__kernel void kernel_C_drainer_channel(
)
{
 int _225 = get_compute_id(0);
;
 int _226 = get_compute_id(1);
;
 int _C_drainer_s0_i_ii_iii___iii___jjj__flattened_loop__no_loop_counter;
 while (1)
 {
  for (int _C_drainer_s0_i_ii_iii___iii___jjj__flattened_loop__no_loop_counter = 0; _C_drainer_s0_i_ii_iii___iii___jjj__flattened_loop__no_loop_counter < 0 + 128; )
  {
   int _227 = 8 - _225;
   for (int _C_drainer_s0_t__gather_elem_ = 0; _C_drainer_s0_t__gather_elem_ < 0 + _227; _C_drainer_s0_t__gather_elem_++)
   {
    // block start
    int _228;
    bool _229 = _C_drainer_s0_t__gather_elem_ == 0;
    if (_229)
    {
     int _230;
     DPRINTF ("C_drainer(%d,%d): To read_channel _C_0_channel\n",_225,_226);
     _230 = read_channel_intel(_C_0_channel[_225][_226]);
     DPRINTF ("C_drainer(%d,%d): read_channel _C_0_channel data: %f\n",_225,_226,_230);
     _228 = _230;
    } // if _229
    else
    {
     int _231 = _225 + 1;
     int _232;
     DPRINTF ("C_drainer(%d,%d): To read_channel _C_drainer_0_channel\n",_225,_226);
     _232 = read_channel_intel(_C_drainer_0_channel[_231][_226]);
     DPRINTF ("C_drainer(%d,%d): read_channel _C_drainer_0_channel data: %f\n",_225,_226,_232);
     _228 = _232;
    } // if _229 else
    DPRINTF ("C_drainer(%d,%d): write_channel _C_drainer_0_channel data: %f\n",_225,_226,_228);
    write_channel_intel(_C_drainer_0_channel[_225][_226], _228);
    int _233 = _C_drainer_s0_t__gather_elem_ + _225;
    bool _234 = _233 == 7;
    if (_234)
    {
     // block start
          int _235 = _C_drainer_s0_i_ii_iii___iii___jjj__flattened_loop__no_loop_counter + 1;
     _C_drainer_s0_i_ii_iii___iii___jjj__flattened_loop__no_loop_counter = _235;
     int _236 = _C_drainer_s0_i_ii_iii___iii___jjj__flattened_loop__no_loop_counter & 127;
     bool _237 = _236 == 98;
     if (_237)
     {
            int _238 = _C_drainer_s0_i_ii_iii___iii___jjj__flattened_loop__no_loop_counter + 30;
      _C_drainer_s0_i_ii_iii___iii___jjj__flattened_loop__no_loop_counter = _238;
     } // if _237
     // block end
    } // if _234
    // block end
   } // for _C_drainer_s0_t__gather_elem_
  } // for _C_drainer_s0_i_ii_iii___iii___jjj__flattened_loop__no_loop_counter
 } // while _C_drainer_s0_i_i_infinite
} // kernel kernel_C_drainer_channel
channel int4 _C_collector_0_channel[4] __attribute__((depth(2))) ;
// Address spaces for kernel_C_collector_channel

__attribute__((max_global_work_dim(0)))__attribute__((autorun))

__attribute__((num_compute_units(4, 1, 1)))
__kernel void kernel_C_collector_channel(
)
{
 int4 _rch;
 int _prch;
 int4 _grch;
 int _239 = get_compute_id(0);
;
 int _C_collector_s0_i_ii_ii___ii___iii___jjj__flattened_loop__no_loop_counter;
 while (1)
 {
  for (int _C_collector_s0_i_ii_ii___ii___iii___jjj__flattened_loop__no_loop_counter = 0; _C_collector_s0_i_ii_ii___ii___iii___jjj__flattened_loop__no_loop_counter < 0 + 1024; )
  {
   // block start
      int _240;
   DPRINTF ("C_collector(%d): To read_channel _C_drainer_0_channel\n",_239);
   _240 = read_channel_intel(_C_drainer_0_channel[0][_239]);
   DPRINTF ("C_collector(%d): read_channel _C_drainer_0_channel data: %f\n",_239,_240);
   _prch = _240;
   // block start
   bool _241 = _239 < 3;
   if (_241)
   {
        int _242 = _239 + 1;
    int4 _243;
    DPRINTF ("C_collector(%d): To read_channel _C_collector_0_channel\n",_239);
    _243 = read_channel_intel(_C_collector_0_channel[_242]);
    DPRINTF ("C_collector(%d): read_channel _C_collector_0_channel data: %f, %f, %f, %f\n",_239,_243[0],_243[1],_243[2],_243[3]);
    _grch = _243;
   } // if _241
   // block start
   bool _244 = _239 <= 0;
   if (_244)
   {
    bool _245 = _239 == 0;
    if (_245)
    {
          _rch[0] = _prch;
    } // if _245
    else
    {
          _rch[0] = _grch[0];
    } // if _245 else
   } // if _244
   // block start
   bool _246 = _239 <= 1;
   if (_246)
   {
    bool _247 = _239 == 1;
    if (_247)
    {
          _rch[1] = _prch;
    } // if _247
    else
    {
          _rch[1] = _grch[1];
    } // if _247 else
   } // if _246
   // block start
   bool _248 = _239 <= 2;
   if (_248)
   {
    bool _249 = _239 == 2;
    if (_249)
    {
          _rch[2] = _prch;
    } // if _249
    else
    {
          _rch[2] = _grch[2];
    } // if _249 else
   } // if _248
   // block start
   bool _250 = _239 == 3;
   if (_250)
   {
        _rch[3] = _prch;
   } // if _250
   else
   {
        _rch[3] = _grch[3];
   } // if _250 else
   // block start
   DPRINTF ("C_collector(%d): write_channel _C_collector_0_channel data: %f, %f, %f, %f\n",_239,_rch[0],_rch[1],_rch[2],_rch[3]);
   write_channel_intel(_C_collector_0_channel[_239], _rch);
   // block start
      int _251 = _C_collector_s0_i_ii_ii___ii___iii___jjj__flattened_loop__no_loop_counter + 1;
   _C_collector_s0_i_ii_ii___ii___iii___jjj__flattened_loop__no_loop_counter = _251;
   int _252 = _C_collector_s0_i_ii_ii___ii___iii___jjj__flattened_loop__no_loop_counter & 127;
   bool _253 = _252 == 98;
   if (_253)
   {
        int _254 = _C_collector_s0_i_ii_ii___ii___iii___jjj__flattened_loop__no_loop_counter + 30;
    _C_collector_s0_i_ii_ii___ii___iii___jjj__flattened_loop__no_loop_counter = _254;
   } // if _253
   // block end
   // block end
   // block end
   // block end
   // block end
   // block end
   // block end
   // block end
  } // for _C_collector_s0_i_ii_ii___ii___iii___jjj__flattened_loop__no_loop_counter
 } // while _C_collector_s0_i_i_infinite
} // kernel kernel_C_collector_channel
// Address spaces for kernel_C_unloader
#define __address_space__C_unloader_mem_channel __global
__kernel void kernel_C_unloader(
 const int _C_deserializer_extent_0,
 const int _C_deserializer_extent_1,
 __address_space__C_unloader_mem_channel int4 *_C_unloader_mem_channel,
 __address_space___shared int16* __shared)
{
 int _C_unloader_s0_i_ii_iii___iii___jjj___ii__flattened_loop__no_loop_counter;
 int _255 = _C_deserializer_extent_1 + 391;
 int _256 = _255 / 392;
 int _257 = _256 * 392;
 int _258 = _255 - _257;
 int _259 = _258 >> 31;
 int _260 = 392 >> 31;
 int _261 = _259 & _260;
 int _262 = _256 - _261;
 int _263 = ~_260;
 int _264 = _259 & _263;
 int _265 = _262 + _264;
 for (int _C_unloader_s0_i_i = 0; _C_unloader_s0_i_i < 0 + _265; _C_unloader_s0_i_i++)
 {
  int _266 = _C_deserializer_extent_0 + 7;
  int _267 = _266 >> 3;
  for (int _C_unloader_s0_j_j = 0; _C_unloader_s0_j_j < 0 + _267; _C_unloader_s0_j_j++)
  {
   for (int _C_unloader_s0_i_ii_iii___iii___jjj___ii__flattened_loop__no_loop_counter = 0; _C_unloader_s0_i_ii_iii___iii___jjj___ii__flattened_loop__no_loop_counter < 0 + 1024; )
   {
    // block start
    int4 _268;
    DPRINTF ("C_unloader: To read_channel _C_collector_0_channel\n");
    _268 = read_channel_intel(_C_collector_0_channel[0]);
    DPRINTF ("C_unloader: read_channel _C_collector_0_channel data: %f, %f, %f, %f\n",_268[0],_268[1],_268[2],_268[3]);
    int _269 = _C_deserializer_extent_0 + 7;
    int _270 = _269 >> 3;
    int _271 = _C_unloader_s0_i_i * _270;
    int _272 = _271 + _C_unloader_s0_j_j;
    int _273 = _272 * 49;
    int _274 = _C_unloader_s0_i_ii_iii___iii___jjj___ii__flattened_loop__no_loop_counter >> 4;
    int _275 = _273 + _274;
    int _276 = _275 * 2;
    int _277 = _C_unloader_s0_i_ii_iii___iii___jjj___ii__flattened_loop__no_loop_counter & 15;
    int _278 = _277 >> 3;
    int _279 = _276 + _278;
    int _280 = _279 * 8;
    int _281 = _C_unloader_s0_i_ii_iii___iii___jjj___ii__flattened_loop__no_loop_counter & 7;
    int _282 = _280 + _281;
    _C_unloader_mem_channel[_282] = _268;
    // block start
        int _283 = _C_unloader_s0_i_ii_iii___iii___jjj___ii__flattened_loop__no_loop_counter + 1;
    _C_unloader_s0_i_ii_iii___iii___jjj___ii__flattened_loop__no_loop_counter = _283;
    int _284 = _C_unloader_s0_i_ii_iii___iii___jjj___ii__flattened_loop__no_loop_counter & 1023;
    bool _285 = _284 == 784;
    if (_285)
    {
          int _286 = _C_unloader_s0_i_ii_iii___iii___jjj___ii__flattened_loop__no_loop_counter + 240;
     _C_unloader_s0_i_ii_iii___iii___jjj___ii__flattened_loop__no_loop_counter = _286;
    } // if _285
    // block end
    // block end
   } // for _C_unloader_s0_i_ii_iii___iii___jjj___ii__flattened_loop__no_loop_counter
  } // for _C_unloader_s0_j_j
 } // for _C_unloader_s0_i_i
} // kernel kernel_C_unloader
#undef __address_space__C_unloader_mem_channel
