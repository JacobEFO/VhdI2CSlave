#!/bin/bash
FLAG="-v -Pwork --syn-binding --ieee=synopsys --std=08 -fexplicit"
ghdl -e --work=obj --workdir=../obj $FLAG tb_i2cslave_write
ghdl -e --work=obj --workdir=../obj $FLAG tb_i2cslave_write_reg_map
# ghdl -e --work=obj --workdir=../obj $FLAG tb_i2cslave_read
# ghdl -e --work=obj --workdir=../obj $FLAG tb_reg_map # Update rdy_i
