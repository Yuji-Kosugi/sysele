sysele
===

「システムエレクトロニクス実験プロジェクト」のソースコード

modulationディレクトリはBPSK,QPSK,16QAMの変復調を行う。シミュレーションファイルはない。

viterbiディレクトリはconvolutionによる符号化とviterbiによる復号化を行う。またC言語との速度の比較を行う。

コンパイル方法は

	./compile.sh

Verilogの実行方法は

	./viterbiv

シミュレーション方法は

	gtkwave viterbi.vcd

C言語の実行方法は

	./viterbic

また

	./delete.sh

によりソースコード以外を削除できる。

fftディレクトリはFFTとIFFTを行う。こちらもC言語との比較を行う。

コンパイル方法は

	./compile.sh

Verilogの実行方法は

	./fft64v

シミュレーション方法は

	gtkwave fft64.vcd

C言語の実行方法は

	./fft64c

また

	./delete.sh

によりソースコード以外を削除できる。
