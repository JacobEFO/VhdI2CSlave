set FLAG=-v -Pwork --syn-binding --ieee=synopsys --std=93c -fexplicit

ghdl -a --work=chip_lib --workdir=..\obj %FLAG% ..\src\design\chip_lib\i2cslave\i2cslave-arc.vhd
ghdl -a --work=chip_lib --workdir=..\obj %FLAG% ..\src\design\chip_lib\i2cslave\i2cslave-pkg.vhd
ghdl -a --work=chip_lib --workdir=..\obj %FLAG% ..\src\design\chip_lib\reg_map\reg_map-arc.vhd
ghdl -a --work=chip_lib --workdir=..\obj %FLAG% ..\src\design\chip_lib\reg_map\reg_map-pkg.vhd
ghdl -a --work=chip_lib --workdir=..\obj %FLAG% ..\src\design\chip_lib\asic\chip_asic-arc.vhd
ghdl -a --work=chip_lib --workdir=..\obj %FLAG% ..\src\design\chip_lib\asic\chip_asic-pkg.vhd
ghdl -a --work=chip_lib --workdir=..\obj %FLAG% ..\src\verification\tb_i2cslave_write_reg_map.vhd
ghdl -a --work=chip_lib --workdir=..\obj %FLAG% ..\src\verification\asic\tb_asic_wr.vhd
@REM ghdl -a --work=obj --workdir=..\obj %FLAG% ..\src\verification\tb_i2cslave_read_reg_map.vhd