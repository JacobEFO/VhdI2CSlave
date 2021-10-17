--###############################
--# Project Name : Placeholder_project_name
--# File         : tb_i2cslave_write_reg_map.vhd
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

entity tb_i2cslave_write_reg_map is
end tb_i2cslave_write_reg_map;

architecture stimulus of tb_i2cslave_write_reg_map is

-- Components --
	component i2c_slave
		generic( DEVICE: std_logic_vector(7 downto 0));
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

	component reg_map
		port(
			reset_nai       : in std_logic;
			clk_i           : in std_logic;
			rdy_i           : in std_logic;
			address_i       : in std_logic_vector(7 downto 0);
			data_i          : in std_logic_vector(7 downto 0);
			gpio0_o         : out std_logic;
			soft_reset_no   : out std_logic
		);
	end component;

-- System signals
	signal sys_clk_s	: std_logic;
	signal rst_ns		: std_logic;
	signal sda_i_s		: std_logic;
	signal scl_i_s		: std_logic;
	signal sda_o_s		: std_logic;
	signal scl_o_s		: std_logic;
	signal address		: std_logic_vector(7 downto 0);
	signal data_out		: std_logic_vector(7 downto 0);
	signal data_in		: std_logic_vector(7 downto 0);
	signal wr_s			: std_logic;
	signal rd_s			: std_logic;
	signal packet_rdy_s	: std_logic;
	signal data_s		: std_logic_vector(7 downto 0);
	signal address_s	: std_logic_vector(7 downto 0);

	signal soft_reset_ns	: std_logic;
	signal gpio0_s			: std_logic;

-- Test-bench signals
	signal running	: std_logic := '1';				-- Simulation running flag
	signal content : std_logic_vector(7 downto 0);	-- Content to be transfered

-- Constants
	constant half_sys_period : time := 10 ns; -- 50 MHz frequency

begin
	-- Creates a 50 MHz system clock
	sys_clk_s <= not sys_clk_s after half_sys_period when running = '1' and rst_ns = '1' else '0';

-- PORT MAP --
	inst_i2c_slave : i2c_slave
		generic map (device => x"38")
		port map (
			clk_i			=> sys_clk_s,
			rst_nai			=> rst_ns,
			sda_i			=> sda_i_s,
			scl_i			=> scl_i_s,
			sda_o			=> sda_o_s,
			scl_o			=> scl_o_s,
			address			=> address,
			data_out		=> data_out,
			data_in			=> data_in,
			wr				=> wr_s,
			rd				=> rd_s,
			packet_rdy_o	=> packet_rdy_s,
			data_o			=> data_s,
			address_o		=> address_s
		);

	i_reg_map_o : reg_map
		port map (
			reset_nai       => rst_ns,
			clk_i           => sys_clk_s,
			rdy_i           => wr_s,
			address_i       => address_s,
			data_i          => data_s,
			gpio0_o         => gpio0_s,
			soft_reset_no   => soft_reset_ns
		);

	-- Creates a 50 MHz system clock
	-- sys_clk: process
	-- begin
	-- 	while (running = '1') loop
			-- sys_clk_s <= '1';
			-- wait for 10 ns;
			-- sys_clk_s <= '0';
			-- wait for 10 ns;
	-- 	end loop;
	-- 	wait;
	-- end process sys_clk;

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
		DATA_IN <= x"AA";
		wait for 1 ns;
		rst_ns <= '0';
		sda_i_s <= '1';
		scl_i_s <= '1';
		wait for 1000 ns;
		rst_ns <= '1';
		-- sda_i_s <= '0'; -- start
		start_cond;
		wait for 80 ns;
		send_data(x"70"); -- 38 < 1 + write
		send_data(x"55"); -- address
		send_data(x"11"); -- payload
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
		stop_cond;
		wait for 80 ns;
		running <= '0';
		wait;
	end process go;
	


end stimulus;
