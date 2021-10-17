set FLAG=-v -Pwork --syn-binding --ieee=synopsys --std=93c -fexplicit

@REM ghdl -e --work=chip_lib --workdir=..\obj %FLAG% tb_i2cslave_write_reg_map
ghdl -e --work=chip_lib --workdir=..\obj %FLAG% tb_asic_wr
@REM ghdl -e --work=obj --workdir=..\obj %FLAG% tb_i2cslave_read_reg_map
