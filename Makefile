# --- Assembler
NC = nasm
NF = elf32

# --- C
CC = i386-win32-tcc
CFLAGS = -Wall

# --- Targets
TARGET ?= first.exe
TARGET += second.exe

default : $(TARGET)

%.o : %.asm
	$(NC) -f $(NF) $< -o $@
	objdump -D -M intel $@

%.exe : %.o
	$(CC) $(CFLAGS) $< -o $@

clean :
	del $(TARGET)