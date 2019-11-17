
DEPS = main.o screen.o text.o char_maps.o


%.o: %.s
	arm-none-eabi-as -o $@ $<

main: $(DEPS)
	arm-none-eabi-ld -o main $(DEPS)

run: main
	qemu-system-arm -machine raspi2 -kernel main


clean:
	rm main
	rm *.o
