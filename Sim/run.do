restart
vcs -sverilog ahb3lite_pkg.sv ahb3lite_sram1rw.sv rl_ram_1r1w.sv rl_ram_1r1w_generic.sv testbench.sv 
set SimTime 100ns
./simv
