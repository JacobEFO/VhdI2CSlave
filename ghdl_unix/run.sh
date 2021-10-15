#!/bin/bash
FLAG="-v -Pwork --syn-binding --ieee=synopsys --std=08 -fexplicit"
ghdl -r --work=obj --workdir=../obj $FLAG tb_i2cslave_read --vcd=../obj/verification/read/res_tb_i2cslave_read.vcd
ghdl -r --work=obj --workdir=../obj $FLAG tb_i2cslave_write --vcd=../obj/verification/write/res_tb_i2cslave_write.vcd --wave=../obj/verification/write/res_tb_i2cslave_write.ghw
