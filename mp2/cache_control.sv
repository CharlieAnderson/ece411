import lc3b_types::*;

module cache_control (
	input clk,
	input mem_read,
	input mem_write,
	input pmem_resp,
	input lru_out,
	input hit1_out, hit2_out,
	input hit_flag,
	input dirty_flag,
	input dirty_bit1_out, dirty_bit2_out,
	output logic dirty1, dirty2,
	output logic lru_in,
	output logic load_dirty1, load_dirty2,
	output logic load_tag1, load_tag2,
	output logic load_valid1, load_valid2,
	output logic load_data1, load_data2,
	output logic load_lru,
	output logic datain1_sel,
	
	output logic mem_resp,
	output logic pmem_read,
	output logic pmem_write,
	output logic [1:0]pmem_addr_mux_sel
);

enum int unsigned {
idle,
read_pmem,
write_pmem
} state, next_state;

always_comb
begin: state_actions

// set default values
mem_resp = 1'b0;

dirty1 =  1'b0;
dirty2 = 1'b0; //not sure if these should be an output or some kind of combinatorial logic somewhere else
lru_in = 1'b0;
load_lru = 1'b0;
load_dirty1 = 1'b0;
load_dirty2 = 1'b0;
load_tag2 = 1'b0;
load_tag1 = 1'b0;
load_valid1 = 1'b0;
load_valid2 = 1'b0;
load_data2 = 1'b0;
load_data1 = 1'b0;
pmem_read = 1'b0;
pmem_write = 1'b0;
datain1_sel = 1'b0;
pmem_addr_mux_sel = 2'b00;
// set logic for each state

case(state)

	idle: 
	begin
		if(hit_flag == 1)
		begin
			if(mem_read == 1) 
			begin
				mem_resp = 1'b1;

				load_lru = 1;
				if(hit1_out == 1)
				begin
					lru_in = 1'b1; // least recent will be the opposite lru
				end
				if(hit2_out == 1)
				begin
					lru_in = 1'b0;	// load line 1 as lru
				end
			end

			if(mem_write == 1) 
			begin
				datain1_sel = 1;
				mem_resp = 1;
				load_lru = 1;
				// TODO: do something with write, like check if dirty bits are 0 or seomthing and then change them
			end
		end
	end
	
	read_pmem: begin
		pmem_addr_mux_sel = 2'b11;
		pmem_read = 1;

		if(lru_out==0) 
		begin

			load_valid1 = 1;
			load_tag1 = 1;
			if(pmem_resp == 1)	//???
				load_data1 = 1;
			load_dirty1 = 1;	//unset way1 dirty bit
			dirty1 = 0;
		end
		else if(lru_out==1) 
		begin

			load_valid2 = 1;
			load_tag2 = 1;
			if(pmem_resp == 1)	//???
				load_data2 = 1;
			load_dirty2 = 1;  //unset way2 dirty bit
			dirty2 = 0;
		end
	end
	
	write_pmem: begin
		pmem_write = 1;
		if(lru_out == 0)
			pmem_addr_mux_sel = 2'b00;
		else if(lru_out == 1)
			pmem_addr_mux_sel = 2'b01;
	end

	default: ;
	
endcase
end


always_comb
begin: next_state_logic

case(state)

	idle: begin
		if(hit_flag == 0)
		begin
	/*		if(dirty_flag == 0 && hit_flag == 0)	// else we can read if there is a miss (no hits) and no set dirty bits
				next_state = read_pmem;
				*/
			if((dirty_bit1_out == 1 && lru_out == 0) || (dirty_bit2_out == 1 && lru_out == 1))	// if something set the dirty bit, we need to write
				next_state = write_pmem;
			else
				next_state = read_pmem; 
		end
		else
			next_state = idle;
	end
	
	read_pmem: begin
		if(pmem_resp == 0)
			next_state = read_pmem;
		else
			next_state = idle;
	end
	
	write_pmem: begin
		if(pmem_resp == 1)
			next_state = read_pmem;
		else
			next_state = write_pmem;
	end
	
	default: next_state = idle;
	
endcase
end

always_ff @(posedge clk)
begin: next_state_assignment
    /* Assignment of next state on clock edge */
	 state <= next_state;
end

endmodule : cache_control