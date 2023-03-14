# Pipeline implementation in verilog for Y86-64 ISA
<br>
This is an attempt to write a functional processor in verilog which supports the Y86-64 ISA with pipelining. Most of the reference is taken from the textbook `Computer Systems A Programmer’s Perspective` by Randal E. Bryant and David R. O’Hallaron.

The implementation can be looked at in these major stages:
```
        |_ Fetch and PC select
        |_ Decode
        |_ Execute
        |_ Memory and writeback
```     
The final implementation would look something like this:
<br>
<p align = "center">
<img src = "https://user-images.githubusercontent.com/94699627/223440472-fed5afc6-5f18-4645-a0eb-a9afef1d15db.png" witdth="570" height="730">
</p>

## Fetch and PC prediction

In this stage we fetch the instruction from main memory and then also predict PC. Within the one cycle time limit, the
processor can only predict the address of the next instruction.
<br>
<p align = "center">
<img src = "https://user-images.githubusercontent.com/94699627/223439168-f534b928-3e10-430f-a780-678f7d28c65a.png" witdth="570" height="420">
</p>

The fetch stage in a Y86 64-bit processor is responsible for retrieving the next instruction from memory and preparing it for execution.
The fetch stage works as follows:
- The program counter (PC) holds the address of the next instruction to be fetched.
- The fetch stage sends a read request to the memory subsystem at the address held by the PC.
- The instruction is retrieved from memory and stored in a buffer called the instruction register (IR).
- The PC is incremented to point to the next instruction.
- The fetched instruction is then passed on to the next stage of the pipeline, which is typically the decode stage.

The PC selection logic chooses between three program counter sources. As a mispredicted branch enters the memory stage, the value of `valP` for this instruction (indicating the address of the following instruction) is read from pipeline register M (signal `M_valA`). When a ret instruction enters the write-back stage, the return address is read from pipeline register W (signal `W_valM`). All other cases use the predicted value of the PC, stored in pipeline register F (signal `F_predPC`).

Overall, the fetch stage is responsible for reading instructions from memory and making them available for execution by the processor. 
Overall one of the major difference between `fetch` stage execution in a sequential model and this pipeline model is that in this model we
move the PC update stage so that its logic is active at the beginning of the clock cycle by making it compute the PC value for the current instruction.

## Decode

<br>
<p align = "center">
<img src = "https://user-images.githubusercontent.com/94699627/223841685-dd6c0ac6-882f-4584-b9a5-0907f43a66fc.png" witdth="680" height="536">
</p>

The decode stage is responsible for decoding the instruction fetched in the previous cycle and preparing the operands for the execution stage. The decode stage works as follows:
- The instruction that was fetched in the previous cycle is loaded from the instruction register (IR) into the decode register (DR).
- The opcode of the instruction is extracted from the instruction and decoded to determine the type of instruction and the operands that are needed.
- The registers that are specified as operands in the instruction are read from the register file and their values are passed on to the execution stage.
- If the instruction involves a memory access, the address of the memory location is computed based on the operands and passed on to the execution stage.
- Control signals are generated based on the instruction type and passed on to the execution stage to enable the appropriate functional units.
- The decoded instruction and its operands are then passed on to the execution stage to be executed.

Pipelining's decode stage is crucial because it gets the operands ready for the execution stage so that it may start processing the instruction as soon as it becomes available. The fetch, decode, and execute phases of the CPU can be combined to boost throughput and overall performance.

## Execute

<br>
<p align = "center">
<img src = "https://user-images.githubusercontent.com/94699627/223844681-90b55f97-9fda-463e-9b91-6c239affee09.png">
</p>

