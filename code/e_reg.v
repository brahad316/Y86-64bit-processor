module e_reg(clk ,d_valA ,d_valB ,d_valC ,d_dstE ,d_dstM ,d_srcA ,d_srcB ,d_icode ,d_ifun ,d_stat ,
E_stat ,E_icode ,E_ifun ,E_valA ,E_valB ,E_valC ,E_dstE ,E_dstM, E_bubble
);
input clk, E_bubble;
input [63:0] d_valA ,d_valB, d_valC;
input [3:0] d_dstE ,d_dstM;
input [3:0] d_srcA ,d_srcB;
input [3:0] d_icode ,d_ifun;
input [3:0] d_stat;

output reg[3:0]  E_stat;
output reg[3:0]  E_icode,E_ifun;
output reg[63:0] E_valA ,E_valB ,E_valC ;
output reg[3:0]  E_dstE ,E_dstM;

always @(posedge clk)
begin 
   //changes
   if(!E_bubble)begin
      E_icode <=  d_icode;
      E_ifun  <=  d_ifun ;
      E_dstE  <=  d_dstE ;
      E_dstM  <=  d_dstM ;
   end
   else begin
      E_icode = 4'b1;
      E_dstE  <=  4'hF ;
      E_dstM  <=  4'hF ;
   end
   E_stat  <=  d_stat ;
   E_valA  <=  d_valA ;
   E_valB  <=  d_valB ;
   E_valC  <=  d_valC ;
   
   
end

endmodule