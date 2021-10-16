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

entity chip_asic is
    I2C_SDA     : in std_logic;
    I2C_SCL     : in std_logic;
    PORRSTN     : inout std_logic;
    GPIO0       : inout std_logic;

end chip_asic;

architecture rtl of chip_asic is:

    -- Signals for register map
    signal gpio0_s      : std_logic;
    signal reset_ns     : std_logic;
l

    -- Signals for I2C slave
	signal MCLK			: std_logic;
	--signal nRST			: std_logic; -- Use reset_s instead
	signal SDA_IN		: std_logic;
	signal SCL_IN		: std_logic;t
	signal SDA_OUT		: std_logic;
	signal SCL_OUT		: std_logic;
	signal ADDRESS		: std_logic_vector(7 downto 0);
	signal DATA_OUT		: std_logic_vector(7 downto 0);
	signal DATA_IN		: std_logic_vector(7 downto 0);
	signal WR			: std_logic;
	signal RD			: std_logic;

    component reg_map
        port(
            reset_nai       : in std_logic;
            clk_i           : in std_logic;
            address_i       : in std_logic_vector(7 downto 0);
            data_i          : in std_logic_vector(7 downto 0);
            gpio0_o         : out std_logic;
            soft_reset_no   : out std_logic
        );
    end component;

	component I2CSLAVE
		generic( DEVICE: std_logic_vector(7 downto 0));
		port(
			MCLK		: in	std_logic;
			nRST		: in	std_logic;
			SDA_IN		: in	std_logic;
			SCL_IN		: in	std_logic;
			SDA_OUT		: out	std_logic;
			SCL_OUT		: out	std_logic;
			ADDRESS		: out	std_logic_vector(7 downto 0);
			DATA_OUT	: out	std_logic_vector(7 downto 0);
			DATA_IN		: in	std_logic_vector(7 downto 0);
			WR			: out	std_logic;
			RD			: out	std_logic
		);
	end component;

begin

end rtl;