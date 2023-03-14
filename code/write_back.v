module write_back(clk, W_icode, W_valE, W_valM, W_dstE, W_dstM, reg_mem0, reg_mem1, reg_mem2, reg_mem3,
              reg_mem4, reg_mem5, reg_mem6, reg_mem7, reg_mem8, reg_mem9, reg_mem10, reg_mem11,
              reg_mem12, reg_mem13, reg_mem14);

input clk;
input [3:0] W_icode, W_stat, W_dstE, W_dstM;
input [63:0] W_valE, W_valM;


output reg [3:0] w_stat;

output reg [63:0] reg_mem0;
output reg [63:0] reg_mem1;
output reg [63:0] reg_mem2;
output reg [63:0] reg_mem3;
output reg [63:0] reg_mem4;
output reg [63:0] reg_mem5;
output reg [63:0] reg_mem6;
output reg [63:0] reg_mem7;
output reg [63:0] reg_mem8;
output reg [63:0] reg_mem9;
output reg [63:0] reg_mem10;
output reg [63:0] reg_mem11;
output reg [63:0] reg_mem12;
output reg [63:0] reg_mem13;
output reg [63:0] reg_mem14;

reg [63:0] reg_file[0:14];

  initial begin
    reg_file[0]= 64'h0 ;
    reg_file[1]= 64'h1 ;
    reg_file[2]= 64'h2 ;
    reg_file[3]= 64'h3 ;
    reg_file[4]= 64'h4 ;
    reg_file[5]= 64'h5 ;
    reg_file[6]= 64'h6 ;
    reg_file[7]= 64'h7 ;
    reg_file[8]= 64'h8 ;
    reg_file[9]= 64'h9 ;
    reg_file[10]= 64'hA ;
    reg_file[11]= 64'hB ;
    reg_file[12]= 64'hC ;
    reg_file[13]= 64'hD ;
    reg_file[14]= 64'hE ;
  end

always@(posedge clk)
  begin
    
    if(W_icode==4'b0011) // irmovq
    begin
      reg_file[W_dstE]=W_valE;
    end

    else if(W_icode==4'b0101) // mrmovq
    begin
      reg_file[W_dstM]=W_valM;
    end

    else if(W_icode==4'b0010) // cmovxx
    begin
        reg_file[W_dstE]=W_valE;
    end

    else if(W_icode==4'b0110) // OPq
    begin
      reg_file[W_dstE]=W_valE;
    end

    else if(W_icode==4'b1010) // pushq
    begin
      reg_file[4]=W_valE; // %rsp update
    end

    else if(W_icode==4'b1011) // popq
    begin
      reg_file[4]=W_valE; // %rsp update
      reg_file[W_dstM]=W_valM;
    end

    else if(W_icode==4'b1000) // call
    begin
      reg_file[4]=W_valE; // %rsp update
    end

    else if(W_icode==4'b1001) // ret
    begin
      reg_file[4]=W_valE; // %rsp update
    end

  end

  always @(*)
  begin

    reg_mem0=reg_file[0];
    reg_mem1=reg_file[1];
    reg_mem2=reg_file[2];
    reg_mem3=reg_file[3];
    reg_mem4=reg_file[4];
    reg_mem5=reg_file[5];
    reg_mem6=reg_file[6];
    reg_mem7=reg_file[7];
    reg_mem8=reg_file[8];
    reg_mem9=reg_file[9];
    reg_mem10=reg_file[10];
    reg_mem11=reg_file[11];
    reg_mem12=reg_file[12];
    reg_mem13=reg_file[13];
    reg_mem14=reg_file[14];
    w_stat=W_stat;

  end

endmodule