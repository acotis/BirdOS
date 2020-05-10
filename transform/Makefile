
OBJECTS := build/main.o build/frameBuffer.o

build/%.o: source/%.s build/
	arm-none-eabi-as -I source/ $< -o $@

build/:
	mkdir $@

kernel.img : build/output.elf
	arm-none-eabi-objcopy build/output.elf -O binary kernel.img 

build/output.elf : $(OBJECTS) kernel.ld
	arm-none-eabi-ld --no-undefined $(OBJECTS) -Map kernel.map -o build/output.elf -T kernel.ld


all: kernel.img

rebuild: all


clean : 
	-rm -rf build/
	-rm -f kernel.img
	-rm -f kernel.list
	-rm -f kernel.map

flash: all
	sudo mkdir -p /media/evan/whatever
	sudo mount /dev/sdb1 /media/evan/whatever
	sudo cp kernel.img /media/evan/whatever/kernel.img
	sudo umount /media/evan/whatever
	sudo rmdir /media/evan/whatever

