module select_PC(clk, F_predPC, W_valM, M_valA, M_icode, W_icode, M_cnd, PC_new);

input clk;
input [63:0] F_predPC, W_valM, M_valA;
input [3:0] M_icode, W_icode;
input M_cnd;

output reg [63:0] PC_new;

always @(*)
    begin
        if(M_icode==7 && !M_cnd)
        begin
            PC_new <= M_valA;
        end
        else if(W_icode==9)
        begin
            PC_new <= W_valM;
        end
        else
        begin
            PC_new <= F_predPC;
        end
    end

endmodule

module fetch (clk, F_pc, f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP, f_stat, F_stat, predPC, instr_valid, imem_err, hlt);

input clk;
input [63:0] F_pc;
input [3:0] F_stat;
output reg [3:0] f_icode, f_ifun, f_rA, f_rB, f_stat;
output reg [63:0] f_valP, predPC;
output reg [0:63] f_valC;
output reg instr_valid, imem_err, hlt;

reg [7:0]  memory[0:1023]; // 1 KB
reg [0:79] instruction; // lsb -> msb... 0th bit is least significant

initial begin 

  // Instruction memory
 hlt = 0;
 /* memory[0] = 8'h10; // nop
	
	memory[1] = 8'h30; // irmovq
	memory[2] = 8'hF0; // noreg, %rax
	memory[3] = 8'h23; // 35
	memory[4] = 8'h01; // 256
	memory[5] = 8'h00; // 0
	memory[6] = 8'h00; // 0
	memory[7] = 8'h00; // 0
	memory[8] = 8'h00; // 0
	memory[9] = 8'h00; // 0
	memory[10] = 8'h00; // 0
	
	memory[11] = 8'h21; // cmovle
	memory[12] = 8'h01; // %rax, %rcx
	
	memory[13] = 8'h30; // irmovq
	memory[14] = 8'hF2; // noreg, %rdx
	memory[15] = 8'h10; // 16
	memory[16] = 8'h00; // 0
	memory[17] = 8'h00; // 0
	memory[18] = 8'h00; // 0
	memory[19] = 8'h00; // 0
	memory[20] = 8'h00; // 0
	memory[21] = 8'h00; // 0
	memory[22] = 8'h00; // 0
	
	memory[23] = 8'h30; // irmovq
	memory[24] = 8'hF3; // noreg, %rbx
	memory[25] = 8'h00; // 0
	memory[26] = 8'h01; // 256
	memory[27] = 8'h00; // 0
	memory[28] = 8'h00; // 0
	memory[29] = 8'h00; // 0
	memory[30] = 8'h00; // 0
	memory[31] = 8'h00; // 0
	memory[32] = 8'h00; // 0
	
	memory[33] = 8'h73; // je
	memory[34] = 8'h2C; // 44
	memory[35] = 8'h00; // 0
	memory[36] = 8'h00; // 0
	memory[37] = 8'h00; // 0
	memory[38] = 8'h00; // 0
	memory[39] = 8'h00; // 0
	memory[40] = 8'h00; // 0
	memory[41] = 8'h00; // 0
	
	memory[42] = 8'h61; // subq
	memory[43] = 8'h32; // %rbx, %rdx
	
	memory[44] = 8'h71; // jle
	memory[45] = 8'h3F; // 63
	memory[46] = 8'h00; // 0
	memory[47] = 8'h00; // 0
	memory[48] = 8'h00; // 0
	memory[49] = 8'h00; // 0
	memory[50] = 8'h00; // 0
	memory[51] = 8'h00; // 0
	memory[52] = 8'h00; // 0
	
	memory[53] = 8'h30; // irmovq
	memory[54] = 8'hF3; // noreg, %rbx
	memory[55] = 8'h11; // 17
	memory[56] = 8'h01; // 256
	memory[57] = 8'h00; // 0
	memory[58] = 8'h00; // 0
	memory[59] = 8'h00; // 0
	memory[60] = 8'h00; // 0
	memory[61] = 8'h00; // 0
	memory[62] = 8'h00; // 0
	
	memory[63] = 8'h21; // cmovle
	memory[64] = 8'h01; // %rax, %rcx
	
	memory[65] = 8'h30; // irmovq
	memory[66] = 8'hF4; // noreg, %rsp
	memory[67] = 8'h0A; // 10
	memory[68] = 8'h00; // 0
	memory[69] = 8'h00; // 0
	memory[70] = 8'h00; // 0
	memory[71] = 8'h00; // 0
	memory[72] = 8'h00; // 0
	memory[73] = 8'h00; // 0
	memory[74] = 8'h00; // 0
	
	memory[75] = 8'h80; // call
	memory[76] = 8'h5F; // 95
	memory[77] = 8'h00; // 0
	memory[78] = 8'h00; // 0
	memory[79] = 8'h00; // 0
	memory[80] = 8'h00; // 0
	memory[81] = 8'h00; // 0
	memory[82] = 8'h00; // 0
	memory[83] = 8'h00; // 0
	
	memory[84] = 8'h40; // rmmovq
	memory[85] = 8'h37; // %rbx, %rdi
	memory[86] = 8'h05; // 5
	memory[87] = 8'h00; // 0
	memory[88] = 8'h00; // 0
	memory[89] = 8'h00; // 0
	memory[90] = 8'h00; // 0
	memory[91] = 8'h00; // 0
	memory[92] = 8'h00; // 0
	memory[93] = 8'h00; // 0
	
	memory[94] = 8'h00; // halt
	
	memory[95] = 8'h63; // xorq
	memory[96] = 8'h01; // %rax, %rcx
	
	memory[97] = 8'h90; // ret */
	
	/* memory[0] = 8'h30; // irmovq
	memory[1] = 8'hF2; // noreg, %rdx
	memory[2] = 8'h80; // 128
	memory[3] = 8'h00; // 0
	memory[4] = 8'h00; // 0
	memory[5] = 8'h00; // 0
	memory[6] = 8'h00; // 0
	memory[7] = 8'h00; // 0
	memory[8] = 8'h00; // 0
	memory[9] = 8'h00; // 0
	
	memory[10] = 8'h30; // irmovq
	memory[11] = 8'hF1; // noreg, %rcx
	memory[12] = 8'h03; // 3
	memory[13] = 8'h00; // 0
	memory[14] = 8'h00; // 0
	memory[15] = 8'h00; // 0
	memory[16] = 8'h00; // 0
	memory[17] = 8'h00; // 0
	memory[18] = 8'h00; // 0
	memory[19] = 8'h00; // 0
	
	memory[20] = 8'h40; // rmmovq
	memory[21] = 8'h2c; // %rdx, %rcx
	memory[22] = 8'h00; // 0
	memory[23] = 8'h00; // 0
	memory[24] = 8'h00; // 0
	memory[25] = 8'h00; // 0
	memory[26] = 8'h00; // 0
	memory[27] = 8'h00; // 0
	memory[28] = 8'h00; // 0
	memory[29] = 8'h00; // 0
	
	memory[30] = 8'h30; // irmovq
	memory[31] = 8'hF3; // noreg, %rbx
	memory[32] = 8'h0A; // 10
	memory[33] = 8'h00; // 0
	memory[34] = 8'h00; // 0
	memory[35] = 8'h00; // 0
	memory[36] = 8'h00; // 0
	memory[37] = 8'h00; // 0
	memory[38] = 8'h00; // 0
	memory[39] = 8'h00; // 0
	
	memory[40] = 8'h50; // mrmovq
	memory[41] = 8'h02; // %rax, %rdx
	memory[42] = 8'h00; // 0
	memory[43] = 8'h00; // 0
	memory[44] = 8'h00; // 0
	memory[45] = 8'h00; // 0
	memory[46] = 8'h00; // 0
	memory[47] = 8'h00; // 0
	memory[48] = 8'h00; // 0
	memory[49] = 8'h00; // 0
	
	memory[50] = 8'h60; // addq
	memory[51] = 8'h03; // %rax, %rbx
	
	memory[52] = 8'h00; // halt */
	
	// Data Forwarding TEST
	/* memory[0] = 8'h10; // nop
	
	memory[1] = 8'h30; // irmovq
	memory[2] = 8'hF2; // noreg, %rdx
	memory[3] = 8'h0A; // 10
	memory[4] = 8'h00; // 0
	memory[5] = 8'h00; // 0
	memory[6] = 8'h00; // 0
	memory[7] = 8'h00; // 0
	memory[8] = 8'h00; // 0
	memory[9] = 8'h00; // 0
	memory[10] = 8'h00; // 0
	
	memory[11] = 8'h30; // irmovq
	memory[12] = 8'hF0; // noreg, %rax
	memory[13] = 8'h03; // 3
	memory[14] = 8'h00; // 0
	memory[15] = 8'h00; // 0
	memory[16] = 8'h00; // 0
	memory[17] = 8'h00; // 0
	memory[18] = 8'h00; // 0
	memory[19] = 8'h00; // 0
	memory[20] = 8'h00; // 0
	
	memory[21] = 8'h60; // addq
	memory[22] = 8'h02; // %rax, %rdx
	
	memory[23] = 8'h00; // halt */
	
	// ret TEST
	/*memory[0] = 8'h10; // nop
	
	memory[1] = 8'h30; // irmovq
	memory[2] = 8'hF4; // noreg, %rsp
	memory[3] = 8'h0A; // 10
	memory[4] = 8'h00; // 0
	memory[5] = 8'h00; // 0
	memory[6] = 8'h00; // 0
	memory[7] = 8'h00; // 0
	memory[8] = 8'h00; // 0
	memory[9] = 8'h00; // 0
	memory[10] = 8'h00; // 0
	
	memory[11] = 8'h80; // call
	memory[12] = 8'h20; // 32
	memory[13] = 8'h00; // 0
	memory[14] = 8'h00; // 0
	memory[15] = 8'h00; // 0
	memory[16] = 8'h00; // 0
	memory[17] = 8'h00; // 0
	memory[18] = 8'h00; // 0
	memory[19] = 8'h00; // 0
	
	memory[20] = 8'h30; // irmovq
	memory[21] = 8'hF6; // noreg, %rsi
	memory[22] = 8'h05; // 5
	memory[23] = 8'h00; // 0
	memory[24] = 8'h00; // 0
	memory[25] = 8'h00; // 0
	memory[26] = 8'h00; // 0
	memory[27] = 8'h00; // 0
	memory[28] = 8'h00; // 0
	memory[29] = 8'h00; // 0
	
	memory[30] = 8'h00; // halt
	
	memory[31] = 8'hF0; // invalid
	
	memory[32] = 8'h30; // irmovq
	memory[33] = 8'hF7; // noreg, %rdi
	memory[34] = 8'hFF; // -1
	memory[35] = 8'hFF; // 0
	memory[36] = 8'hFF; // 0
	memory[37] = 8'hFF; // 0
	memory[38] = 8'hFF; // 0
	memory[39] = 8'hFF; // 0
	memory[40] = 8'hFF; // 0
	memory[41] = 8'hFF; // 0

	memory[42] = 8'h90; // ret

	memory[43] = 8'h30; // irmovq
	memory[44] = 8'hF0; // noreg, %rax
	memory[45] = 8'h01; // 1
	memory[46] = 8'h00; // 0
	memory[47] = 8'h00; // 0
	memory[48] = 8'h00; // 0
	memory[49] = 8'h00; // 0
	memory[50] = 8'h00; // 0
	memory[51] = 8'h00; // 0
	memory[52] = 8'h00; // 0
	
	memory[53] = 8'h30; // irmovq
	memory[54] = 8'hF1; // noreg, %rcx
	memory[55] = 8'h02; // 2
	memory[56] = 8'h00; // 0
	memory[57] = 8'h00; // 0
	memory[58] = 8'h00; // 0
	memory[59] = 8'h00; // 0
	memory[60] = 8'h00; // 0
	memory[61] = 8'h00; // 0
	memory[62] = 8'h00; // 0
	
	memory[63] = 8'h30; // irmovq
	memory[64] = 8'hF2; // noreg, %rdx
	memory[65] = 8'h03; // 3
	memory[66] = 8'h00; // 0
	memory[67] = 8'h00; // 0
	memory[68] = 8'h00; // 0
	memory[69] = 8'h00; // 0
	memory[70] = 8'h00; // 0
	memory[71] = 8'h00; // 0
	memory[72] = 8'h00; // 0
	
	memory[73] = 8'h30; // irmovq
	memory[74] = 8'hF3; // noreg, %rbx
	memory[75] = 8'h04; // 4
	memory[76] = 8'h00; // 0
	memory[77] = 8'h00; // 0
	memory[78] = 8'h00; // 0
	memory[79] = 8'h00; // 0
	memory[80] = 8'h00; // 0
	memory[81] = 8'h00; // 0
	memory[82] = 8'h00; // 0 */
	
  /*
	// Mispredicted Branch TEST
	memory[0] = 8'h10; // nop
	
	memory[1] = 8'h63; // xorq
	memory[2] = 8'h11; // %rax, %rax
	
	memory[3] = 8'h74; // jne
	memory[4] = 8'h1A; // 26
	memory[5] = 8'h00; // 0
	memory[6] = 8'h00; // 0
	memory[7] = 8'h00; // 0
	memory[8] = 8'h00; // 0
	memory[9] = 8'h00; // 0
	memory[10] = 8'h00; // 0
	memory[11] = 8'h00; // 0
	
	memory[12] = 8'h30; // irmovq
	memory[13] = 8'hF0; // noreg, %rax
	memory[14] = 8'h01; // 1
	memory[15] = 8'h00; // 0
	memory[16] = 8'h00; // 0
	memory[17] = 8'h00; // 0
	memory[18] = 8'h00; // 0
	memory[19] = 8'h00; // 0
	memory[20] = 8'h00; // 0
	memory[21] = 8'h00; // 0
	
	memory[22] = 8'h10; // nop
	
	memory[23] = 8'h10; // nop
	
	memory[24] = 8'h10; // nop
	
	memory[25] = 8'h00; // halt
	
	memory[26] = 8'h30; // irmovq
	memory[27] = 8'hF2; // noreg, %rdx
	memory[28] = 8'h03; // 3
	memory[29] = 8'h00; // 0
	memory[30] = 8'h00; // 0
	memory[31] = 8'h00; // 0
	memory[32] = 8'h00; // 0
	memory[33] = 8'h00; // 0
	memory[34] = 8'h00; // 0
	memory[35] = 8'h00; // 0
	
	memory[36] = 8'h30; // irmovq
	memory[37] = 8'hF1; // noreg, %rcx
	memory[38] = 8'h04; // 4
	memory[39] = 8'h00; // 0
	memory[40] = 8'h00; // 0
	memory[41] = 8'h00; // 0
	memory[42] = 8'h00; // 0
	memory[43] = 8'h00; // 0
	memory[44] = 8'h00; // 0
	memory[45] = 8'h00; // 0
	
	memory[46] = 8'h30; // irmovq
	memory[47] = 8'hF2; // noreg, %rdx
	memory[48] = 8'h05; // 5
	memory[49] = 8'h00; // 0
	memory[50] = 8'h00; // 0
	memory[51] = 8'h00; // 0
	memory[52] = 8'h00; // 0
	memory[53] = 8'h00; // 0
	memory[54] = 8'h00; // 0
	memory[55] = 8'h00; // 0 
	memory[56] = 8'h00; // halt */
	// Mispredicted Branch and ret TEST
	/* memory[0] = 8'h10; // nop
	
	memory[1] = 8'h30; // irmovq
	memory[2] = 8'hF4; // noreg, %rsp
	memory[3] = 8'h20; // 32
	memory[4] = 8'h00; // 0
	memory[5] = 8'h00; // 0
	memory[6] = 8'h00; // 0
	memory[7] = 8'h00; // 0
	memory[8] = 8'h00; // 0
	memory[9] = 8'h00; // 0
	memory[10] = 8'h00; // 0
	
	memory[11] = 8'h30; // irmovq
	memory[12] = 8'hF0; // noreg, %rax
	memory[13] = 8'h39; // 57
	memory[14] = 8'h00; // 0
	memory[15] = 8'h00; // 0
	memory[16] = 8'h00; // 0
	memory[17] = 8'h00; // 0
	memory[18] = 8'h00; // 0
	memory[19] = 8'h00; // 0
	memory[20] = 8'h00; // 0
	
	memory[21] = 8'hA0; // pushq
	memory[22] = 8'h0F; // %rax, noreg
	
	memory[23] = 8'h63; // xorq
	memory[24] = 8'h00; // %rax, %rax
	
	memory[25] = 8'h74; // jne
	memory[26] = 8'h2D; // 45
	memory[27] = 8'h00; // 0
	memory[28] = 8'h00; // 0
	memory[29] = 8'h00; // 0
	memory[30] = 8'h00; // 0
	memory[31] = 8'h00; // 0
	memory[32] = 8'h00; // 0
	memory[33] = 8'h00; // 0
	
	memory[34] = 8'h30; // irmovq
	memory[35] = 8'hF0; // noreg, %rax
	memory[36] = 8'h01; // 1
	memory[37] = 8'h00; // 0
	memory[38] = 8'h00; // 0
	memory[39] = 8'h00; // 0
	memory[40] = 8'h00; // 0
	memory[41] = 8'h00; // 0
	memory[42] = 8'h00; // 0
	memory[43] = 8'h00; // 0
	
	memory[44] = 8'h00; // halt
	
	memory[45] = 8'h90; // ret
	
	memory[46] = 8'h30; // irmovq
	memory[47] = 8'hF3; // noreg, %rbx
	memory[48] = 8'h02; // 2
	memory[49] = 8'h00; // 0
	memory[50] = 8'h00; // 0
	memory[51] = 8'h00; // 0
	memory[52] = 8'h00; // 0
	memory[53] = 8'h00; // 0
	memory[54] = 8'h00; // 0
	memory[55] = 8'h00; // 0
	
	memory[56] = 8'h00; // halt
	
	memory[57] = 8'h30; // irmovq
	memory[58] = 8'hF2; // noreg, %rdx
	memory[59] = 8'h03; // 3
	memory[60] = 8'h00; // 0
	memory[61] = 8'h00; // 0
	memory[62] = 8'h00; // 0
	memory[63] = 8'h00; // 0
	memory[64] = 8'h00; // 0
	memory[65] = 8'h00; // 0
	memory[66] = 8'h00; // 0
	
	memory[67] = 8'h00; // halt */
	
	// Load/Use Hazard TEST
	/*memory[0] = 8'h10; // nop
	
	memory[1] = 8'h30; // irmovq
	memory[2] = 8'hF2; // noreg, %rdx
	memory[3] = 8'h80; // 128
	memory[4] = 8'h00; // 0
	memory[5] = 8'h00; // 0
	memory[6] = 8'h00; // 0
	memory[7] = 8'h00; // 0
	memory[8] = 8'h00; // 0
	memory[9] = 8'h00; // 0
	memory[10] = 8'h00; // 0
	
	memory[11] = 8'h30; // irmovq
	memory[12] = 8'hF1; // noreg, %rcx
	memory[13] = 8'h03; // 3
	memory[14] = 8'h00; // 0
	memory[15] = 8'h00; // 0
	memory[16] = 8'h00; // 0
	memory[17] = 8'h00; // 0
	memory[18] = 8'h00; // 0
	memory[19] = 8'h00; // 0
	memory[20] = 8'h00; // 0
	
	memory[21] = 8'h40; // rmmovq
	memory[22] = 8'h12; // %rcx, %rdx
	memory[23] = 8'h00; // 0
	memory[24] = 8'h00; // 0
	memory[25] = 8'h00; // 0
	memory[26] = 8'h00; // 0
	memory[27] = 8'h00; // 0
	memory[28] = 8'h00; // 0
	memory[29] = 8'h00; // 0
	memory[30] = 8'h00; // 0
	
	memory[31] = 8'h30; // irmovq
	memory[32] = 8'hF3; // noreg, %rbx
	memory[33] = 8'h0A; // 10
	memory[34] = 8'h00; // 0
	memory[35] = 8'h00; // 0
	memory[36] = 8'h00; // 0
	memory[37] = 8'h00; // 0
	memory[38] = 8'h00; // 0
	memory[39] = 8'h00; // 0
	memory[40] = 8'h00; // 0
	
	memory[41] = 8'h50; // mrmovq
	memory[42] = 8'h02; // %rax, %rdx
	memory[43] = 8'h00; // 0
	memory[44] = 8'h00; // 0
	memory[45] = 8'h00; // 0
	memory[46] = 8'h00; // 0
	memory[47] = 8'h00; // 0
	memory[48] = 8'h00; // 0
	memory[49] = 8'h00; // 0
	memory[50] = 8'h00; // 0
	
	memory[51] = 8'h60; // addq
	memory[52] = 8'h30; // %rbx, %rax
	
	memory[53] = 8'h00; // halt
*/
  end
