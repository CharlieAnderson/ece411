module cache (
	input clk,
    input mem_read,
    input mem_write,
    input lc3b_mem_wmask mem_byte_enable,
    input lc3b_word mem_address,
    input lc3b_word mem_wdata,
    input pmem_resp,
    input [127:0]pmem_rdata,

    output logic [127:0]pmem_wdata,
    output logic pmem_read,
    output logic pmem_write,
    output logic [15:0]pmem_address,
    output logic mem_resp,
    output logic [15:0] mem_rdata
);



cache_datapath datapath (
	.clk(clk),
	.dirty1(dirty1), 
	.dirty2(dirty2),
	.valid1(valid1), 
	.valid2(valid2),
	.lru_in(lru_in),
	.mem_address(mem_address),
	.load_dirty1(load_dirty1), 
	.load_dirty2(load_dirty2),
	.load_tag1(load_tag1),
	.load_tag2(load_tag2),
	.load_valid1(load_valid1), 
	.load_valid2(load_valid2),
	.load_data1(load_data1), 
	.load_data2(load_data2),
	.load_lru(load_lru),
	.datain1_sel(datain1_sel), 
	.datain2_sel(datain2_sel),
	.pmem_rdata(pmem_rdata),
	.mem_wdata(mem_wdata),

	.hit1(hit1), 
	.hit2(hit2),
	.hit_flag(hit_flag), 
	.dirty_flag(dirty_flag),
	.lru_out(lru_out),
	.data_out(data_out),
	.pmem_wdata(pmem_wdata),
	.mem_rdata(mem_rdata)
);

cache_control controller (

	.mem_read(mem_read),
	.mem_write(mem_write),
	.pmem_resp(pmem_resp),
	.lru_out(lru_out),
	.hit1(hit1), 
	.hit2(hit2),
	.hit_flag(hit_flag),
	.dirty_flag(dirty_flag),

	.dirty1(dirty1), 
	.dirty2(dirty2),
	.lru_in(lru_in),
	.load_dirty1(load_dirty1), 
	.load_dirty2(load_dirty2),
	.load_tag1(load_tag1), 
	.load_tag2(load_tag2),
	.load_valid1(load_valid1), 
	.load_valid2(load_valid2),
	.load_data1(load_data1),
	.load_data2(load_data2),
	.load_lru(load_lru),
	.datain1_sel(datain1_sel), 
	.datain2_sel(datain2_sel),
	.mem_resp(mem_resp),
	.pmem_read(pmem_read),
	.pmem_write(pmem_write)
);




endmodule : cache