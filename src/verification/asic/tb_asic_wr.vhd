--###############################
--# Project Name : Placeholder_project_name
--# File         : tb_asic_wr.vhd
--# Project      : Placeholder_project
--# Engineer     : Jacob E. F. Overgaard
--# Modification History
--#		2021-10-17: Created.
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

library chip_lib;
use chip_lib.comp_chip_asic.chip_asic;

entity tb_asic_wr is
end tb_asic_wr;

architecture stimulus of tb_asic_wr is

-- System signals
	signal sys_clk_s		: std_logic;
	signal rst_ns			: std_logic;
	signal sda_i_s			: std_logic;
	signal scl_i_s			: std_logic;

	signal gpio0_s			: std_logic;

-- Test-bench signals
	signal running			: std_logic := '1';				-- Simulation running flag
	signal content			: std_logic_vector(7 downto 0);	-- Content to be transfered

-- Constants
	constant half_sys_period : time := 10 ns; -- 50 MHz frequency

begin
	-- Creates a 50 MHz system clock
	sys_clk_s <= not sys_clk_s after half_sys_period when running = '1' and rst_ns = '1' else '0';

-- PORT MAP --
	inst_chip_asic : chip_asic
		port map (
			I2C_SDA     => sda_i_s,
			I2C_SCL     => scl_i_s,
			PORRSTN     => rst_ns,
			GPIO0       => gpio0_s,
			SYS_CLK		=> sys_clk_s	-- This shall be removed at some point
		);

	go: process
		procedure send_data(data : in std_logic_vector(7 downto 0)) is
			variable d : std_logic_vector(7 downto 0);
		begin
			d := data;
			content <= data;
			scl_i_s <= '0';
			for i in 0 to 7 loop
				sda_i_s <= d(7);
				wait for 80 ns;
				scl_i_s <= '1';
				wait for 80 ns;
				scl_i_s <= '0';
				wait for 80 ns;
				d(7 downto 1) := d(6 downto 0);
			end loop;
			sda_i_s <= '1';
			wait for 80 ns;
			scl_i_s <= '1';
			wait for 80 ns;
			scl_i_s <= '0';
			wait for 80 ns;	
		end send_data;
		procedure start_cond is
		begin
			sda_i_s <= '0';
			wait for 80 ns;
		end start_cond;
		procedure stop_cond is
		begin
			sda_i_s <= '0';
			wait for 80 ns;
			scl_i_s <= '1';
			wait for 80 ns;
			sda_i_s <= '1'; -- stop
		end stop_cond;
	begin
		rst_ns <= '0';
		sda_i_s <= '1';
		scl_i_s <= '1';
		wait for 1000 ns;
		rst_ns <= '1';
		start_cond;
		send_data(x"70"); -- 38 < 1 + write
		send_data(x"02"); -- address
		send_data(x"FF"); -- payload
		stop_cond;
		wait for 10 us;
		start_cond;
		send_data(x"70"); -- 38 < 1 + write
		send_data(x"01"); -- address
		send_data(x"FF"); -- payload
		stop_cond;
		wait for 10 us;
		start_cond;
		send_data(x"22");
		send_data(x"01");
		send_data(x"00");
		stop_cond;
		wait for 80 ns;
		running <= '0';
		wait;
	end process go;
end stimulus;
