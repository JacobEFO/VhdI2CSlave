set FLAG=-v -Pwork --syn-binding --ieee=synopsys --std=93c -fexplicit

ghdl -a --work=obj --workdir=..\obj %FLAG% ..\src\design\i2cslave\i2cslave-ent.vhd
ghdl -a --work=obj --workdir=..\obj %FLAG% ..\src\design\i2cslave\i2cslave-arc.vhd
ghdl -a --work=obj --workdir=..\obj %FLAG% ..\src\design\i2cslave\i2cslave-pkg.vhd
ghdl -a --work=obj --workdir=..\obj %FLAG% ..\src\design\reg_map\reg_map-ent.vhd
ghdl -a --work=obj --workdir=..\obj %FLAG% ..\src\design\reg_map\reg_map-arc.vhd
ghdl -a --work=obj --workdir=..\obj %FLAG% ..\src\design\reg_map\reg_map-pkg.vhd
ghdl -a --work=obj --workdir=..\obj %FLAG% ..\src\design\chip_lib\asic\chip_asic.vhd
ghdl -a --work=obj --workdir=..\obj %FLAG% ..\src\verification\tb_i2cslave_write_reg_map.vhd
@REM ghdl -a --work=obj --workdir=..\obj %FLAG% ..\src\verification\tb_i2cslave_read_reg_map.vhd