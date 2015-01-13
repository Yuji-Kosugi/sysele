sysele
===

「システムエレクトロニクス実験プロジェクト」のソースコード

modulationディレクトリはBPSK,QPSK,16QAMの変復調を行う。シミュレーションファイルはない。

viterbiディレクトリはconvolutionによる符号化とviterbiによる復号化を行う。またC言語との速度の比較を行う。

コンパイル方法

	iverilog convolution.v viterbi.v viterbisim.v -o viterbiv
	gcc viterbi.c -o viterbic

Verilogの実行方法

	./viterbiv

シミュレーション方法

	gtkwave viterbi.vcd

C言語の実行方法

	./viterbic

fftディレクトリはFFTとIFFTを行う。こちらもC言語との比較を行う。

コンパイル方法

	iverilog fft64.v ifft64.v fft64sim.v -o fft64v
	gcc fft64.c -lm -o fft64c

Verilogの実行方法

	./fft64v

シミュレーション方法

	gtkwave fft64.vcd

C言語の実行方法

	./fft64c
