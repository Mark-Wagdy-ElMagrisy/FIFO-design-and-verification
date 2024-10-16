vlib work
vlog -f src_files.list  +cover -covercells
vsim -voptargs="+cover=bcfst+top/DUT" work.top -cover -classdebug -uvmcontrol=all
add wave /top/fif/*
coverage save fifo_test.ucdb -onexit -du work.FIFO
#add wave /top/DUT/SVA_inst/*
run -all
quit -sim
vcover report fifo_test.ucdb -details -all -output coverage_rpt.txt
