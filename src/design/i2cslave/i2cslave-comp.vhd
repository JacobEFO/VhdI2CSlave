--###############################
--# Project Name : Placeholder_project_name
--# File         : i2cslave-comp.vhd
--# Project      : Placeholder_project
--# Engineer     : Jacob E. F. Overgaard
--# Modification History
--#		2021-10-16: Created.
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

component i2c_slave
	generic( device: std_logic_vector(7 downto 0));
	port(
		clk_i			: in	std_logic;
		rst_nai			: in	std_logic;
		sda_i			: in	std_logic;
		scl_i			: in	std_logic;
		sda_o			: out	std_logic;
		scl_o			: out	std_logic;
		address			: out	std_logic_vector(7 downto 0);	-- No idea what this is for
		data_out		: out	std_logic_vector(7 downto 0);	-- No idea what this is for
		data_in			: in	std_logic_vector(7 downto 0);	-- No idae what this is for
		wr				: out	std_logic;
		rd				: out	std_logic;
		packet_rdy_o	: out	std_logic;
		data_o			: out	std_logic_vector(7 downto 0);
		address_o		: out	std_logic_vector(7 downto 0)
	);
end component;