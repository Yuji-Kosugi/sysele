#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <sys/time.h>

double cur_time(void)
{
  struct timeval tp[1];
  gettimeofday(tp, NULL);
  return tp->tv_sec + tp->tv_usec * 1.0E-6;
}

void convolution(int *data0, int (*data1)[2])
{
  int d1 = 0, d2 = 0;
  int i;
  for (i = 0; i <= 63; i++) {
    data1[i][0] = data0[i] ^ d2;
    data1[i][1] = data0[i] ^ d1 ^ d2;
    d2 = d1;
    d1 = data0[i];
  }
  return;
}

int inv(int b)
{
  return 1 - b;
}

void viterbi(int (*data1)[2], int *data2)
{
  int sum00[64], sum01[64], sum10[64], sum11[64], pre00[64], pre01[64], pre10[64], pre11[64];
  sum00[0] =     data1[0][1]  +     data1[0][0];
  sum10[0] = inv(data1[0][1]) + inv(data1[0][0]);
  pre00[0] = 0;
  pre10[0] = 0;
  sum00[1] = sum00[0] +     data1[1][1]  +     data1[1][0];
  sum01[1] = sum10[0] +     data1[1][1]  + inv(data1[1][0]);
  sum10[1] = sum00[0] + inv(data1[1][1]) + inv(data1[1][0]);
  sum11[1] = sum10[0] + inv(data1[1][1]) +     data1[1][0];
  pre00[1] = 0;
  pre01[1] = 2;
  pre10[1] = 0;
  pre11[1] = 2;
  int i;
  for (i = 2; i <= 63; i++) {
    sum00[i] = (sum00[i - 1] +     data1[i][0]  +     data1[i][1]  < sum01[i - 1] + inv(data1[i][0]) + inv(data1[i][1])) ? sum00[i - 1] +     data1[i][0]  +     data1[i][1]  : sum01[i - 1] + inv(data1[i][0]) + inv(data1[i][1]);
    sum01[i] = (sum10[i - 1] +     data1[i][0]  + inv(data1[i][1]) < sum11[i - 1] + inv(data1[i][0]) +     data1[i][1] ) ? sum10[i - 1] +     data1[i][0]  + inv(data1[i][1]) : sum11[i - 1] + inv(data1[i][0]) +     data1[i][1] ;
    sum10[i] = (sum00[i - 1] + inv(data1[i][0]) + inv(data1[i][1]) < sum01[i - 1] +     data1[i][0]  +     data1[i][1] ) ? sum00[i - 1] + inv(data1[i][0]) + inv(data1[i][1]) : sum01[i - 1] +     data1[i][0]  +     data1[i][1] ;
    sum11[i] = (sum10[i - 1] + inv(data1[i][0]) +     data1[i][1]  < sum11[i - 1] +     data1[i][0]  + inv(data1[i][1])) ? sum10[i - 1] + inv(data1[i][0]) +     data1[i][1]  : sum11[i - 1] +     data1[i][0]  + inv(data1[i][1]);
    pre00[i] = (sum00[i - 1] +     data1[i][0]  +     data1[i][1]  < sum01[i - 1] + inv(data1[i][0]) + inv(data1[i][1])) ? 0 : 1;
    pre01[i] = (sum10[i - 1] +     data1[i][0]  + inv(data1[i][1]) < sum11[i - 1] + inv(data1[i][0]) +     data1[i][1] ) ? 2 : 3;
    pre10[i] = (sum00[i - 1]+ inv(data1[i][0]) + inv(data1[i][1]) < sum01[i - 1] +     data1[i][0]  +     data1[i][1] ) ? 0 : 1;
    pre11[i] = (sum10[i - 1] + inv(data1[i][0]) +     data1[i][1]  < sum11[i - 1] +     data1[i][0]  + inv(data1[i][1])) ? 2 : 3;
  }
  int state = 0; int min = sum00[63];
  if (sum01[63] < min) { state = 1; min = sum01[63]; }
  if (sum10[63] < min) { state = 2; min = sum10[63]; }
  if (sum11[63] < min) { state = 3; min = sum11[63]; }
  for (i = 63; i >= 0; i--) {
    data2[i] = (state == 0 || state == 1) ? 0 : 1;
    state = (state == 0) ? pre00[i] : ((state == 1) ? pre01[i] : ((state == 2) ? pre10[i] : pre11[i]));
  }
  return;
}

int main(void)
{
  int data0[64], data1[64][2], data2[64];
  int i;
  srand((unsigned)time(NULL));
  for (i = 0; i <= 63; i++) {
    data0[i] = rand() % 2;
  }
  convolution(data0, data1);
  double t0 = cur_time();
  viterbi(data1, data2);
  double t1 = cur_time();
  int error = 0;
  for (i = 0; i <= 63; i++) {
    if (data0[i] != data2[i]) error++;
  }
  printf("send\t");
  for (i = 0; i <= 63; i++) {
    printf("%d", data0[i]);
  }
  printf("\n");
  printf("receive\t");
  for (i = 0; i <= 63; i++) {
    printf("%d", data2[i]);
  }
  printf("\n");
  printf("error\t%d\n", error);
  printf("time\t%fs\n", t1 - t0);
  return 0;
}
