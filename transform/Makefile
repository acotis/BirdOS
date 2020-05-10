
DEPS := main.o screen.o

%.o: %.s
	arm-none-eabi-as $< -o $@


kernel.img : $(DEPS) kernel.ld
	arm-none-eabi-ld --no-undefined $(DEPS) -Map kernel.map \
		-o output.elf -T kernel.ld
	arm-none-eabi-objcopy output.elf -O binary kernel.img 


all: kernel.img

rebuild: all


clean : 
	-rm -f *.o
	-rm -f kernel.img
	-rm -f kernel.map
	-rm -f output.elf

flash: all
	sudo mkdir -p /media/evan/whatever
	sudo mount /dev/sdb1 /media/evan/whatever
	sudo cp kernel.img /media/evan/whatever/kernel.img
	sudo umount /media/evan/whatever
	sudo rmdir /media/evan/whatever

