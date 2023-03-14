`include "fetch.v"
`include "f_reg.v"
`include "decode.v"
`include "d_reg.v"
`include "execute.v"
`include "e_reg.v"
`include "memory.v"
`include "m_reg.v"
`include "write_back.v"
`include "w_reg.v"
`include "control.v"

module processor();

reg clk;
reg [63:0] F_pc;
reg [3:0] F_stat;

wire [3:0] f_icode, f_ifun, f_rA, f_rB;
wire [63:0] f_valC, f_valP, F_predPC, predPC, PC_new;
wire instr_valid, imem_err, hlt;


wire [3:0] D_icode, D_ifun, D_rA, D_rB;
wire [3:0] d_dstE, d_dstM, d_srcA, d_srcB, d_icode, d_ifun;
wire [63:0] D_valC, D_valP, d_valC;
wire [63:0] d_valA, d_valB;


wire [63:0] e_valE;
wire [3:0] e_dstE;
wire [3:0] e_icode, e_dstM;
wire [63:0] e_valA;
wire [3:0] E_icode, E_ifun, E_dstE, E_dstM;
wire [63:0] E_valA, E_valB, E_valC;
wire e_cnd;

wire [63:0] M_valA, M_valE;
wire [3:0] M_icode, M_dstE, M_dstM;
wire [3:0] m_dstE, m_dstM, m_icode;
wire [63:0] m_valE;
wire M_cnd;
wire [63:0] m_valM;

wire [63:0] W_valM, W_valE;
wire [3:0] W_icode, W_dstM, W_dstE;

wire [3:0] f_stat,d_stat,e_stat,m_stat,w_stat;
wire [3:0] D_stat,E_stat,M_stat,W_stat;

reg [63:0] reg_file [0:14] ;
wire [63:0] reg_wire [0:14];


// ******** calling pipeline modules ********* //

f_reg FR1(clk,F_stall,F_pc, predPC, F_predPC,F_stat,f_stat);

d_reg DR1(clk, f_icode, f_ifun, f_rA, f_rB, f_stat, f_valP, f_valC, instr_valid, imem_err, hlt,D_stall,D_bubble, D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP, D_stat);

e_reg ER1(clk, d_valA, d_valB, d_valC, d_dstE, d_dstM, d_srcA, d_srcB, d_icode, d_ifun, d_stat, E_stat, E_icode, E_ifun, E_valA, E_valB, E_valC, E_dstE, E_dstM, E_bubble);

m_reg MR1(clk, e_stat, M_stat, e_icode, M_icode, e_cnd, M_cnd, e_valE, M_valE, e_valA, M_valA, e_dstE, M_dstE, e_dstM, M_dstM, M_bubble);

w_reg WR1(clk, m_stat, W_stat, m_icode, W_icode, m_valE, W_valE, m_valM, W_valM, m_dstE, m_dstM, W_dstE, W_dstM, W_stall);

fetch F1(clk, F_pc, f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP, f_stat, F_stat, predPC, instr_valid, imem_err, hlt);

select_PC SPC1(clk, F_predPC, W_valM, M_valA, M_icode, W_icode, M_cnd, PC_new);

decode D1(clk ,D_icode ,D_ifun ,D_rA ,D_rB ,D_valC, D_valP ,D_stat,
e_dstE ,e_valE ,M_dstE ,M_valE ,M_dstM ,m_valM, W_dstM ,W_valM ,W_dstE ,W_valE,
reg_wire[0], reg_wire[1], reg_wire[2], reg_wire[3], reg_wire[4], reg_wire[5], reg_wire[6], reg_wire[7],reg_wire[8], reg_wire[9], reg_wire[10], reg_wire[11], reg_wire[12], 
reg_wire[13], reg_wire[14], d_icode ,d_ifun ,d_valC ,d_valA ,d_valB ,d_dstE ,d_dstM ,d_srcA ,d_srcB, d_stat
);

execute E1(clk ,E_stat ,E_icode ,E_ifun ,E_valA ,E_valB ,E_valC ,E_dstE ,E_dstM ,W_stat ,m_stat,
e_stat ,e_icode ,e_cnd ,e_valE ,e_valA ,e_dstE ,e_dstM);

memory M1(clk, M_stat, M_icode, M_valE, M_valA, M_dstE, M_dstM, m_stat, m_icode, m_valE, m_valM, m_dstE, m_dstM);

write_back WB1(clk, W_icode, W_valE, W_valM, W_dstE, W_dstM, 
            reg_wire[0], reg_wire[1], reg_wire[2], reg_wire[3], reg_wire[4], reg_wire[5], reg_wire[6], reg_wire[7], 
            reg_wire[8], reg_wire[9], reg_wire[10], reg_wire[11], reg_wire[12], reg_wire[13], reg_wire[14]);
//e_Cnd to e_cnd changes
ctrl_lgc CTRl1(clk,W_stat,e_cnd,m_stat,E_dstM,d_srcB,d_srcA,D_icode,E_icode,E_bubble,M_bubble,D_bubble, set_cc,W_stall ,D_stall, F_stall);
initial
    begin
    
    $dumpfile("processor.vcd");
    $dumpvars(0, processor);

    clk = 1;
    F_pc = 64'd0;
    F_stat = 3'b1;
    $monitor("time=%0d, \n F_stall=%0d, D_stall=%0d, W_stall=%0d, E_bub=%0d,\nclk=%0d, f_icode=%0d, f_ifun=%0d, f_rA=%0d, f_rB=%0d, D_srcA=%0d, D_srcB=%0d, F_pc=%0d, f_valC=%0d, D_icode=%0d, E_icode=%0d,M_icode=%0d, W_icode=%0d,\n mem_err=%0d, halt=%0d, 0=%0d, 1=%0d, 2=%0d, 3=%0d, 4=%0d, 5=%0d, 6=%0d, 7=%0d, 8=%0d, 9=%0d, 10=%0d, 11=%0d, 12=%0d, 13=%0d, 14=%0d\nE_dstM=%0d ,W_valE=%0d ,m_valE=%0d ,e_valE=%0d ,M_valE=%0d ,m_valM=%0d \n", 
            $time, F_stall, D_stall,W_stall,E_bubble,clk,f_icode, f_ifun, f_rA, f_rB,d_srcA,d_srcB ,F_pc, f_valC, D_icode, E_icode, M_icode, W_icode, imem_err, hlt, 
            reg_file[0], reg_file[1], reg_file[2], reg_file[3], reg_file[4], reg_file[5], reg_file[6], reg_file[7], reg_file[8],
            reg_file[9], reg_file[10], reg_file[11], reg_file[12], reg_file[13], reg_file[14],E_dstM,W_valE,m_valE,e_valE,M_valE,m_valM);    

//     $monitor("time=%0d \n\n,F_pc=%0d, \nF_stat=%0d, \nf_icode=%0d \n f_ifun=%0d \n f_rA=%0d \n f_rB=%0d, \n f_valC=%0d \n f_valP=%0d \n F_predPC=%0d \n predPC=%0d \n PC_new=%0d, \ninstr_valid=%0d \n imem_err=%0d \n hlt=%0d, \nD_icode=%0d \n D_ifun=%0d \n D_rA=%0d \n D_rB=%0d, \n d_dstE=%0d \n d_dstM=%0d \n d_srcA=%0d \n d_srcB=%0d \n d_icode=%0d \n d_ifun=%0d, \nD_valC=%0d \n D_valP=%0d \n d_valC=%0d, \nd_valA=%0d \n d_valB=%0d, \ne_valE=%0d, \ne_dstE=%0d, \ne_icode=%0d \n e_dstM=%0d, \ne_valA=%0d, \nE_icode=%0d \n E_ifun=%0d \n E_dstE=%0d \n E_dstM=%0d, \nE_valA=%0d \n E_valB=%0d \n E_valC=%0d, \ne_cnd=%0d, \nM_valA=%0d \n M_valE=%0d \nM_icode=%0d \n M_dstE=%0d \n M_dstM=%0d, \nm_dstE=%0d \n m_dstM=%0d \n m_icode=%0d, \nm_valE=%0d, \nM_cnd=%0d, \nm_valM=%0d, \nW_valM=%0d \n W_valE=%0d, \nW_icode=%0d \n W_dstM=%0d \n W_dstE=%0d, \nf_stat=%0d \nd_stat=%0d \ne_stat=%0d \nm_stat=%0d \nw_stat=%0d, \nD_stat=%0d \nE_stat=%0d \nM_stat=%0d \nW_stat=%0d"
//                 ,$time,F_pc, 
// F_stat, 

// f_icode, f_ifun, f_rA, f_rB, 
// f_valC, f_valP, F_predPC, predPC, PC_new, 
// instr_valid, imem_err, hlt, 


// D_icode, D_ifun, D_rA, D_rB, 
// d_dstE, d_dstM, d_srcA, d_srcB, d_icode, d_ifun, 
// D_valC, D_valP, d_valC, 
// d_valA, d_valB, 


// e_valE, 
// e_dstE, 
// e_icode, e_dstM, 
// e_valA, 
// E_icode, E_ifun, E_dstE, E_dstM, 
// E_valA, E_valB, E_valC, 
// e_cnd, 

// M_valA, M_valE, 
// M_icode, M_dstE, M_dstM, 
// m_dstE, m_dstM, m_icode, 
// m_valE, 
// M_cnd, 
// m_valM, 

// W_valM, W_valE, 
// W_icode, W_dstM, W_dstE, 

// f_stat,d_stat,e_stat,m_stat,w_stat, 
// D_stat,E_stat,M_stat,W_stat);

    end

always #5 clk = ~clk;   
   

always@(*)
    begin
       // if(hlt == 1) //changes
       
       if(W_stat == 2)  
            $finish;
    end

always@(*)
    begin
        F_pc <= PC_new;
    end

always@(*)
    begin
        reg_file[0] = reg_wire[0];
        reg_file[1] = reg_wire[1];
        reg_file[2] = reg_wire[2];
        reg_file[3] = reg_wire[3];
        reg_file[4] = reg_wire[4];
        reg_file[5] = reg_wire[5];
        reg_file[6] = reg_wire[6];
        reg_file[7] = reg_wire[7];
        reg_file[8] = reg_wire[8];
        reg_file[9] = reg_wire[9];
        reg_file[10] = reg_wire[10];
        reg_file[11] = reg_wire[11];
        reg_file[12] = reg_wire[12];
        reg_file[13] = reg_wire[13];
        reg_file[14] = reg_wire[14];
    end

endmodule