The execute stage in a Y86 64-bit processor with pipelining is responsible for carrying out the operation specified by the instruction, using the operands that were fetched and prepared in the previous stages. The execute stage works as follows:
- The instruction and its operands are received from the previous stage, typically the decode stage. The operation specified by the instruction is performed on the operands.
- If the instruction involves a memory access, the memory subsystem is accessed to read or write the data.
- If the instruction is a branch instruction, the branch condition is evaluated, and the program counter (PC) is updated accordingly.
- The result of the operation is then passed on to the next stage of the pipeline, typically the memory stage or the write-back stage.

Hazard detection and handling techniques, such as forwarding, stalling, and branch prediction, may also be used during the execution stage to ensure correct program execution in the presence of hazards.

## Memory

<br>
<p align = "center">
<img src = "https://user-images.githubusercontent.com/94699627/223894618-80212de3-ca3f-4974-80b5-af5c81b74a43.png">
</p>

The memory stage in a Y86 64-bit processor with pipelining is responsible for accessing memory to read or write data, and also for handling any memory-related hazards that may occur in the pipeline. The memory stage works as follows:
- If the instruction involves a memory access, the memory address is computed based on the operands received from the previous stage, typically the execute stage.
- A read or write request is sent to the memory subsystem to access the data at the memory location specified by the address.
- If the instruction is a load instruction, the data that is read from memory is passed on to the next stage of the pipeline, typically the write-back stage.
- If the instruction is a store instruction, the data to be written to memory is passed on to the memory subsystem.
- If a memory-related hazard occurs, such as a load-use hazard, where a later instruction depends on the data loaded by an earlier instruction, the pipeline may need to be stalled or data forwarding techniques may need to be used to resolve the hazard.

Because memory accesses can significantly impede processor performance, the memory step is a crucial one in the pipeline. Techniques like caching, prefetching, and speculative execution may be utilised to boost performance by reducing memory-related delays, this is common in modern processors but it's beyond the scope of this project.

## Write-back

Registers are updated in this stage. Often, instructions require registered values from previous instructions but this cannot be done until the previous instructions have gone through writeback stage. Thus it is not uncommon to stall instructions to avoid such control hazards.


## Pipeline control logic

We are now prepared to create the pipeline control logic to finish our design. The following control scenarios, for which alternative mechanisms like data forwarding and branch prediction are insufficient, must be handled using this logic:
- Load/use hazards: The pipeline must stall for one cycle between an instruction that reads a value from memory and an instruction that uses this value.
- Processing `ret`: The pipeline must stall until the `ret` instruction reaches the write-back stage.
- Mispredicted branches. By the time the branch logic detects that a jump should not have been taken, several instructions at the branch target will have started down the pipeline. These instructions must be canceled, and fetching should begin at the instruction following the jump instruction.

 Bubbling and stalling has been used to overcome these hazzards.

<br>
<p align = "center">
<img src = "https://user-images.githubusercontent.com/94699627/223896489-53ac8265-8fdc-4f3d-b1f7-e46247fe259e.png" witdth="424" height="501">
</p>

- Bubbling is a technique used to insert a "bubble" or a no-operation (NOP) instruction into the pipeline to stall the pipeline and allow the preceding instructions to complete execution. This is typically used to resolve control hazards, where a branch instruction has not yet resolved and the pipeline needs to wait until the correct instruction path is determined.
- Stalling, on the other hand, is a technique used to hold a stage of the pipeline in place and prevent it from advancing until the preceding stage has completed its work. This is typically used to resolve data hazards, where a later instruction depends on data produced by an earlier instruction that has not yet completed execution. The stalled instruction remains in the pipeline, but no further progress is made until the data dependency is resolved.

Both techniques are used to ensure correct program execution and avoid hazards that can arise in pipelined processors. However, they can also introduce additional delays and reduce performance if used excessively, so they need to be used judiciously. Techniques such as forwarding and speculation can be used to reduce the need for bubbling and stalling in the pipeline.


# Results

# Pipeline processor working

We gave the processor model a series of different instructions to check it's functionality and robustness. For example below is a set of instructions given and the result obtained:

`under progress`
