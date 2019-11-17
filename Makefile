
main: main.s
	arm-none-eabi-as main.s -o main.o
	arm-none-eabi-ld main.o -o main

run: main
	qemu-system-arm -machine raspi2 -drive format=raw,file=main

clean:
	rm main
	rm main.o
