module cache_control (
	input mem_read,
	input mem_write,
	input pmem_resp,
	input lru_out,
	input hit1, hit2,
	input hit_flag,
	input dirty_flag,

	output logic dirty1, dirty2,
	output logic [2:0]lru_in,
	output logic load_dirty1, load_dirty2,
	output logic load_tag1, load_tag2,
	output logic load_valid1, load_valid2,
	output logic load_data1, load_data2,
	output logic load_lru,
	output logic datain1_sel, datain2_sel,
	output logic mem_resp,
	output logic pmem_read,
	output logic pmem_write

);

enum int unsigned {
idle,
read_pmem,
write_pmem
}, state, next_state;

always_comb
begin: state_actions

// set default values
dirty1 =  1'b0;
dirty2 = 1'b0; //not sure if these should be an output or some kind of combinatorial logic somewhere else
lru_in = 3'b000;
load_lru = 1'b0;
load_dirty1 = 1'b0;
load_dirty2 = 1'b0;
load_tag2 = 1'b0;
load_tag1 = 1'b0;
load_valid1 = 1'b0;
load_valid2 = 1'b0;
load_data2 = 1'b0;
load_data1 = 1'b0;

// set logic for each state

case(state)

	idle: begin
		if(hit_flag)
		begin

			if(mem_read == 1) 
			begin
				if(hit1)
				begin
					load_lru = 1'b1;
					lru_in = 1'b1; // least recent will be the opposite lru
				end

				else if(hit2)
				begin
					load_lru = 1'b1;	
					lru_in = 1'b0;	// load line 1 as lru
				end

				mem_resp = 1'b1;
			end

			else if(mem_write == 1) 
			begin
				// TODO: do something with write, like check if dirty bits are 0 or seomthing and then change them
			end
		end
	end
	
	read_pmem: begin
		pmem_read = 1;
	end
	
	write_pmem: begin
		pmem_write = 1;
	end

	default: ;
	
endcase
end


always_comb
begin: next_state_logic

case(state)

	idle: begin
		if(pmem_read == 0 && pmem_write == 0) // should this be before or after the other conditions?
			next_state = idle;
		else if(dirty_flag == 1 && hit_flag == 0)	// if something set the dirty bit, we need to write
			next_state = write_pmem;
		else if(dirty_flag == 0 && hit_flag == 0)	// else we can read if there is a miss (no hits) and no set dirty bits
			next_state = read_pmem;
		else
			next_state = idle; // idle or fetch????????
	end
	
	read_pmem: begin
		if(pmem_resp == 1)
			next_state = idle;
		else
			next_state = read_pmem;
	end
	
	write_pmem: begin
		if(pmem_resp == 1 && pmem_read == 1)
			next_state = pmem_read;
		else
			next_state = write_pmem;
		end

endcase
end

endmodule : cache_control