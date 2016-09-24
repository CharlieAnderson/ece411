module cache_datapath (

	input clk,
	input dirty1,
	input dirty2,
	input lru_in,
	input mem_address,


	output hit1, hit2,
	output hit_flag, dirty_flag,
	output lru_out,


);


logic valid1_out, valid2_out;
logic dirty1_out, dirty2_out;
logic data1_out, data2_out;
logic tag1_out, tag2_out;
logic tag;
logic index;
logic offset;




array dirty1 (
	.clk(clk),
	.write(),
	.index(),
	.datain(),
	.dataout()
);

array dirty2 (
	.clk(clk),
	.write(),
	.index(),
	.datain(),
	.dataout()
);

array valid1 (
	.clk(clk),
	.write(),
	.index(),
	.datain(),
	.dataout()
);

array valid2 (
	.clk(clk),
	.write(),
	.index(),
	.datain(),
	.dataout()
);

array tag1 (
	.clk(clk),
	.write(),
	.index(),
	.datain(),
	.dataout()
);

array tag2 (
	.clk(clk),
	.write(),
	.index(),
	.datain(),
	.dataout()
);

array data1 (
	.clk(clk),
	.write(),
	.index(),
	.datain(),
	.dataout()
);

array data2 (
	.clk(clk),
	.write(),
	.index(),
	.datain(),
	.dataout()
);

array LRU (
	.clk(clk),
	.write(),
	.index(),
	.datain(lru_in),
	.dataout(lru_out)
);


and_gate hit1 (
	.a(),
	.b(),
	.out()
);

and_gate hit2 (
	.a(),
	.b(),
	.out()
);

and_gate dirty_bit1 (
	.a(),
	.b(),
	.out()
);

and_gate dirty_bit2 (
	.a(),
	.b(),
	.out()
);

or_gate hit_gate (
	.a(),
	.b(),
	.out()
);

or_gate dirty_gate (
	.a(),
	.b(),
	.out()
);


mux2 data_out_mux (
	.sel(),
	.a(),
	.b(),
	.f()
);

mux8 word_mux (
	.sel(),
	.a(),
	.b(),
	.c(),
	.d(),
	.e(),
	.f(),
	.g(),
	.h(),
	.out()
);

addr_decoder addr_decode (
	.addr(mem_address),
	.tag(tag),
	.set(set),
	.offset(offset)
);

endmodule : cache_datapath