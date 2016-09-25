module cache_datapath (

	input clk,
	input dirty1, dirty2,
	input valid1, valid2,
	input lru_in,
	input [15:0]mem_address,
	input load_dirty1, load_dirty2,
	input load_tag1, load_tag2,
	input load_valid1, load_valid2,
	input load_data1, load_data2,
	input load_lru,
	input datain1_sel, datain2_sel,
	input [127:0]pmem_rdata,
	input [15:0]mem_wdata,

	output logic hit1, hit2,
	output logic hit_flag, dirty_flag,
	output logic lru_out,
	output logic [127:0] data_out,
	output logic [127:0] pmem_wdata,
	output logic [15:0] mem_rdata

);

/*
TODO:
	-use mem_byte enable to determine where/what to write to memory, don't think we need it for the cp read
	-make sure we correctly select the data going into the data arrays,
	-need to somehow use which way is hit to decide which data goes to mem something data or something
	- 


*/


logic valid1_out, valid2_out;
logic dirty1_out, dirty2_out;
logic [127:0]data1_out, [127:0]data2_out;
logic tag1_out, tag2_out;
logic comp1_out, comp2_out;
logic hit1_out, hit2_out;
logic dirty_bit1_out, dirty_bit2_out;
logic [8:0]tag;
logic [2:0]index;
logic [3:0]offset;

assign pmem_wdata = data_out;
assign mem_rdata = word_out;	//may be decided by which way is hit 

array #(.width(1)) dirty1 (
	.clk(clk),
	.write(load_dirty1),
	.index(index),
	.datain(dirty1),
	.dataout(dirty1_out)
);

array #(.width(1)) dirty2 (
	.clk(clk),
	.write(load_dirty2),
	.index(index),
	.datain(dirty2),
	.dataout(dirty2_out)
);

array #(.width(1)) valid1 (	// should be set to invalid by default?
	.clk(clk),
	.write(load_valid1),
	.index(index),
	.datain(valid1),
	.dataout(valid1_out)
);

array #(.width(1)) valid2 (
	.clk(clk),
	.write(load_valid2),
	.index(index),
	.datain(valid2),
	.dataout(valid2_out)
);

array #(.width(9)) tag1 (
	.clk(clk),
	.write(load_tag1),
	.index(index),
	.datain(tag),
	.dataout(tag1_out)
);

array #(.width(9)) tag2 (
	.clk(clk),
	.write(load_tag2),
	.index(index),
	.datain(tag),
	.dataout(tag2_out)
);

array #(.width(128)) data1 (
	.clk(clk),
	.write(load_data1),
	.index(index),
	.datain(),
	.dataout(data1_out)
);

array #(.width(128)) data2 (
	.clk(clk),
	.write(load_data2),
	.index(index),
	.datain(),
	.dataout(data2_out)
);

array #(.width(1)) lru (
	.clk(clk),
	.write(load_lru),
	.index(index),
	.datain(lru_in),
	.dataout(lru_out)
);


and_gate hit1 (
	.a(valid1_out),
	.b(comp1_out),
	.out(hit1_out)
);

and_gate hit2 (
	.a(valid2_out),
	.b(comp2_out),
	.out(hit2_out)
);

and_gate dirty_bit1 (
	.a(dirty1_out),
	.b(hit1_out),
	.out(dirty_bit1_out)
);

and_gate dirty_bit2 (
	.a(dirty2_out),
	.b(hit2_out),
	.out(dirty_bit2_out)
);

or_gate hit_gate (
	.a(hit1_out),
	.b(hit2_out),
	.out(hit_flag)
);

or_gate dirty_gate (
	.a(dirty_bit1_out),
	.b(dirty_bit2_out),
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

mux2 datain_mux1 (
	.sel(datain1_sel),	//add another mux for the selections?
	.a(data1_out),//??????????
	.b(pmem_rdata),
	.f(data_out)
);

mux2 datain_mux2 (
	.sel(datain2_sel),	//add another mux for the selections?
	.a(data2_out),
	.b(pmem_rdata),
	.f(data_out)
);

mux2 data_out_mux (
	.sel(lru_out),	//add another mux for the selections?
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
	.out(word_out)
);

addr_decoder addr_decode (
	.addr(mem_address),
	.tag(tag),
	.set(set),
	.offset(offset)
);

endmodule : cache_datapath