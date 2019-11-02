# 4190.308 Computer Architecture (Fall 2019)
# Project #3: RISC-V Assembly Programming
### Due: 11:59PM, November 10 (Sunday)


## Introduction

The goal of this project is to give you an opportunity to practice RISC-V assembly programming. In addition, this project introduces various RISC-V tools that help you compile and run your RISC-V programs.

## Motivation

In this project, we focus on the 32-bit RISC-V processor that implements a subset of RV32I base instruction set. RV32I was designed to be sufficient to form a compiler target and to support modern operating system environments, containing only 40 unique instructions. However, it lacks integer multiplication and division instructions. Therefore, we want to implement some of integer multiplication and division instructions defined in the RISC-V "M" extension, such as `mul`, `mulh`, `div`, and `rem`, using only the RV32I instruction set. You can reuse multiplication and division functions implemented in Project #1, but this project has slight different requirements.

## Problem specification

Write four functions named `mul()`, `mulh()`, `div()`, and `rem()` in RISC-V assembly language which receive two 32-bit integers. The prototype of each function can be represented in C as follows:

```
int mul (int a, int b);
int mulh (int a, int b);
int div (int a, int b);
int rem (int a, int b);
```

### `mul (int a, int b)`  (20 points)

The `mul()` function is our implementation of the `mul` instruction defined in the RISC-V "M" extension:

```
mul  rd, rs1, rs2
```
The `mul` instruction performs a 32-bit x 32-bit multiplication of `rs1` by `rs2` and places the lower 32 bits in the destination register `rd`. Similar to the `mul` instruction, you need to return the lower 32 bits of the integer product `a` * `b`.

### `mulh (int a, int b)`  (20 points)

The `mulh()` function is our implementation of the `mulh` instruction defined in the RISC-V "M" extension:
```
mulh  rd, rs1, rs2
```
The `mulh` instruction performs the same multiplication as `mul`, but places the upper 32 bits of the full 64-bit product in the destination register `rd`. Similar to the `mulh` instruction, you need to return the upper 32 bits of the integer product `a` * `b`.

### `div (int a, int b)`  (30 points)

The `div()` function implements the operation of the `div` instruction defined in the RISC-V "M" extension:
```
div  rd, rs1, rs2
```

The `div` instruction performs a 32-bit by 32-bit signed integer division of `rs1` by `rs2`, rounding towards zero. Similar to the `div` instruction, you need to return the integer division result of `a` / `b`.

### `rem (int a, int b)`  (30 points)

The `rem()` function implements the operation of the `rem` instruction defined in the RISC-V "M" extension:
```
rem  rd, rs1, rs2
```
The `rem` instruction provides the remainder of the corresponding division operation. Similar to the `rem` instruction, you need to return the remainder of the integer division of  `a` / `b`.


### Special cases for div() and rem()

The semantics for division by zero and division overflow are summarized in the following table (excerpted from the RISC-V specification).

| Condition        | Dividend | Divisor | div  | rem |
| ---------------- | -------- | ------- | ---- | --- |
| Division by zero | _x_      | _0_     | _-1_ | _x_ |
| Overflow         | _-2 <sup>L-1</sup>_  | _-1_ | _-2 <sup>L-1</sup>_     |  0   |

Note: Except for the overflow condition, it always holds that dividend = divisor * quotient + remainder.

