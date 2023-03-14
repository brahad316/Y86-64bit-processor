module decode (clk ,D_icode ,D_ifun ,D_rA ,D_rB ,D_valC, D_valP ,D_stat,
e_dstE ,e_valE ,M_dstE ,M_valE ,M_dstM ,m_valM, W_dstM ,W_valM ,W_dstE ,W_valE,
value0, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10, value11, value12, value13, value14,
d_icode ,d_ifun ,d_valC ,d_valA ,d_valB ,d_dstE ,d_dstM ,d_srcA ,d_srcB, d_stat
);

reg [3:0]  inp1,inp2;

output reg [63:0] d_valA ,d_valB, d_valC;
output reg [3:0] d_dstE ,d_dstM;
output reg [3:0] d_srcA ,d_srcB;
output reg [3:0] d_icode ,d_ifun;
output reg [3:0] d_stat;

input clk;
input [3:0] D_icode, D_ifun;
input [3:0] D_rA, D_rB;
input [63:0] D_valC, D_valP;
input [3:0] D_stat;

input [3:0] e_dstE;
input [3:0] M_dstE;
input [3:0] M_dstM;
input [3:0] W_dstM;
input [3:0] W_dstE;

input [63:0] e_valE;
input [63:0] M_valE;
input [63:0] m_valM;
input [63:0] W_valM;
input [63:0] W_valE;

//reg file

input [63:0] value0;
input [63:0] value1;
input [63:0] value2;
input [63:0] value3;
input [63:0] value4;
input [63:0] value5;
input [63:0] value6;
input [63:0] value7;
input [63:0] value8;
input [63:0] value9;
input [63:0] value10;
input [63:0] value11;
input [63:0] value12;
input [63:0] value13;
input [63:0] value14;

reg [0:63] list[0:14];


always@* begin
   
   d_icode <= D_icode;
   d_ifun <= D_ifun;
   d_valC <= D_valC;
   d_stat <= D_stat;

   list[0] <= value0;
   list[1] <= value1;
   list[2] <= value2;
   list[3] <= value3;
   list[4] <= value4;
   list[5] <= value5;
   list[6] <= value6;
   list[7] <= value7;
   list[8] <= value8;
   list[9] <= value9;
   list[10] <= value10;
   list[11] <= value11;
   list[12] <= value12;
   list[13] <= value13;
   list[14] <= value14;

d_dstE = 4'b1111; //f
d_dstM = 4'b1111; //f

case(D_icode)
   
   4'h2  : begin          
       inp1 = D_rA;
       d_dstE = D_rB;
   end

   4'h3 : d_dstE = D_rB;

   4'h4  : begin                      
      inp1 = D_rA;
      inp2 = D_rB;
   end

   4'h5  : begin
      inp2 = D_rB;
      d_dstM = D_rA;
   end

   4'h6  :  begin                      
      inp1 = D_rA;
      inp2 = D_rB;
      d_dstE = D_rB;
   end

   4'h8  :   begin  
      inp2 = 4'd4;
      d_dstE = 4'd4;
   end 

   4'h9  :  begin  
      inp1 = 4'd4;  
      inp2 = 4'd4;
      d_dstE = 4'd4;
   end 

   4'hA  :  begin  
      inp1 = D_rA;
      inp2 = 4'd4;
      d_dstE = 4'd4;
   end 
      
   4'hB  :  begin
      inp1 = 4'd4; 
      inp2 = 4'd4; 
      d_dstE = 4'd4;
      d_dstM = D_rA;
   end 
endcase

d_srcA= inp1;
d_srcB= inp2;

end

// Data word   Register    ID Source description
// e_valE      e_dstE      ALU output
// m_valM      M_dstM      Memory output
// M_valE      M_dstE      Pending write to port E in memory stage
// W_valM      W_dstM      Pending write to port M in write-back stage
// W_valE      W_dstE      Pending write to port E in write-back stage

always@(*)
   begin
      if(D_icode == 7 || D_icode == 8)
         d_valA = D_valP;
      else if(d_srcA == e_dstE)
         d_valA = e_valE;
      else if(d_srcA == M_dstM)
         d_valA = m_valM;
      else if(d_srcA == M_dstE)
         d_valA = M_valE;
      else if(d_srcA == W_dstM)
         d_valA = W_valM;
      else if(d_srcA == W_dstE)
         d_valA = W_valE;
      else
         d_valA = list[d_srcA];
   end
   

always@(*)
   begin
      //data forwarding
      //using if else instead of case wise since the order of the statements is important
      if(d_srcB == e_dstE)
         d_valB = e_valE;
      else if(d_srcB == M_dstM)
         d_valB = m_valM;
      else if(d_srcB == M_dstE)
         d_valB = M_valE;
      else if(d_srcB == W_dstM)
         d_valB = W_valM;
      else if(d_srcB == W_dstE)
         d_valB = W_valE;
      else
         d_valB = list[d_srcB];
   end

endmodule

//temp reg_file to be moved to wD_rApper
