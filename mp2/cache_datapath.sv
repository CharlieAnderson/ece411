import lc3b_types::*;

module cache_datapath (

	input clk,
	input dirty1, dirty2,
	input valid1, valid2,
	input lru_in,
	input lc3b_word mem_address,
	input load_dirty1, load_dirty2,
	input load_tag1, load_tag2,
	input load_valid1, load_valid2,
	input load_data1, load_data2,
	input load_lru,
	input datain1_sel,
	input [127:0]pmem_rdata,
	input lc3b_word mem_wdata,
	input logic [1:0]pmem_addr_mux_sel,

	output logic hit1_out, hit2_out,
	output logic hit_flag, dirty_flag,
	output logic lru_out,
	output logic [127:0] pmem_wdata,
	output logic dirty_bit1_out, dirty_bit2_out,
	output lc3b_word mem_rdata,
	output lc3b_word pmem_address


);

/*
TODO:
	-use mem_byte enable to determine where/what to write to memory, don't think we need it for the cp read
	-make sure we correctly select the data going into the data arrays, this also more for writing
	-need to somehow use which way is hit to decide which data goes to mem something data or something?
	- 


*/

logic data_out_sel;
lc3b_word word_out;
logic [2:0]set;
logic valid1_out, valid2_out;
logic [127:0]data1_out;
logic [127:0]data2_out;
logic [8:0]tag1_out;
logic [8:0]tag2_out;
logic comp1_out, comp2_out;
logic dirty1_out;
logic dirty2_out;
logic [8:0]tag;
logic [2:0]index;
logic [3:0]offset;
logic [127:0] data_in;
logic [127:0] data_out;
logic dirty_comp1_out;
logic dirty_comp2_out;

lc3b_word data1_word_out;
lc3b_word data2_word_out;
logic [127:0] lru_way_data_out;

//assign pmem_wdata = lru_way_data_out;
//assign mem_rdata = word_out;	//may be decided by which way is hit 

array #(.width(1)) dirty1_arr (
	.clk(clk),
	.write(load_dirty1),
	.index(index),
	.datain(dirty1),
	.dataout(dirty1_out)
);

array #(.width(1)) dirty2_arr (
	.clk(clk),
	.write(load_dirty2),
	.index(index),
	.datain(dirty2),
	.dataout(dirty2_out)
);

array #(.width(1)) valid1_arr (	// should be set to invalid by default?
	.clk(clk),
	.write(load_valid1),
	.index(index),
	.datain(1'b1),
	.dataout(valid1_out)
);

array #(.width(1)) valid2_arr (
	.clk(clk),
	.write(load_valid2),
	.index(index),
	.datain(1'b1),
	.dataout(valid2_out)
);

array #(.width(9)) tag1_arr (
	.clk(clk),
	.write(load_tag1),
	.index(index),
	.datain(tag),
	.dataout(tag1_out)
);

array #(.width(9)) tag2_arr (
	.clk(clk),
	.write(load_tag2),
	.index(index),
	.datain(tag),
	.dataout(tag2_out)
);

array #(.width(128)) data1_arr (
	.clk(clk),
	.write(load_data1),
	.index(index),
	.datain(data_in),
	.dataout(data1_out)
);

array #(.width(128)) data2_arr (
	.clk(clk),
	.write(load_data2),
	.index(index),
	.datain(data_in),
	.dataout(data2_out)
);

array #(.width(1)) lru_arr (
	.clk(clk),
	.write(load_lru),
	.index(index),
	.datain(lru_in),
	.dataout(lru_out)
);


and_gate hit1_gate (
	.a(valid1_out),
	.b(comp1_out),
	.out(hit1_out)
);

and_gate hit2_gate (
	.a(valid2_out),
	.b(comp2_out),
	.out(hit2_out)
);

and_gate dirty_bit1 (

	.a(dirty1_out),
	.b(valid1_out),
	.out(dirty_bit1_out)
);

and_gate dirty_bit2 (
	.a(dirty2_out),
	.b(valid2_out),
	.out(dirty_bit2_out)
);

or_gate hit_gate (
	.a(hit1_out),
	.b(hit2_out),
	.out(hit_flag)
);

or_gate dirty_gate (
	.a(dirty1_out),
	.b(dirty2_out),
	.out(dirty_flag)
);

comparator #(.width(9)) comp1 (
	.a(tag),
	.b(tag1_out),
	.out(comp1_out)
);

comparator #(.width(9)) comp2 (
	.a(tag),
	.b(tag2_out),
	.out(comp2_out)
);

comparator #(.width(16)) dirty_comp1 (
	.a(data1_word_out),
	.b(mem_wdata),
	.out(dirty_comp1_out)
);

comparator #(.width(16)) dirty_comp2 (
	.a(data2_word_out),
	.b(mem_wdata),
	.out(dirty_comp2_out)
);

mux2_128 datain_mux (
	.sel(datain1_sel),	//add another mux for the selections?
	.a(pmem_rdata),//??????????
	.b(data_out),
	.f(data_in)
);

/*
mux2 datain_mux2 (
	.sel(datain2_sel),	//add another mux for the selections?
	.a(data2_out),
	.b(pmem_rdata),
	.f(data_out)
);
*/
mux2_128 data_out_mux (
	.sel(data_out_sel),	//add another mux for the selections?
	.a(data1_out),
	.b(data2_out),
	.f(data_out) //might only be for pmemwdata
);

mux8 word_mux (
	.sel(offset[3:1]),	// only need 2 bits, lsb is always 0??????? offset is used for the indices within the selected index line!?
	.a(data_out[15:0]),
	.b(data_out[31:16]),
	.c(data_out[47:32]),
	.d(data_out[63:48]),
	.e(data_out[79:64]),
	.f(data_out[95:80]),
	.g(data_out[111:96]),
	.h(data_out[127:112]),
	.out(mem_rdata)
);

mux8 data1_word_mux (
	.sel(offset[3:1]),
	.a(data1_out[15:0]),
	.b(data1_out[31:16]),
	.c(data1_out[47:32]),
	.d(data1_out[63:48]),
	.e(data1_out[79:64]),
	.f(data1_out[95:80]),
	.g(data1_out[111:96]),
	.h(data1_out[127:112]),
	.out(data1_word_out)
);

mux8 data_2_word_mux (
	.sel(offset[3:1]),	
	.a(data2_out[15:0]),
	.b(data2_out[31:16]),
	.c(data2_out[47:32]),
	.d(data2_out[63:48]),
	.e(data2_out[79:64]),
	.f(data2_out[95:80]),
	.g(data2_out[111:96]),
	.h(data2_out[127:112]),
	.out(data2_word_out)
);

mux4 pmem_addr_mux (
	.sel(pmem_addr_mux_sel),
	.a({tag1_out, index, 4'b0000}),
	.b({tag2_out, index, 4'b0000}),
	.c(mem_address),
	.d(mem_address),
	.f(pmem_address)
);

mux4 #(.width(1))data_way_mux (	// select the 128 bits of data from the way that is hit 
	.sel({hit2_out, hit1_out}),
	.a(1'b0),
	.b(1'b0), //way 1
	.c(1'b1), //way2da
	.d(1'b0),
	.f(data_out_sel)

);

mux2_128 lru_data_way_mux ( //different from the data_way_mux, this one selects based on lru instead of hits
	.sel(lru_out),
	.a(data1_out),
	.b(data2_out),
	.f(pmem_wdata)
);

addr_decoder addr_decode (
	.addr(mem_address),
	.tag(tag),
	.set(index),
	.offset(offset)
);

endmodule : cache_datapath