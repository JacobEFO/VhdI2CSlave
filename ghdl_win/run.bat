set FLAG=-v -Pwork --syn-binding --ieee=synopsys --std=93c -fexplicit

@REM ghdl -r --work=obj --workdir=..\obj %FLAG% tb_i2cslave_write_reg_map --wave=..\obj\verification\i2cslave\write\res_tb_i2cslave_write_reg_map.ghw
ghdl -r --work=chip_lib --workdir=..\obj %FLAG% tb_asic_wr --wave=..\obj\verification\chip\res_tb_asic_wr.ghw
@REM ghdl -r --work=obj --workdir=..\obj %FLAG% tb_i2cslave_read_reg_map --wave=..\obj\verification\i2cslave\read\res_tb_i2cslave_read_reg_map.ghw