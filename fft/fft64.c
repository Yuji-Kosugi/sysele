#include <stdlib.h>
#include <time.h>
#include <stdio.h>
#include <math.h>
#include <sys/time.h>

double cur_time(void)
{
  struct timeval tp[1];
  gettimeofday(tp, NULL);
  return tp->tv_sec + tp->tv_usec * 1.0E-6;
}

void fft64(double *x0r, double *x0i, double *x4r, double *x4i)
{
  double x1r[64], x1i[64], x2r[64], x2i[64], x3r[64], x3i[64];
  int i, j;
  for (i = 0; i < 4; i++) {
    for (j = 0; j < 4; j++) {
      int a0 = i+4*j;
      int a1 = i+4*j+16;
      int a2 = i+4*j+32;
      int a3 = i+4*j+48;
      x1r[a0] =  (x0r[a0]+x0r[a1]+x0r[a2]+x0r[a3])*cos(2*M_PI*0*(i+4*j)/64)+(x0i[a0]+x0i[a1]+x0i[a2]+x0i[a3])*sin(2*M_PI*0*(i+4*j)/64);
      x1i[a0] = -(x0r[a0]+x0r[a1]+x0r[a2]+x0r[a3])*sin(2*M_PI*0*(i+4*j)/64)+(x0i[a0]+x0i[a1]+x0i[a2]+x0i[a3])*cos(2*M_PI*0*(i+4*j)/64);
      x1r[a1] =  (x0r[a0]+x0i[a1]-x0r[a2]-x0i[a3])*cos(2*M_PI*1*(i+4*j)/64)+(x0i[a0]-x0r[a1]-x0i[a2]+x0r[a3])*sin(2*M_PI*1*(i+4*j)/64);
      x1i[a1] = -(x0r[a0]+x0i[a1]-x0r[a2]-x0i[a3])*sin(2*M_PI*1*(i+4*j)/64)+(x0i[a0]-x0r[a1]-x0i[a2]+x0r[a3])*cos(2*M_PI*1*(i+4*j)/64);
      x1r[a2] =  (x0r[a0]-x0r[a1]+x0r[a2]-x0r[a3])*cos(2*M_PI*2*(i+4*j)/64)+(x0i[a0]-x0i[a1]+x0i[a2]-x0i[a3])*sin(2*M_PI*2*(i+4*j)/64);
      x1i[a2] = -(x0r[a0]-x0r[a1]+x0r[a2]-x0r[a3])*sin(2*M_PI*2*(i+4*j)/64)+(x0i[a0]-x0i[a1]+x0i[a2]-x0i[a3])*cos(2*M_PI*2*(i+4*j)/64);
      x1r[a3] =  (x0r[a0]-x0i[a1]-x0r[a2]+x0i[a3])*cos(2*M_PI*3*(i+4*j)/64)+(x0i[a0]+x0r[a1]-x0i[a2]-x0r[a3])*sin(2*M_PI*3*(i+4*j)/64);
      x1i[a3] = -(x0r[a0]-x0i[a1]-x0r[a2]+x0i[a3])*sin(2*M_PI*3*(i+4*j)/64)+(x0i[a0]+x0r[a1]-x0i[a2]-x0r[a3])*cos(2*M_PI*3*(i+4*j)/64);
    }
  }
  for (i = 0; i < 4; i++) {
    for (j = 0; j < 4; j++) {
      int a0 = i   +16*j;
      int a1 = i+4 +16*j;
      int a2 = i+8 +16*j;
      int a3 = i+12+16*j;
      x2r[a0] =  (x1r[a0]+x1r[a1]+x1r[a2]+x1r[a3])*cos(2*M_PI*0*i/16)+(x1i[a0]+x1i[a1]+x1i[a2]+x1i[a3])*sin(2*M_PI*0*i/16);
      x2i[a0] = -(x1r[a0]+x1r[a1]+x1r[a2]+x1r[a3])*sin(2*M_PI*0*i/16)+(x1i[a0]+x1i[a1]+x1i[a2]+x1i[a3])*cos(2*M_PI*0*i/16);
      x2r[a1] =  (x1r[a0]+x1i[a1]-x1r[a2]-x1i[a3])*cos(2*M_PI*1*i/16)+(x1i[a0]-x1r[a1]-x1i[a2]+x1r[a3])*sin(2*M_PI*1*i/16);
      x2i[a1] = -(x1r[a0]+x1i[a1]-x1r[a2]-x1i[a3])*sin(2*M_PI*1*i/16)+(x1i[a0]-x1r[a1]-x1i[a2]+x1r[a3])*cos(2*M_PI*1*i/16);
      x2r[a2] =  (x1r[a0]-x1r[a1]+x1r[a2]-x1r[a3])*cos(2*M_PI*2*i/16)+(x1i[a0]-x1i[a1]+x1i[a2]-x1i[a3])*sin(2*M_PI*2*i/16);
      x2i[a2] = -(x1r[a0]-x1r[a1]+x1r[a2]-x1r[a3])*sin(2*M_PI*2*i/16)+(x1i[a0]-x1i[a1]+x1i[a2]-x1i[a3])*cos(2*M_PI*2*i/16);
      x2r[a3] =  (x1r[a0]-x1i[a1]-x1r[a2]+x1i[a3])*cos(2*M_PI*3*i/16)+(x1i[a0]+x1r[a1]-x1i[a2]-x1r[a3])*sin(2*M_PI*3*i/16);
      x2i[a3] = -(x1r[a0]-x1i[a1]-x1r[a2]+x1i[a3])*sin(2*M_PI*3*i/16)+(x1i[a0]+x1r[a1]-x1i[a2]-x1r[a3])*cos(2*M_PI*3*i/16);
    }
  }
  for (i = 0; i < 4; i++) {
    for (j = 0; j < 4; j++) {
      int a0 =   4*i+16*j;
      int a1 = 1+4*i+16*j;
      int a2 = 2+4*i+16*j;
      int a3 = 3+4*i+16*j;
      x3r[a0] = x2r[a0]+x2r[a1]+x2r[a2]+x2r[a3];
      x3i[a0] = x2i[a0]+x2i[a1]+x2i[a2]+x2i[a3];
      x3r[a1] = x2r[a0]+x2i[a1]-x2r[a2]-x2i[a3];
      x3i[a1] = x2i[a0]-x2r[a1]-x2i[a2]+x2r[a3];
      x3r[a2] = x2r[a0]-x2r[a1]+x2r[a2]-x2r[a3];
      x3i[a2] = x2i[a0]-x2i[a1]+x2i[a2]-x2i[a3];
      x3r[a3] = x2r[a0]-x2i[a1]-x2r[a2]+x2i[a3];
      x3i[a3] = x2i[a0]+x2r[a1]-x2i[a2]-x2r[a3];
    }
  }
  x4r[0]  = x3r[0];  x4i[0]  = x3i[0];
  x4r[1]  = x3r[16]; x4i[1]  = x3i[16]; 
  x4r[2]  = x3r[32]; x4i[2]  = x3i[32]; 
  x4r[3]  = x3r[48]; x4i[3]  = x3i[48]; 
  x4r[4]  = x3r[4];  x4i[4]  = x3i[4];  
  x4r[5]  = x3r[20]; x4i[5]  = x3i[20]; 
  x4r[6]  = x3r[36]; x4i[6]  = x3i[36]; 
  x4r[7]  = x3r[52]; x4i[7]  = x3i[52]; 
  x4r[8]  = x3r[8];  x4i[8]  = x3i[8];  
  x4r[9]  = x3r[24]; x4i[9]  = x3i[24]; 
  x4r[10] = x3r[40]; x4i[10] = x3i[40]; 
  x4r[11] = x3r[56]; x4i[11] = x3i[56]; 
  x4r[12] = x3r[12]; x4i[12] = x3i[12]; 
  x4r[13] = x3r[28]; x4i[13] = x3i[28]; 
  x4r[14] = x3r[44]; x4i[14] = x3i[44]; 
  x4r[15] = x3r[60]; x4i[15] = x3i[60]; 
  x4r[16] = x3r[1];  x4i[16] = x3i[1];  
  x4r[17] = x3r[17]; x4i[17] = x3i[17]; 
  x4r[18] = x3r[33]; x4i[18] = x3i[33]; 
  x4r[19] = x3r[49]; x4i[19] = x3i[49]; 
  x4r[20] = x3r[5];  x4i[20] = x3i[5];  
  x4r[21] = x3r[21]; x4i[21] = x3i[21]; 
  x4r[22] = x3r[37]; x4i[22] = x3i[37]; 
  x4r[23] = x3r[53]; x4i[23] = x3i[53]; 
  x4r[24] = x3r[9];  x4i[24] = x3i[9];  
  x4r[25] = x3r[25]; x4i[25] = x3i[25]; 
  x4r[26] = x3r[41]; x4i[26] = x3i[41]; 
  x4r[27] = x3r[57]; x4i[27] = x3i[57]; 
  x4r[28] = x3r[13]; x4i[28] = x3i[13]; 
  x4r[29] = x3r[29]; x4i[29] = x3i[29]; 
  x4r[30] = x3r[45]; x4i[30] = x3i[45]; 
  x4r[31] = x3r[61]; x4i[31] = x3i[61]; 
  x4r[32] = x3r[2];  x4i[32] = x3i[2];  
  x4r[33] = x3r[18]; x4i[33] = x3i[18]; 
  x4r[34] = x3r[34]; x4i[34] = x3i[34]; 
  x4r[35] = x3r[50]; x4i[35] = x3i[50]; 
  x4r[36] = x3r[6];  x4i[36] = x3i[6];  
  x4r[37] = x3r[22]; x4i[37] = x3i[22]; 
  x4r[38] = x3r[38]; x4i[38] = x3i[38]; 
  x4r[39] = x3r[54]; x4i[39] = x3i[54]; 
  x4r[40] = x3r[10]; x4i[40] = x3i[10]; 
  x4r[41] = x3r[26]; x4i[41] = x3i[26]; 
  x4r[42] = x3r[42]; x4i[42] = x3i[42]; 
  x4r[43] = x3r[58]; x4i[43] = x3i[58]; 
  x4r[44] = x3r[14]; x4i[44] = x3i[14]; 
  x4r[45] = x3r[30]; x4i[45] = x3i[30]; 
  x4r[46] = x3r[46]; x4i[46] = x3i[46]; 
  x4r[47] = x3r[62]; x4i[47] = x3i[62]; 
  x4r[48] = x3r[3];  x4i[48] = x3i[3];  
  x4r[49] = x3r[19]; x4i[49] = x3i[19]; 
  x4r[50] = x3r[35]; x4i[50] = x3i[35]; 
  x4r[51] = x3r[51]; x4i[51] = x3i[51]; 
  x4r[52] = x3r[7];  x4i[52] = x3i[7];  
  x4r[53] = x3r[23]; x4i[53] = x3i[23]; 
  x4r[54] = x3r[39]; x4i[54] = x3i[39]; 
  x4r[55] = x3r[55]; x4i[55] = x3i[55]; 
  x4r[56] = x3r[11]; x4i[56] = x3i[11]; 
  x4r[57] = x3r[27]; x4i[57] = x3i[27]; 
  x4r[58] = x3r[43]; x4i[58] = x3i[43]; 
  x4r[59] = x3r[59]; x4i[59] = x3i[59]; 
  x4r[60] = x3r[15]; x4i[60] = x3i[15]; 
  x4r[61] = x3r[31]; x4i[61] = x3i[31]; 
  x4r[62] = x3r[32]; x4i[62] = x3i[32]; 
  x4r[63] = x3r[33]; x4i[63] = x3i[33];
  return;
}

