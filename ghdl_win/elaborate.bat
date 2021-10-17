set FLAG=-v -Pwork --syn-binding --ieee=synopsys --std=93c -fexplicit

ghdl -e --work=obj --workdir=..\obj %FLAG% tb_i2cslave_write_reg_map
@REM ghdl -e --work=obj --workdir=..\obj %FLAG% tb_i2cslave_read_reg_map
