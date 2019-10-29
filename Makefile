#----------------------------------------------------------------
# 
#  4190.308 Computer Architecture (Fall 2019)
#
#  Project #3: RISC-V Assembly Programming
#
#  October 29, 2019
#
#  Jin-Soo Kim (jinsoo.kim@snu.ac.kr)
#  Systems Software & Architecture Laboratory
#  Dept. of Computer Science and Engineering
#  Seoul National University
#
#----------------------------------------------------------------


PREFIX      = riscv32-unknown-elf-
CC			= $(PREFIX)gcc
CXX			= $(PREFIX)g++
AS			= $(PREFIX)as
OBJDUMP		= $(PREFIX)objdump

PYRISC      = ../../pyrisc/sim/snurisc.py  # Adjust your path here 
PYRISCOPT   = -l 1

INCDIR      = 
LIBDIR      =
LIBS        =

CFLAGS      = -Og -march=rv32g -mabi=ilp32 -static 
ASLFAGS     = -march=rv32g -mabi=ilp32 -static 
LDFLAGS     = -T./link.ld -nostdlib -nostartfiles
OBJDFLAGS   = -D --section=.text --section=.data

TARGET      = muldiv
ASRCS       = muldiv-test.s muldiv.s
OBJS        = $(ASRCS:.s=.o)

all: $(OBJS)
	$(CC) $(LDFLAGS) -o $(TARGET) $(OBJS) $(LIBDIR) $(LIBS)

.s.o:
	$(CC) -c $(CFLAGS) $(INCDIR) $< -o $@

.c.s:
	$(CC) $(CFLAGS) $(INCDIR) -S $< -o $@

objdump: $(TARGET)
	$(OBJDUMP) $(OBJDFLAGS) $(TARGET) > $(TARGET).objdump    

run: $(TARGET)
	$(PYRISC) $(PYRISCOPT) $(TARGET)

clean:
	$(RM) -f $(TARGET) $(TARGET).objdump $(OBJS) *~ a.out



