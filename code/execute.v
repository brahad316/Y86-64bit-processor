`include "alu_64.v"

module execute(clk ,E_stat ,E_icode ,E_ifun ,E_valA ,E_valB ,E_valC ,E_dstE ,E_dstM ,W_stat ,m_stat,
e_stat ,e_icode ,e_cnd ,e_valE ,e_valA ,e_dstE ,e_dstM);

input clk;
input [3:0]  E_stat;
input [3:0]  E_icode,E_ifun;
input [63:0] E_valA ,E_valB ,E_valC ;
input [3:0]  E_dstE ,E_dstM;
input [3:0]  W_stat ,m_stat;

output reg [63:0] e_valA ,e_valE;
output reg [3:0] e_dstE ,e_dstM;
output reg [3:0]  e_icode;
output reg [3:0]  e_stat ;

output reg e_cnd;

reg [1:0]  func;
reg [63:0] inp1,inp2;

wire [63:0] out1;
wire of;

reg [2:0]CC;  // as zf,sf,of

alu_64 inst1(func,inp1,inp2,out1,of);


always@* begin

   e_icode <= E_icode;
   e_stat  <= E_stat ;
   e_valA  <= E_valA ;
   e_dstM  <= E_dstM ;
   e_cnd = 0;

   e_dstE = E_dstE; //f

case(E_icode)

   4'h2  :begin
      func =0;
      inp1 =e_valA;
      inp2 =0;
      case(E_ifun)
         4'h0: e_cnd =1;
         4'h1: e_cnd = ((CC[1]^CC[2]) || CC[0]);
         4'h2: e_cnd = ((CC[1]^CC[2]));
         4'h3: e_cnd = CC[0];
         4'h4: begin
            if(!CC[0])
                 e_cnd = 1;
         end
         4'h5:begin
            if(!(CC[1]^CC[2]))
            e_cnd =1;
         end
         4'h6:begin
           if(!((CC[1]^CC[2]) || CC[0]))
           e_cnd =1;
         end
      endcase
      if(!e_cnd)
         e_dstE = 4'b1111;
   end

   4'h3  :begin
      func =0;
      inp1 =E_valC;
      inp2 =0;
   end

   4'h4  :begin 
      func =0;
      inp1 =E_valB;
      inp2 =E_valC;
   end

   4'h5  :begin  
      func =0;
      inp1 =E_valC;
      inp2 =E_valB;
   end

   4'h6  :begin
      func =E_ifun[1:0];
      inp1 =E_valA;
      inp2 =E_valB;

      //zf,sf,of respectively
      CC[0] = (out1==1'b0);
      CC[1] = (out1<1'b0);
      CC[2] = (E_valA<1'b0==E_valB<1'b0)&&(out1<1'b0!=E_valA<1'b0);
   end

   4'h7  :begin
      case(E_ifun)
         4'h0: e_cnd =1;
         4'h1: e_cnd = ((CC[1]^CC[2]) || CC[0]);
         4'h2: e_cnd = ((CC[1]^CC[2]));
         4'h3: e_cnd = CC[0];
         4'h4: begin
            if(!CC[0])
               e_cnd = 1;
         end
         4'h5:begin
            if(!(CC[1]^CC[2]))
            e_cnd =1;
         end
         4'h6:begin
           if(!((CC[1]^CC[2]) || CC[0]))
           e_cnd =1;
         end
      endcase
   end

   4'h8  :begin
      func =1;//flip the order of subtrction
      inp2 =64'h8;
      inp1 =E_valB;
   end 

   4'h9  :begin 
      func =0;
      inp1 =64'h8;
      inp2 =E_valB;
   end 

   4'hA  :begin
      func =1;//flip the order of subtrction
      inp2 =64'h8;
      inp1 =E_valB;
   end 
      
   4'hB  :begin
      func =0;
      inp1 =64'h8;
      inp2 =E_valB;
   end 
endcase

e_valE = out1; 
end
endmodule