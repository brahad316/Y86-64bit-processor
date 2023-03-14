module d_reg(clk ,f_icode ,f_ifun ,f_rA ,f_rB ,f_stat ,f_valP ,f_valC ,instr_valid ,imem_err ,hlt ,D_stall,D_bubble,
D_icode ,D_ifun ,D_rA ,D_rB ,D_valC ,D_valP ,D_stat
);
input clk,D_stall,D_bubble;
input [3:0] f_icode, f_ifun, f_rA, f_rB, f_stat;
input [63:0] f_valP, f_valC;
input instr_valid, imem_err, hlt;

output reg [3:0] D_icode, D_ifun;
output reg [3:0] D_rA, D_rB;
output reg [63:0] D_valC, D_valP;
output reg [3:0] D_stat;

always @(posedge clk)
begin 
   
   if(!D_stall)
   begin
      if(!D_bubble) begin
         D_icode <=  f_icode; 
         D_ifun  <=  f_ifun ;
         D_rA    <=  f_rA   ;
         D_rB    <=  f_rB   ;
         D_valC  <=  f_valC ;
         D_valP  <=  f_valP ;
         if(hlt)begin
            D_stat <= 4'h2 ;
         end
         else if(imem_err)begin
            D_stat <= 4'h3 ;
         end
         else if(instr_valid)begin
            D_stat <= 4'h4;
         end
         else
            D_stat <= f_stat;
      end
      else 
      begin //changes added begin , end
         D_icode <= 4'b1;
         D_ifun  <= 4'b0;
      end
   end

end

endmodule
