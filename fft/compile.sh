#!/bin/sh

gcc fft64.c -lm -o fft64c
iverilog fft64.v ifft64.v fft64sim.v -o fft64v
