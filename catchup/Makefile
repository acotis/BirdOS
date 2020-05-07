
DEPS = main.o screen.o text/char_maps.o text/string.o    


%.o: %.s
	arm-none-eabi-as -o $@ $< -mfpu=vfpv4 -mcpu=cortex-a72 -mfloat-abi=hard

main: $(DEPS)
	arm-none-eabi-ld -o main $(DEPS)

flash: main
	sudo mkdir -p /media/evan/whatever
	sudo mount /dev/sdb1 /media/evan/whatever
	sudo cp main /media/evan/whatever/kernel.img
	sudo umount /media/evan/whatever
	sudo rmdir /media/evan/whatever

clean:
	rm -f main
	rm -f *.o
	rm -f ./text/*.o
