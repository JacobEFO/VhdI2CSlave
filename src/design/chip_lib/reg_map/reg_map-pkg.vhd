--###############################
--# Project Name : Placeholder_project_name
--# File         : reg_map-pkg.vhd
--# Project      : Placeholder_project
--# Engineer     : Jacob E. F. Overgaard
--# Modification History
--#     2021-10-17:
--#         - Added port 'data_o' and 'reg_map_rd'.
--#         - Renamed port 'rdy_i' to 'reg_map_wr'.
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

package comp_reg_map is
    component reg_map
        port (
            rst_nai         : in    std_logic;
            clk_i           : in    std_logic;
            reg_map_wr      : in    std_logic;
            reg_map_rd      : in    std_logic;
            address_i       : in    std_logic_vector(7 downto 0);
            data_i          : in    std_logic_vector(7 downto 0);
            data_o          : out   std_logic_vector(7 downto 0);
            gpio0_o         : out   std_logic;
            soft_rst_o      : out   std_logic
        );
    end component;
end package comp_reg_map;