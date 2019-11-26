
DEPS = main.o screen.o text/char_maps.o text/string.o text/text.o text/cursor.o text/text_test.o text/convert.o games/mandelbrot.o

QSA = /home/evan/Applications/QEMU/qemu-4.1.0/build/arm-softmmu/qemu-system-arm

#QSA = qemu-system-arm

OPT = -kernel main -smp cores=4,threads=1


%.o: %.s
	arm-none-eabi-as -o $@ $<

main: $(DEPS)
	arm-none-eabi-ld -o main $(DEPS)

run: main
	$(QSA) $(OPT) -machine raspi2

runicp: main
	$(QSA) $(OPT) -machine integratorcp

runrv: main
	$(QSA) $(OPT) -machine realview-pb-a8

clean:
	rm -f main
	rm -f *.o
	rm -f text/*.o
