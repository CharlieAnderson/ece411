
import lc3b_types::*;

module cache (
	input clk,
    input mem_read,
    input mem_write,
    input lc3b_word mem_address,
    input lc3b_word mem_wdata,
    input pmem_resp,
    input [127:0]pmem_rdata,

    output logic [127:0]pmem_wdata,
    output logic pmem_read,
    output logic pmem_write,
    output lc3b_word pmem_address,
    output logic mem_resp,
    output lc3b_word mem_rdata
);

logic dirty1;
logic dirty2;
logic valid1;
logic valid2;
logic lru_in;
logic load_data1;
logic load_data2;
logic load_dirty1;
logic load_dirty2;
logic load_valid1;
logic load_valid2;
logic load_lru;
logic load_tag1;
logic load_tag2;
logic datain1_sel;
logic datain2_sel;
logic hit1_out;
logic hit2_out;
logic hit_flag;
logic dirty_flag;
logic lru_out;
logic [127:0]data_out;
logic [1:0]pmem_addr_mux_sel;
logic dirty_bit1_out;
logic dirty_bit2_out;

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
	.pmem_rdata(pmem_rdata),
	.mem_wdata(mem_wdata),
	.pmem_address(pmem_address),
	.pmem_addr_mux_sel(pmem_addr_mux_sel),
	.dirty_bit1_out(dirty_bit1_out),
   .dirty_bit2_out(dirty_bit2_out),
	.hit1_out(hit1_out), 
	.hit2_out(hit2_out),
	.hit_flag(hit_flag), 
	.dirty_flag(dirty_flag),
	.lru_out(lru_out),
	.pmem_wdata(pmem_wdata),
	.mem_rdata(mem_rdata)
);

cache_control controller (
	.clk(clk),
	.mem_read(mem_read),
	.mem_write(mem_write),
	.pmem_resp(pmem_resp),
	.lru_out(lru_out),
	.hit1_out(hit1_out), 
	.hit2_out(hit2_out),
	.hit_flag(hit_flag),
	.dirty_flag(dirty_flag),
	.dirty_bit1_out(dirty_bit1_out),
   .dirty_bit2_out(dirty_bit2_out),
	
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
	.mem_resp(mem_resp),
	.pmem_read(pmem_read),
	.pmem_write(pmem_write),
	.pmem_addr_mux_sel(pmem_addr_mux_sel)

);




endmodule : cache