import lc3b_types::*;

module mp2 (
input clk,
input [127:0]pmem_rdata,
input pmem_resp,
output logic pmem_read,
output logic pmem_write,
output logic [15:0]pmem_address,
output logic [127:0]pmem_wdata
);

logic [15:0]mem_address;
logic [15:0]mem_rdata;
logic [15:0]mem_wdata;
logic mem_read;
logic mem_write;
logic mem_resp;
logic [1:0]mem_byte_enable;

cpu CPU (
    .clk(clk),

    /* Memory signals */
    .mem_resp(mem_resp),
    .mem_rdata(mem_rdata),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .mem_byte_enable(mem_byte_enable),
    .mem_address(mem_address),
    .mem_wdata(mem_wdata)
);

cache Cache (
	.clk(clk),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .mem_address(mem_address),
    .mem_wdata(mem_wdata),
    .pmem_resp(pmem_resp),
    .pmem_rdata(pmem_rdata),

    .pmem_wdata(pmem_wdata),
    .pmem_read(pmem_read),
    .pmem_write(pmem_write),
    .pmem_address(pmem_address),
    .mem_resp(mem_resp),
    .mem_rdata(mem_rdata)
);


endmodule : mp2