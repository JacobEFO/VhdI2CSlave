set FLAG=-v -Pwork --syn-binding --ieee=synopsys --std=93c -fexplicit

ghdl -r --work=obj --workdir=..\obj %FLAG% tb_i2cslave_write_reg_map --wave=..\obj\verification\i2cslave\write\res_tb_i2cslave_write_reg_map.ghw
@REM ghdl -r --work=obj --workdir=..\obj %FLAG% tb_i2cslave_read_reg_map --wave=..\obj\verification\i2cslave\read\res_tb_i2cslave_read_reg_map.ghw