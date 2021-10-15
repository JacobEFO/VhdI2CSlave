#!/bin/bash
FLAG="-v -Pwork --syn-binding --ieee=synopsys --std=93c -fexplicit"
ghdl -r --work=obj --workdir=../obj $FLAG tb_i2cslave_read --vcd=../obj/verification/read/res_tb_i2cslave_read.vcd
