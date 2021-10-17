--###############################
--# Project Name : Placeholder_project_name
--# File         : reg_map.vhd
--# Project      : Placeholder_project
--# Engineer     : Jacob E. F. Overgaard
--# Modification History
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

entity reg_map is
    port (
        reset_nai       : in std_logic;
        clk_i           : in std_logic;
        rdy_i           : in std_logic;
        address_i       : in std_logic_vector(7 downto 0);
        data_i          : in std_logic_vector(7 downto 0);
        gpio0_o         : out std_logic;
        soft_reset_no   : out std_logic
    );
end reg_map;
