module or_gate (
input a,b,
output logic out
);

always_comb 
begin: 
	if(a==1 || b==1)
		out = 1;
	else
		out = 0;
end

endmodule : or_gate 