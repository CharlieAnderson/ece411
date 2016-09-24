module cache_datapath (

);


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
.datain(),
.dataout()
);


and_gate hit1 (

);

and_gate hit2 (

);

and_gate dirty_bit1 (

);

and_gate dirty_bit2 (

);

or_gate hit_gate (

);

or_gate dirty_gate (

);


mux2 data_out_mux (

);

mux8 word_mux (

);

endmodule : cache_datapath