#!/bin/bash
FLAG="-v -Pwork --syn-binding --ieee=synopsys --std=93c -fexplicit"
ghdl -a --work=obj --workdir=../obj $FLAG ../src/design/i2cslave.vhd
ghdl -a --work=obj --workdir=../obj $FLAG ../src/verification/tb_i2cslave_write.vhd
ghdl -a --work=obj --workdir=../obj $FLAG ../src/verification/tb_i2cslave_read.vhd