For more information on the integer multiplication and division instructions defined in the RISC-V "M" extension. please refer to the latest [RISC-V Unprivileged Specification](https://riscv.org/specifications).

## Building RISC-V gcc compiler

In order to compile RISC-V assembly programs, you need to build a cross compiler, i.e. the compiler that generates the RISC-V binary code on the x86-64 machine. To build the RISC-V toolchain on your machine (on either Linux or MacOS), please take the following steps.

### 1. Install prerequisite packages first

For Ubuntu 18.04LTS, perform the following command:
```
$ sudo apt-get install autoconf automake autotools-dev curl libmpc-dev
$ sudo apt-get install libmpfr-dev libgmp-dev gawk build-essential bison flex
$ sudo apt-get install texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev
```
If your machine runs MacOS, perform the following command (If you don't have the `brew` utility, you have to install it first -- please refer to https://brew.sh):
```
$ brew install gawk gnu-sed gmp mpfr libmpc isl zlib expat
```

### 2. Download the RISC-V GNU Toolchain from Github

```
$ git clone --recursive https://github.com/riscv/riscv-gnu-toolchain
```

### 3. Configure the RISC-V GNU toolchain

```
$ cd riscv-gnu-toolchain
$ mkdir build
$ cd build
$ ../configure --prefix=/opt/riscv --with-arch=rv32im
```

### 4. Compile and install them.

Note that they are installed in the path given as the prefix, i.e. `/opt/riscv` in this example.

```
$ sudo make
```

### 5. Add `/opt/riscv/bin` in your `PATH`

```
$ export PATH=/opt/riscv/bin:$PATH
```


## Skeleton code

We provide you with the skeleton code for this project. It can be downloaded from Github at https://github.com/snu-csl/ca-pa3/.

To download and build the skeleton code, please follow these steps:

```
$ git clone https://github.com/snu-csl/ca-pa3.git
$ cd ca-pa3
$ make
riscv32-unknown-elf-gcc -c -Og -march=rv32g -mabi=ilp32 -static   muldiv-test.s -o muldiv-test.o
riscv32-unknown-elf-gcc -c -Og -march=rv32g -mabi=ilp32 -static   muldiv.s -o muldiv.o
riscv32-unknown-elf-gcc -T./link.ld -nostdlib -nostartfiles -o muldiv muldiv-test.o muldiv.o
```

## Running your RISC-V executable file

The executable file generated by `riscv32-unknown-elf-gcc` should be run in the RISC-V machine. In this project, we provide you with a RISC-V instruction set simmulator written in Python, called __snurisc__. It is available at the separate Github repository at https://github.com/snu-csl/pyrisc. You can install it by performing the following command.
```
$ git clone https://github.com/snu-csl/pyrisc
```

To run your RISC-V executable file, you need to modify the `./ca-pa3/Makefile` so that it can find the __snurisc__ simulator. In the `Makefile`, there is an environment variable called `PYRISC`. By default, it was set to `../../pyrisc/sim/snurisc.py`. For example, if you have downloaded PyRISC in `/dir1/dir2/pyrisc`, set `PYRISC` to `/dir1/dir2/pyrisc/sim/snurisc.py`.

```
...

PREFIX      = riscv32-unknown-elf-
CC          = $(PREFIX)gcc
CXX         = $(PREFIX)g++
AS          = $(PREFIX)as
OBJDUMP     = $(PREFIX)objdump

PYRISC      = /dir1/dir2/pyrisc/sim/snurisc.py      # <-- Change this line
PYRISCOPT   = -l 1

INCDIR      =
LIBDIR      =
LIBS        =

...
```

Now you can run `muldiv`, by performing `make run`. The result of a sample run using the __snurisc__ simulator looks like this:

```
$ make run
/dir1/dir2/pyrisc/sim/snurisc.py -l 1 muldiv
Loading file muldiv
Execution completed
Registers
=========
zero ($0): 0x00000000    ra ($1):   0x80000008    sp ($2):   0x80020000    gp ($3):   0x00000000
tp ($4):   0x00000000    t0 ($5):   0x00000000    t1 ($6):   0x80010000    t2 ($7):   0x80010020
s0 ($8):   0x00000000    s1 ($9):   0x00000000    a0 ($10):  0x33333333    a1 ($11):  0x00000000
a2 ($12):  0x00000000    a3 ($13):  0x00000000    a4 ($14):  0x00000000    a5 ($15):  0x00000000
a6 ($16):  0x00000000    a7 ($17):  0x00000000    s2 ($18):  0x00000000    s3 ($19):  0x00000000
s4 ($20):  0x00000000    s5 ($21):  0x00000000    s6 ($22):  0x00000000    s7 ($23):  0x00000000
s8 ($24):  0x00000000    s9 ($25):  0x00000000    s10 ($26): 0x00000000    s11 ($27): 0x00000000
t3 ($28):  0x80010040    t4 ($29):  0x00000008    t5 ($30):  0x80010000    t6 ($31):  0x00000010
22 instructions executed in 22 cycles. CPI = 1.000
Data transfer:    5 instructions (22.73%)
ALU operation:    11 instructions (50.00%)
Control transfer: 6 instructions (27.27%)
```

If the value of the `t6` (or `x31`) register is zero, it means that your program passed all the test cases. Otherwise, the value of the `t6` register indicates the first test case your program failed.


## Restrictions

* You are allowed to use only the following registers in the `muldiv.s` file: `sp`, `ra`, and `a0` ~ `a5`. If you are running out of registers, use stack as temporary storage.

* Your solution should finish within a reasonable time. If your code does not finish within a predefined threshold, it will be terminated.

* __The top 3 fastest `mulh()` implementations will receive a 10% extra bonus.__ The time will be measured in clock cycles  (= the total number of instructions executed).


## Hand in instructions

* Submit only the `muldiv.s` file to the submission server.

## Logistics

* You will work on this project alone.
* Only the upload submitted before the deadline will receive the full credit. 25% of the credit will be deducted for every single day delay.
* __You can use up to 5 _slip days_ during this semester__. If your submission is delayed by 1 day and if you decided to use 1 slip day, there will be no penalty. In this case, you should explicitly declare the number of slip days you want to use in the QnA board of the submission server after each submission. Saving the slip days for later projects is highly recommended!
* Any attempt to copy others' work will result in heavy penalty (for both the copier and the originator). Don't take a risk.

Have fun!

[Jin-Soo Kim](mailto:jinsoo.kim_AT_snu.ac.kr)  
[Systems Software and Architecture Laboratory](http://csl.snu.ac.kr)  
[Dept. of Computer Science and Engineering](http://cse.snu.ac.kr)  
[Seoul National University](http://www.snu.ac.kr)