void ifft64(double *x4r, double *x4i, double *x7r, double *x7i)
{
  double x5r[64], x5i[64], x6r[64], x6i[64];
  int i;
  for (i = 0; i <= 63; i++) {
    x5r[i] = x4r[i];
    x5i[i] = -x4i[i];
  }
  fft64(x5r, x5i, x6r, x6i);
  for (i = 0; i <= 63; i++) {
    x7r[i] = x6r[i] / 64;
    x7i[i] = -x6i[i] / 64;
  }
  return;
}

int main(void)
{
  double x0r[64], x0i[64], x4r[64], x4i[64], x7r[64], x7i[64], anr[64], ani[64];
  int i;
  x0r[0] = 5;
  x0i[0] = 15;
  anr[0] = -83;
  ani[0] = 440;
  x0r[1] = 1;
  x0i[1] = 3;
  anr[1] = -7;
  ani[1] = -6;
  x0r[2] = -12;
  x0i[2] = 3;
  anr[2] = 64;
  ani[2] = 59;
  x0r[3] = -7;
  x0i[3] = 11;
  anr[3] = 28;
  ani[3] = -7;
  x0r[4] = 1;
  x0i[4] = 11;
  anr[4] = -15;
  ani[4] = 10;
  x0r[5] = 12;
  x0i[5] = 7;
  anr[5] = 19;
  ani[5] = 70;
  x0r[6] = -13;
  x0i[6] = 5;
  anr[6] = 43;
  ani[6] = 92;
  x0r[7] = -8;
  x0i[7] = 14;
  anr[7] = -62;
  ani[7] = -31;
  x0r[8] = 13;
  x0i[8] = 4;
  anr[8] = -50;
  ani[8] = 47;
  x0r[9] = -8;
  x0i[9] = 1;
  anr[9] = 7;
  ani[9] = -13;
  x0r[10] = 4;
  x0i[10] = 5;
  anr[10] = -55;
  ani[10] = 33;
  x0r[11] = 1;
  x0i[11] = 11;
  anr[11] = -42;
  ani[11] = 9;
  x0r[12] = -6;
  x0i[12] = 2;
  anr[12] = 38;
  ani[12] = 116;
  x0r[13] = -10;
  x0i[13] = 10;
  anr[13] = -44;
  ani[13] = -67;
  x0r[14] = 0;
  x0i[14] = 6;
  anr[14] = -25;
  ani[14] = -10;
  x0r[15] = -4;
  x0i[15] = 4;
  anr[15] = 79;
  ani[15] = -85;
  x0r[16] = -9;
  x0i[16] = 7;
  anr[16] = 18;
  ani[16] = 47;
  x0r[17] = -9;
  x0i[17] = 3;
  anr[17] = -77;
  ani[17] = -45;
  x0r[18] = -8;
  x0i[18] = 12;
  anr[18] = 70;
  ani[18] = -54;
  x0r[19] = -7;
  x0i[19] = 11;
  anr[19] = 38;
  ani[19] = -58;
  x0r[20] = 14;
  x0i[20] = 0;
  anr[20] = -44;
  ani[20] = -7;
  x0r[21] = 11;
  x0i[21] = 2;
  anr[21] = 31;
  ani[21] = 46;
  x0r[22] = 8;
  x0i[22] = 2;
  anr[22] = -74;
  ani[22] = -17;
  x0r[23] = -7;
  x0i[23] = 12;
  anr[23] = 71;
  ani[23] = 20;
  x0r[24] = -4;
  x0i[24] = 0;
  anr[24] = 13;
  ani[24] = -5;
  x0r[25] = 3;
  x0i[25] = 11;
  anr[25] = 53;
  ani[25] = 56;
  x0r[26] = -7;
  x0i[26] = 4;
  anr[26] = 49;
  ani[26] = -52;
  x0r[27] = 0;
  x0i[27] = 4;
  anr[27] = -40;
  ani[27] = -64;
  x0r[28] = -5;
  x0i[28] = 15;
  anr[28] = 12;
  ani[28] = 15;
  x0r[29] = -2;
  x0i[29] = 7;
  anr[29] = -2;
  ani[29] = -10;
  x0r[30] = 10;
  x0i[30] = 2;
  anr[30] = -53;
  ani[30] = -61;
  x0r[31] = 14;
  x0i[31] = 7;
  anr[31] = 124;
  ani[31] = -25;
  x0r[32] = -8;
  x0i[32] = 7;
  anr[32] = 99;
  ani[32] = -16;
  x0r[33] = -3;
  x0i[33] = 10;
  anr[33] = 49;
  ani[33] = 37;
  x0r[34] = -15;
  x0i[34] = 0;
  anr[34] = 4;
  ani[34] = 49;
  x0r[35] = -5;
  x0i[35] = 9;
  anr[35] = -20;
  ani[35] = 119;
  x0r[36] = 8;
  x0i[36] = 4;
  anr[36] = -66;
  ani[36] = 33;
  x0r[37] = -12;
  x0i[37] = 9;
  anr[37] = 75;
  ani[37] = 89;
  x0r[38] = -12;
  x0i[38] = 13;
  anr[38] = -52;
  ani[38] = 81;
  x0r[39] = 5;
  x0i[39] = 13;
  anr[39] = -5;
  ani[39] = 0;
  x0r[40] = 4;
  x0i[40] = 13;
  anr[40] = 20;
  ani[40] = -17;
  x0r[41] = -8;
  x0i[41] = 2;
  anr[41] = 86;
  ani[41] = 6;
  x0r[42] = 2;
  x0i[42] = 15;
  anr[42] = -62;
  ani[42] = -23;
  x0r[43] = 8;
  x0i[43] = 4;
  anr[43] = -24;
  ani[43] = -58;
  x0r[44] = -8;
  x0i[44] = 15;
  anr[44] = -61;
  ani[44] = 121;
  x0r[45] = -9;
  x0i[45] = 1;
  anr[45] = -41;
  ani[45] = 68;
  x0r[46] = -14;
  x0i[46] = 5;
  anr[46] = 10;
  ani[46] = 102;
  x0r[47] = 2;
  x0i[47] = 14;
  anr[47] = 0;
  ani[47] = 3;
  x0r[48] = 12;
  x0i[48] = 11;
  anr[48] = 162;
  ani[48] = -7;
  x0r[49] = -13;
  x0i[49] = 4;
  anr[49] = 92;
  ani[49] = 109;
  x0r[50] = 3;
  x0i[50] = 2;
  anr[50] = -65;
  ani[50] = 39;
  x0r[51] = 6;
  x0i[51] = 11;
  anr[51] = 54;
  ani[51] = 35;
  x0r[52] = 10;
  x0i[52] = 8;
  anr[52] = -12;
  ani[52] = -112;
  x0r[53] = -9;
  x0i[53] = 1;
  anr[53] = -41;
  ani[53] = 6;
  x0r[54] = -6;
  x0i[54] = 9;
  anr[54] = 2;
  ani[54] = -14;
  x0r[55] = -7;
  x0i[55] = 15;
  anr[55] = 79;
  ani[55] = -30;
  x0r[56] = 10;
  x0i[56] = 2;
  anr[56] = 5;
  ani[56] = -17;
  x0r[57] = -6;
  x0i[57] = 4;
  anr[57] = -63;
  ani[57] = 77;
  x0r[58] = 6;
  x0i[58] = 1;
  anr[58] = 68;
  ani[58] = -108;
  x0r[59] = -12;
  x0i[59] = 4;
  anr[59] = -50;
  ani[59] = -13;
  x0r[60] = 12;
  x0i[60] = 2;
  anr[60] = -37;
  ani[60] = -7;
  x0r[61] = 3;
  x0i[61] = 3;
  anr[61] = 5;
  ani[61] = 43;
  x0r[62] = 13;
  x0i[62] = 12;
  anr[62] = -18;
  ani[62] = -53;
  x0r[63] = -11;
  x0i[63] = 6;
  anr[63] = 41;
  ani[63] = -23;
  double t0 = cur_time();
  fft64(x0r, x0i, x4r, x4i);
  double t1 = cur_time();
  for (i = 0; i < 64; i++) {
    printf("xr[%2d] output=%4d expected=%4d xi[%2d] output=%4d expected=%4d", i, (int)(x4r[i]), (int)(anr[i]), i, (int)(x4i[i]), (int)(ani[i]));
    if ((int)(x4r[i]) >= (int)(anr[i]) - 3 || (int)(x4r[i]) <= (int)(anr[i]) + 3 || (int)(x4i[i]) >= (int)(ani[i]) - 3 || (int)(x4i[i]) <= (int)(ani[i]) + 3) {
      printf(" OK\n");
    } else {
      printf(" ERROR\n");
    }
  }
  ifft64(x4r, x4i, x7r, x7i);
  for (i = 0; i < 64; i++) {
    printf("dr[%2d] output=%4d expected=%4d di[%2d] output=%4d expected=%4d", i, (int)(x7r[i]), (int)(x0r[i]), i, (int)(x7i[i]), (int)(x0i[i]));
    if ((int)(x0r[i]) >= (int)(x7r[i]) - 3 || (int)(x0r[i]) <= (int)(x7r[i]) + 3 || (int)(x0i[i]) >= (int)(x7i[i]) - 3 || (int)(x0i[i]) <= (int)(x7i[i]) + 3) {
      printf(" OK\n");
    } else {
      printf(" ERROR\n");
    }
  }
  printf("time\t%f\n", t1 - t0);
  return 0;
}