always @*
begin
  imem_err=0;
  if (F_pc > 101) begin
   imem_err =1;
  end

  instruction = {
    memory[F_pc],
    memory[F_pc+1],
    memory[F_pc+2],
    memory[F_pc+3],
    memory[F_pc+4],
    memory[F_pc+5],
    memory[F_pc+6],
    memory[F_pc+7],
    memory[F_pc+8],
    memory[F_pc+9]
  };

  f_icode = instruction[0:3];
  f_ifun  = instruction[4:7];
  instr_valid = 1'd0;
  hlt = 64'd0;
  case(f_icode)

    //hlt
    4'h0  : begin
      hlt = 64'd1;
      f_valP= F_pc + 64'd1;
    end

    //nop
    4'h1	: f_valP= F_pc + 64'd1;

    /* cmovXX
      4'd0	: //rrmovq
      4'd1	: //cmovle
      4'd2	: //cmovl
      4'd3	: //cmove
      4'd4	: //cmovne
      4'd5	: //cmovge
      4'd6	: //cmovg */
    4'h2	: begin            
      f_rA = instruction[8:11];
      f_rB = instruction[12:15];
      f_valP =F_pc + 64'd2;
    end
    

    //irmovq
    4'h3	: begin
        f_rA = instruction[8:11];  // F
        f_rB = instruction[12:15]; 
        f_valC = {
          instruction[72:79],
          instruction[64:71],
          instruction[56:63],
          instruction[48:55],
          instruction[40:47],
          instruction[32:39],
          instruction[24:31],
          instruction[16:23]
        };
        f_valP = F_pc + 64'd10;
    end
    
    //rmmovq
    4'h4	: begin
      f_rA = instruction[8:11];
      f_rB = instruction[12:15]; 
      f_valC = {
        instruction[72:79],
        instruction[64:71],
        instruction[56:63],
        instruction[48:55],
        instruction[40:47],
        instruction[32:39],
        instruction[24:31],
        instruction[16:23]
      };
      f_valP = F_pc + 64'd10;
    end

    //mrmovq  
    4'h5	: begin
      f_rA = instruction[8:11];
      f_rB = instruction[12:15]; 
      f_valC = {
        instruction[72:79],
        instruction[64:71],
        instruction[56:63],
        instruction[48:55],
        instruction[40:47],
        instruction[32:39],
        instruction[24:31],
        instruction[16:23]
      };
      f_valP = F_pc + 64'd10;
    end 
    
    /* opq
      4'd0	: //addq
      4'd1	: //subq
      4'd2	: //andq
      4'd3	: //xorq
      end*/
    4'h6	: begin
        f_rA[3:0] = instruction[8:11];
        f_rB[3:0] = instruction[12:15];
        f_valP = F_pc + 64'd2;
    end
      
    
    /* jump
      4'd0	: //jmp
      4'd1	: //jle
      4'd2	: //jl
      4'd3	: //je
      4'd4	: //jne
      4'd5	: //jge
      4'd6	: //jg*/
    4'h7	: begin
      f_valC = {
        instruction[64:71],
        instruction[56:63],
        instruction[48:55],
        instruction[40:47],
        instruction[32:39],
        instruction[24:31],
        instruction[16:23],
        instruction[8:15]
      };
      f_valP = F_pc + 64'd9;
    end 

    //call
    4'h8	: begin
      f_valC = {
        instruction[64:71],
        instruction[56:63],
        instruction[48:55],
        instruction[40:47],
        instruction[32:39],
        instruction[24:31],
        instruction[16:23],
        instruction[8:15]
      };
      f_valP = F_pc + 64'd9;
    end 

    4'h9  : f_valP = F_pc + 64'd1;//ret

    //pushq
    4'hA  :  begin            
      f_rA = instruction[8:11];
      f_rB = instruction[12:15];
      f_valP =F_pc + 64'd2;
    end

    //popq
    4'hB  :  begin            
      f_rA = instruction[8:11];
      f_rB = instruction[12:15];
      f_valP =F_pc + 64'd2;
    end
    
    default : instr_valid = 1'd1;
  endcase
  
end

// ***************************************** //
// ***************************************** //
// predicting PC
always@(f_valP or f_valC or f_icode)
    begin
        if(f_icode == 7 || f_icode == 8)
            begin
                predPC = f_valC;
            end
        else
            begin
                predPC = f_valP;
            end
    end

endmodule
