
# Change this line to point to your own installation of qemu-system-arm 4.1.0.

QSA = ~/Applications/QEMU/qemu-4.1.0/build/arm-softmmu/qemu-system-arm


main: main.s
	arm-none-eabi-as -o main.o main.s
	arm-none-eabi-ld -o main main.o

run: main
	$(QSA) -machine raspi2 -kernel main

clean:
	rm -f main
	rm -f *.o
