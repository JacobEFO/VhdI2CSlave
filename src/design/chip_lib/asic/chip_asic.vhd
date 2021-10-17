--###############################
--# Project Name : Placeholder_project_name
--# File         : asic.vhd
--# Project      : Placeholder_project
--# Engineer     : Jacob E. F. Overgaard
--# Modification History
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

library obj;
use obj.comp_i2c_slave.i2c_slave;

entity chip_asic is
	port(
		I2C_SDA     : inout std_logic;
		I2C_SCL     : inout std_logic;
		PORRSTN     : inout std_logic;
		GPIO0       : inout std_logic
	);
end chip_asic;

architecture rtl of chip_asic is
-- Signals for full chip
	signal sys_clk_s	: std_logic;
	signal reset_ns		: std_logic;

-- Signals for register map
    signal gpio0_s      : std_logic;
    signal reset_ns     : std_logic;

-- Signals for I2C slave
	signal scl_s		: std_logic;
	signal sda_s		: std_logic;
	signal sda_o_s		: std_logic;
	signal scl_o_s		: std_logic;
	signal i2c_wr_s		: std_logic;
	signal i2c_rd_s		: std_logic;

	-- These need an update
	signal address		: std_logic_vector(7 downto 0);
	signal data_out		: std_logic_vector(7 downto 0);
	signal data_in		: std_logic_vector(7 downto 0);


begin
-- Map chip-pins to internal signals
	reset_ns <= PORRSTN;

	scl_s <= I2C_SCL;
	sda_s <= I2C_SDA;

end rtl;