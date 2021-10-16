--###############################
--# Project Name : Placeholder_project_name
--# File         : i2cslave-ent.vhd
--# Project      : Placeholder_project
--# Engineer     : Jacob E. F. Overgaard
--# Modification History
--#		2021-10-15: Reformatted and changed ownership to Jacob E. F. Overgaard
--#			Originally developed by Philipe Thirion.
--###############################


--	copyright Philippe Thirion
--	github.com/tirfil
--
--    Copyright 2016 Philippe THIRION
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

entity I2CSLAVE is
	generic(
		DEVICE 		: std_logic_vector(7 downto 0) := x"38"
	);
	port(
		MCLK			: in	std_logic;
		nRST			: in	std_logic;
		SDA_IN			: in	std_logic;
		SCL_IN			: in	std_logic;
		SDA_OUT			: out	std_logic;
		SCL_OUT			: out	std_logic;
		ADDRESS			: out	std_logic_vector(7 downto 0);
		DATA_OUT		: out	std_logic_vector(7 downto 0);
		DATA_IN			: in	std_logic_vector(7 downto 0);
		WR				: out	std_logic;
		RD				: out	std_logic;
		packet_rdy_o	: out	std_logic;
		data_o			: out	std_logic_vector(7 downto 0);
		address_o		: out	std_logic_vector(7 downto 0)
	);
end I2CSLAVE;