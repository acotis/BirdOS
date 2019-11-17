
DEPS = main.o mailbox.o


%.o: %.s
	arm-none-eabi-as -o $@ $<

main: $(DEPS)
	arm-none-eabi-ld -o main $(DEPS)

run: main
	qemu-system-arm -machine raspi2 -drive format=raw,file=main

clean:
	rm main
	rm *.o
