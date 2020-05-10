###############################################################################
#	makefile
#	 by Alex Chadwick
#
#	A makefile script for generation of raspberry pi kernel images.
###############################################################################

# The toolchain to use. arm-none-eabi works, but there does exist 
# arm-bcm2708-linux-gnueabi.
ARMGNU ?= arm-none-eabi

# The directory in which source files are stored.
SOURCE = source/

# The name of the output file to generate.
TARGET = kernel.img

# The name of the assembler listing file to generate.
LIST = kernel.list

# The name of the map file to generate.
MAP = kernel.map

# The name of the linker script to use.
LINKER = kernel.ld

# The names of all object files that must be generated. Deduced from the 
# assembly code files in source.
OBJECTS := build/main.o build/frameBuffer.o

# Rule to make everything.
all: $(TARGET) $(LIST)

# Rule to remake everything. Does not include clean.
rebuild: all

# Rule to make the listing file.
$(LIST) : build/output.elf
	$(ARMGNU)-objdump -d build/output.elf > $(LIST)

# Rule to make the image file.
$(TARGET) : build/output.elf
	$(ARMGNU)-objcopy build/output.elf -O binary $(TARGET) 

# Rule to make the elf file.
build/output.elf : $(OBJECTS) $(LINKER)
	$(ARMGNU)-ld --no-undefined $(OBJECTS) -Map $(MAP) -o build/output.elf -T $(LINKER)

# Rule to make the object files.
build/%.o: $(SOURCE)%.s build/
	$(ARMGNU)-as -I $(SOURCE) $< -o $@

build/:
	mkdir $@

# Rule to clean files.
clean : 
	-rm -rf build/
	-rm -f $(TARGET)
	-rm -f $(LIST)
	-rm -f $(MAP)

flash: all
	sudo mkdir -p /media/evan/whatever
	sudo mount /dev/sdb1 /media/evan/whatever
	sudo cp kernel.img /media/evan/whatever/kernel.img
	sudo umount /media/evan/whatever
	sudo rmdir /media/evan/whatever

