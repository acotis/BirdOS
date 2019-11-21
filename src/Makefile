
DEPS = main.o screen.o text/char_maps.o text/string.o text/text.o text/cursor.o text/text_test.o text/convert.o


%.o: %.s
	arm-none-eabi-as -o $@ $<

main: $(DEPS)
	arm-none-eabi-ld -o main $(DEPS)

run: main
	qemu-system-arm -machine raspi2 -kernel main


clean:
	rm -f main
	rm -f *.o
	rm -f text/*.o
