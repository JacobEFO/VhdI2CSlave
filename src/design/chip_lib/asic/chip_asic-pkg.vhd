--###############################
--# Project Name : Placeholder_project_name
--# File         : chip_asic-pkd.vhd
--# Project      : Placeholder_project
--# Engineer     : Jacob E. F. Overgaard
--# Modification History
--#     2021-10-17: Creation date.
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

package comp_chip_asic is
	component chip_asic
		port(
			I2C_SDA     : inout std_logic;
			I2C_SCL     : inout std_logic;
			PORRSTN     : inout std_logic;
			GPIO0       : inout std_logic;
			SYS_CLK		: inout std_logic	-- This shall be removed at some point
		);
	end component;
	end package comp_chip_asic;