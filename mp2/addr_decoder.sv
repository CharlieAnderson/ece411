module addr_decoder (
input [15:0] addr,
output [8:0] tag,
output [2:0] set, // 8 lines/blocks
output [3:0] offset // 2^4 = 16
);

always_comb 
begin
	tag = addr[15:7];
	set = addr[6:4];
	offset = addr[3:0];
end

endmodule : addr_decoder 