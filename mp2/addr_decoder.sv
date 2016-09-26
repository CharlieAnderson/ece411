import lc3b_types::*;

module addr_decoder (
input [15:0] addr,
output logic [8:0] tag,
output logic [2:0] set, // 8 lines/blocks
output logic [3:0] offset // 2^4 = 16
);

always_comb 
begin
	tag = addr[15:7];
	set = addr[6:4];
	offset = addr[3:0];
end

endmodule : addr_decoder 
