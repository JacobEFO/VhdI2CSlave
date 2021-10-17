--###############################
--# Project Name : Placeholder_project_name
--# File         : reg_map-ent.vhd
--# Project      : Placeholder_project
--# Engineer     : Jacob E. F. Overgaard
--# Modification History
--#		2021-10-17: Moved entity into architecture file. Having three files
--#			for each module is obsesive and cluttering.
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
        rst_nai         : in std_logic;
        clk_i           : in std_logic;
        rdy_i           : in std_logic;
        address_i       : in std_logic_vector(7 downto 0);
        data_i          : in std_logic_vector(7 downto 0);
        gpio0_o         : out std_logic;
        soft_rst_o     : out std_logic
    );
end reg_map;

-- Chip register map
    -- 0x00: NOP
    -- 0x01: SOFT_RESET
    -- 0x02: GPIO0_CTRL

architecture rtl of reg_map is
    -- Creates the register signals.
    signal soft_reset   : std_logic_vector(7 downto 0);
    signal gpio0_ctrl   : std_logic_vector(7 downto 0);

    -- Dummy variable for stupid case statement
    signal dummy : std_logic;

begin
    main: process(clk_i, rst_nai)
    begin
        if (rst_nai = '0') then
            dummy           <= '0';
            soft_reset      <= x"00";
            gpio0_ctrl      <= x"00";
        end if;

        if (falling_edge(clk_i)) then
            if rdy_i = '1' then
                case address_i is
                    when x"01"      => soft_reset <= data_i;
                    when x"02"      => gpio0_ctrl <= data_i;
                    when others     => dummy <= '0';
                end case;
            end if;
        end if;
    end process;

    -- 0x01: SOFT_RESET
    soft_rst_o   <= soft_reset(0);

    -- 0x02: GPIO0_CTRL
    gpio0_o         <= gpio0_ctrl(0);

end rtl;
