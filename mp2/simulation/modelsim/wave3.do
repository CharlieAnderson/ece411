onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mp2_tb/clk
add wave -noupdate /mp2_tb/pmem_resp
add wave -noupdate /mp2_tb/pmem_read
add wave -noupdate /mp2_tb/pmem_write
add wave -noupdate /mp2_tb/pmem_address
add wave -noupdate /mp2_tb/pmem_rdata
add wave -noupdate /mp2_tb/pmem_wdata
add wave -noupdate /mp2_tb/dut/CPU/cpu_data/regfile/data
add wave -noupdate /mp2_tb/dut/CPU/cpu_ctrl/mem_resp
add wave -noupdate /mp2_tb/dut/CPU/cpu_ctrl/state
add wave -noupdate /mp2_tb/dut/CPU/cpu_ctrl/next_state
add wave -noupdate /mp2_tb/dut/Cache/controller/state
add wave -noupdate /mp2_tb/dut/Cache/controller/mem_resp
add wave -noupdate /mp2_tb/dut/Cache/controller/dirty_flag
add wave -noupdate /mp2_tb/dut/Cache/controller/hit_flag
add wave -noupdate /mp2_tb/dut/CPU/mem_read
add wave -noupdate /mp2_tb/dut/CPU/mem_write
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {241997 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 321
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {21 us}
