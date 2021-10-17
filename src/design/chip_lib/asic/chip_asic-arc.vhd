--###############################
--# Project Name : Placeholder_project_name
--# File         : chip_asic-arc.vhd
--# Project      : Placeholder_project
--# Engineer     : Jacob E. F. Overgaard
--# Modification History
--#		2021-10-17: 
--#			- Renamed file to 'chip_asic-arc.vhd'.
--#			- Updates signals and instances for including I2C slave and 
--#			  reg map.
--#     2021-10-15: Creation date.
--###############################

--    Copyright 2021 Jacob E. F. Overgaard
--
--    This program is free software: you can redistribute it and/or modify
--    it under the terms of the GNU General Public License as published by
--    the Free Software Foundation, either version 3 of the License, or
--    (at your option) any later version.

--    This program is distributed in the hope that it will be useful,
--    but WITHOUT ANY WARRANTY; without even the implied warranty of
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--    GNU General Public License for more details.

--    You should have received a copy of the GNU General Public License
--    along with this program.  If not, see <http://www.gnu.org/licenses/>.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library chip_lib;
use chip_lib.comp_i2c_slave.i2c_slave;
use chip_lib.comp_reg_map.reg_map;

entity chip_asic is
	port(
		I2C_SDA     : in std_logic;
		I2C_SCL     : in std_logic;
		PORRSTN     : in std_logic;
		GPIO0       : out std_logic;
		SYS_CLK		: in std_logic	-- This shall be removed at some point
	);
end chip_asic;

architecture rtl of chip_asic is
-- Signals for full chip
	signal sys_clk_s		: std_logic; -- 50 MHz clock signal
	signal rst_ns			: std_logic;

-- Signals for register map
    signal gpio0_s      	: std_logic;
    signal soft_rst_s		: std_logic;

-- Signals for I2C slave
	signal scl_s			: std_logic;
	signal sda_s			: std_logic;
	signal sda_o_s			: std_logic;
	signal scl_o_s			: std_logic;
	signal i2c_wr_s			: std_logic;
	signal i2c_rd_s			: std_logic;
	signal i2c_data_o_s		: std_logic_vector(7 downto 0);
	signal i2c_address_s	: std_logic_vector(7 downto 0);

	-- These need an update
	signal address			: std_logic_vector(7 downto 0);
	signal data_in			: std_logic_vector(7 downto 0);

begin
-- Map chip-pins to internal signals
	rst_ns <= PORRSTN;
	GPIO0 <= gpio0_s;
	scl_s <= I2C_SCL;
	sda_s <= I2C_SDA;

	sys_clk_s <= SYS_CLK; -- This needs a remap at some point.

-- inst_i2c_slave: I2C Slave
	inst_i2c_slave : i2c_slave
		generic map (device => x"38")
		port map (
			clk_i			=> sys_clk_s,
			rst_nai			=> rst_ns,
			sda_i			=> sda_s,
			scl_i			=> scl_s,
			sda_o			=> sda_o_s,
			scl_o			=> scl_o_s,
			address			=> address,
			data_in			=> data_in,
			wr				=> i2c_wr_s,
			rd				=> i2c_rd_s,
			data_o			=> i2c_data_o_s,
			address_o		=> i2c_address_s
		);

-- inst_reg_map: Register Map
	inst_reg_map_o : reg_map
		port map (
			rst_nai       	=> rst_ns,
			clk_i           => sys_clk_s,
			rdy_i           => i2c_wr_s,
			address_i       => i2c_address_s,
			data_i          => i2c_data_o_s,
			gpio0_o         => gpio0_s,
			soft_rst_o   	=> soft_rst_s
		);
end rtl;