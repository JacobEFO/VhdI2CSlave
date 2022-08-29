#!/bin/bash
FLAG="-v -Pwork --syn-binding --ieee=synopsys --std=08 -fexplicit"
# ghdl -r --work=obj --workdir=../obj $FLAG tb_i2cslave_read --vcd=../obj/verification/read/res_tb_i2cslave_read.vcd
ghdl -r --work=obj --workdir=../obj $FLAG tb_i2cslave_read --wave=../obj/verification/i2cslave/read/res_tb_i2cslave_read.ghw
ghdl -r --work=obj --workdir=../obj $FLAG tb_i2cslave_write --wave=../obj/verification/i2cslave/write/res_tb_i2cslave_write.ghw
# ghdl -r --work=obj --workdir=../obj $FLAG tb_reg_map --vcd=../obj/verification/reg_map/res_tb_reg_map.vcd --wave=../obj/verification/reg_map/res_tb_reg_map.ghw
ghdl -r --work=obj --workdir=../obj $FLAG tb_i2cslave_write_reg_map -wave=../obj/verification/i2cslave/write/res_tb_i2cslave_write_reg_map.ghw
