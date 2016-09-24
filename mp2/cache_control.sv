module cache_control (
input mem_read,
input mem_write,
input mem_resp,
input pmem_resp,
input pmem_read,
input pmem_write,
input lru_out,
input hit1, hit2,
input hit_flag,
input dirty_flag,

output dirty1, dirty2,
output lru_in
);

enum int unsigned {
idle,
read_pmem,
write_pmem
}, state, next_state

always_comb
begin: state_actions

// set default values

// set logic for each state

case(state)

	idle: begin
	
	end
	
	read_pmem: begin
	
	end
	
	write_pmem: begin
	
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
		else if(dirty_flag == 1 && hit_flag == 0)
			next_state = write_pmem;
		else if(dirty_flag == 0 && hit_flag == 0)
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