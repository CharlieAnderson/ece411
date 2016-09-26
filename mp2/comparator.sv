import lc3b_types::*;

module comparator #(parameter width = 128)(
	input [width-1:0] a, b,
	output logic out
);


always_comb
	begin
		if(a==b)
			out = 1;
		else
			out = 0;
	end


endmodule : comparator