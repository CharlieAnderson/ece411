import lc3b_types::*;

module mux2_128 #(parameter width = 128)
(
	input sel, 
	input [width-1:0] a, b,
	output logic [width-1:0] f
);

always_comb
begin
	if(sel == 0)
		f = a;
	else
		f = b;
end

endmodule : mux2_128