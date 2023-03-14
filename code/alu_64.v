module alu_64 (op, a, b, alu_out, alu_of);

input  [64:1]a,b;
input [2:1]op;
output [64:1]alu_out;
output alu_of;


wire [64:1] out0;
wire [64:1] out1;
wire [64:1] out2;
wire of0;
// wire [64:1]p, q;
wire [64:1] int0;
wire [64:1] int1;
wire [64:1] int2;
// wire [64:1] int3;
wire [2:1] nop;
// assign p = 64'd0;
// assign q = 64'd0;
not(nop[1],op[1]);
not(nop[2],op[2]);

wire [3:2] con;
and(con[2], nop[1],op[2]);
and(con[3], op[1],op[2]);

add_sub pro1(a, b, out0, op[1], of0);
// add_sub pro2(a, b, out1, 1, of1);
and_64 pro2(a, b, out1);
xor_64 pro3(a, b, out2);

genvar k;

// generate

//  	for(i = 1; i <= 64; i = i + 1)
// 	begin
//  		xor(p[i], op[2], 0); 
//         xor(q[i], op[1], 0); 
// 	end

// endgenerate

generate
    
 	for(k = 1; k <= 64; k = k + 1)
	begin
		and(int0[k],out0[k],nop[2]);
		and(int1[k],out1[k],con[2]);
		and(int2[k],out2[k],con[3]);

 		or(alu_out[k],int2[k],int0[k],int1[k]);

	end

endgenerate

xor(alu_of, of0, 0);

endmodule
/////////////////////////////////////////////////////////////////////////////////////////////////

module add_sub (inp1, inp2, out, op1, of); // "op" for operation select functionality 

input  [64:1]inp1,inp2;
output [64:1]out;
wire   [64:1]xc;
wire   [64:0]carry;
output of;
input op1;
genvar i;

xor(carry[0], op1,0); // op is 0 for addition, 1 for subtraction 

generate

 	for(i = 1; i <= 64; i = i + 1)
	begin
 		xor(xc[i], inp2[i], op1);
        full_adder any(inp1[i], xc[i], carry[i-1], carry[i], out[i]);
	end

endgenerate

	assign of = carry[64];

endmodule

// *************** //

module half_adder (A2, B2, S2, C2);

input A2, B2;
output S2, C2;

xor(S2, A2, B2);
and(C2, A2, B2);

endmodule

// *************** //

module full_adder (A1, B1, Cin1, C1, S1);

input A1, B1, Cin1;
output S1, C1;
wire s1, c1, c2;

half_adder half_adder_inst1(A1, B1, s1, c1);
half_adder half_adder_inst2(s1, Cin1, S1, c2);
or(C1, c1, c2);

endmodule


module and_64 (inp1a, inp2a, outa);

input  [64:1]inp1a,inp2a;
output [64:1]outa;
// input op;
genvar i;

generate
 
 	for(i = 1; i<=64;i = i+1)
    begin
 		and(outa[i],inp1a[i],inp2a[i]);
	end
	endgenerate

endmodule


module xor_64 (inp1b, inp2b, outb);

input  [64:1]inp1b,inp2b;
output [64:1]outb;
// input op;
genvar i;

generate
 
 	for( i = 1; i<=64;i = i+1)
    begin
 		xor(outb[i],inp1b[i],inp2b[i]);
	end
	endgenerate

endmodule
