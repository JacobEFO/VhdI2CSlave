#!/bin/bash
FLAG="-v -Pwork --syn-binding --ieee=synopsys --std=93c -fexplicit"
ghdl -e --work=obj --workdir=../obj $FLAG tb_i2cslave_write
ghdl -e --work=obj --workdir=../obj $FLAG tb_i2cslave_read
