module f_reg(clk,F_stall,F_pc, predPC, F_predPC,F_stat,f_stat);

input clk,F_stall;
input [3:0] F_stat;
input [63:0] predPC ,F_pc;
output reg [63:0] F_predPC;
output reg [3:0] f_stat;

always @(posedge clk)
    begin
        f_stat <= F_stat;
        if(!F_stall)
        begin
            F_predPC <= predPC;
        end
        else
        begin
            F_predPC <= F_pc;
        end
    end
endmodule
