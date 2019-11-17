
main: main.s
	arm-none-eabi-as main.s -o main.o
	arm-none-eabi-ld main.o -o main

clean:
	rm main
	rm main.o
