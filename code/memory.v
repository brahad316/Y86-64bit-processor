module memory(clk, M_stat, M_icode, M_valE, M_valA, M_dstE, M_dstM ,m_stat, m_icode, m_valE, m_valM, m_dstE, m_dstM);

input clk;
input wire [3:0] M_stat, M_icode, M_dstE, M_dstM;
input wire [63:0] M_valE ,M_valA;

output reg [63:0] m_valE, m_valM;
output reg [3:0] m_stat, m_icode, m_dstE, m_dstM;

reg [63:0] memory [0:1023]; // 1KB

always@(posedge clk) //chages
  begin

    if(M_icode==4'b0100) // rmmovq
    begin
      memory[M_valE]=M_valA;
    end
    
    if(M_icode==4'b1010) // pushq
    begin
      memory[M_valE]=M_valA;
    end

    if(M_icode==4'b1000) // call
    begin
      memory[M_valE]=M_valA;
    end

  end
  
always@(*) //changes
  begin
    
    if(M_icode==4'b0101) // mrmovq
    begin
      m_valM=memory[M_valE];
    end

    if(M_icode==4'b1011) // popq
    begin
      m_valM=memory[M_valE];
    end

    if(M_icode==4'b1001) // ret
    begin
      m_valM=memory[M_valA];
    end

  end

always@(*)
  begin
        m_stat  <= M_stat;
        m_icode <= M_icode;
        m_dstE  <= M_dstE;
        m_dstM  <= M_dstM;
        m_valE  <= M_valE;
  end

endmodule