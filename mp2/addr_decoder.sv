module addr_decoder (
input [15:0] addr,
output [5:0] tag,
output [7:0] set,
output [1:0] offset 
);

always_comb 
begin
	tag = addr[15:10];
	set = addr[9:2];
	offset = addr[1:0];
end

endmodule : addr_decoder 