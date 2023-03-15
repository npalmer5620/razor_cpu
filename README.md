# RISC V CPU in SystemVerilog 
System Verilog implementation of a RISC-V CPU core, so far only a subset of RV32I instructions, but moving to RV64I support soon.

The project is designed to run on a Basys 3, currently the single cycle core runs in simulation and has a relatively high max estimated frequency. The upcoming pipelined version will utilize the FPGA's dual port BRAM for data memory and onboard SPI Flash so instructions can be flashed and executed independently.

## Current features:
- [x] Single Cycle
- [x] Synthesizable
- [x] RV32I
- [ ] RV64I (WIP)
- [ ] Memory/Peripheral IO Bus (WIP)
- [ ] 6 Stage Pipeline (WIP)
- [ ] Direct-mapped cache
- [ ] Instruction re-order system

## Why?

I originally started this as a CompE school project, but I decided I really wanted to build a processor that implemented some of the most modern CPU features found in today's systems for some reason, so here we are!

## So then what works?

So far, I have just gotten to the early pipeline stages of the project, where I have verified that all components of the core work in a single cycled system.

All the files that have _v2 appended are the updated versions with more concise Verilog coding, and pipelining support. This should probably be done in another branch, but gradually they are meant to replace the original code so it should be okay, plus, Xilinx Vivado's source organization is not great to put it mildly so...

## How do I make it work?
Right now, this is purely an educational project and not meant to be utilized in any real world system, but if you really do want to try it:

- Clone the repository
- Download your favorite HDL simulator (Verilator, Icarus Verilog, Vivado, Qsim, etc.)
- Use whatever tool to include all files in the repo as part of the project and run <code>core_tb.sv</code>
- <code>rom.mem</code> should be the file that the ROM gets initialized to.

Also keep in mind the Verilog is very sparse, and errors will be hidden and hard to diagnose for this reason.

## WIP...

