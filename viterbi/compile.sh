#!/bin/sh

gcc viterbi.c -o viterbic
iverilog convolution.v viterbi.v viterbisim.v -o viterbiv
