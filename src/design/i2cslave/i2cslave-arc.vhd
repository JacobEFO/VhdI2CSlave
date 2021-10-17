--###############################
--# Project Name : Placeholder_project_name
--# File         : i2cslave-arc.vhd
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

architecture rtl of i2c_slave is

	type tstate is ( S_IDLE, S_START, S_SHIFTIN, S_RW, S_SENDACK, S_SENDACK2, S_SENDNACK,
		S_ADDRESS, S_WRITE, S_SHIFTOUT, S_READ, S_WAITACK
	);

	type toperation is (OP_READ, OP_WRITE);
	
	signal state					: tstate;
	signal next_state				: tstate;
	signal operation				: toperation;

	signal rising_scl, falling_scl	: std_logic;
	signal address_i				: std_logic_vector(7 downto 0);
	signal next_address				: std_logic_vector(7 downto 0);
	signal counter					: integer range 0 to 7;
	signal start_cond				: std_logic;
	signal stop_cond 				: std_logic;
	signal sda_q, sda_qq, sda_qqq	: std_logic;
	signal scl_q, scl_qq, scl_qqq	: std_logic;
	signal shiftreg					: std_logic_vector(7 downto 0);
	signal sda						: std_logic;
	signal address_incr				: std_logic;
	signal rd_d						: std_logic;

begin

	address <= address_i;
	
	next_address <= (others=>'0') when (address_i = x"FF") else
		std_logic_vector(to_unsigned(to_integer(unsigned( address_i )) + 1, 8));
	
	sys_rst: process(clk_i,rst_nai)
	begin
		if (rst_nai = '0') then
			sda_q <= '1';
			sda_qq <= '1';
			sda_qqq <= '1';
			scl_q <= '1';
			scl_qq <= '1';
			scl_qqq <= '1';
		elsif (clk_i'event and clk_i='1') then
			sda_q <= sda_i;
			sda_qq <= sda_q;
			sda_qqq <= sda_qq;
			scl_q <= scl_i;
			scl_qq <= scl_q;
			scl_qqq <= scl_qq;
		end if;
	end process sys_rst;

	rising_scl <= scl_qq and not scl_qqq;
	falling_scl <= not scl_qq and scl_qqq;
		
	start_bit: process(clk_i, rst_nai)
	begin
		if (rst_nai = '0') then
			start_cond <= '0';
		elsif (clk_i'event and clk_i='1') then
			if (sda_qqq = '1' and sda_qq = '0' and scl_qq = '1') then
				start_cond <= '1';
			else	
				start_cond <= '0';
			end if;
		end if;
	end process start_bit;
	
	stop_bit: process(clk_i, rst_nai)
	begin
		if (rst_nai = '0') then
			stop_cond <= '0';
		elsif (clk_i'event and clk_i = '1') then
			if (sda_qqq = '0' and sda_qq = '1' and scl_qq = '1') then
				stop_cond <= '1';
			else	
				stop_cond <= '0';
			end if;
		end if;
	end process stop_bit;
	
	sda <= sda_qq;
	
	rd_delay: process(clk_i, rst_nai)
	begin
		if (rst_nai = '0') then
			rd <= '0';
		elsif (clk_i'event and clk_i='1') then
			rd <= rd_d;
		end if;
	end process rd_delay;

	OTO: process(clk_i, rst_nai)
	begin
		if (rst_nai = '0') then
			state <= S_IDLE;
			sda_o <= '1';
			scl_o <= '1';
			wr <= '0';
			rd_d <= '0';
			address_i <= (others=>'0');
			data_out <= (others=>'0');
			shiftreg <= (others=>'0');
			data_o <= x"00";
			address_o <= x"00";
			packet_rdy_o <= '0';
			data_o <= x"00";
			address_o <= x"00";
		elsif (clk_i'event and clk_i='1') then
			if (stop_cond = '1') then
				state <= S_IDLE;
				sda_o <= '1';
				scl_o <= '1';
				operation <= OP_READ;
				wr <= '0';
				rd_d <= '0';
				address_incr <= '0';
			elsif(start_cond = '1') then
				state <= S_START;
				sda_o <= '1';
				scl_o <= '1';
				operation <= OP_READ;
				wr <= '0';
				rd_d <= '0';
				address_incr <= '0';
			elsif(state = S_IDLE) then
				state <= S_IDLE;
				sda_o <= '1';
				scl_o <= '1';
				operation <= OP_READ;
				wr <= '0';
				rd_d <= '0';
				address_incr <= '0';
				packet_rdy_o <= '0';
			elsif(state = S_START) then
				shiftreg <= (others=>'0');
				state <= S_SHIFTIN;
				next_state <= S_RW;
				counter <= 6;
			elsif(state = S_SHIFTIN) then
				if (rising_scl = '1') then
					shiftreg(7 downto 1) <= shiftreg(6 downto 0);
					shiftreg(0) <= sda;
					if (counter = 0) then
						state <= next_state;
						counter <= 7;
					else
						counter <= counter - 1;
					end if;
				end if;
			elsif(state = S_RW) then
				if (rising_scl = '1') then
					if (shiftreg = DEVICE) then
						state <= S_SENDACK;
						if (sda = '1') then
							operation <= OP_READ;
							rd_d <= '1';
						else
							operation <= OP_WRITE;
							next_state <= S_ADDRESS;
							address_incr <= '0';
						end if;
					else
						state <= S_SENDNACK;
					end if;
				end if;
			elsif(state = S_SENDACK) then
				wr <= '0';
				rd_d <= '0';
				if (falling_scl = '1') then
					sda_o <= '0';
					counter <= 7;
					if (operation= OP_WRITE) then
						state <= S_SENDACK2;
					else -- OP_READ
						state <= S_SHIFTOUT;
						shiftreg <= data_in;
					end if;
				end if;
			elsif(state = S_SENDACK2) then
				if (falling_scl = '1') then
					sda_o <= '1';
					state <= S_SHIFTIN;
					shiftreg <= (others=>'0');
					if (address_incr = '1') then
						address_i <= next_address;
					end if;
				end if;
			elsif(state = S_SENDNACK) then
				if (falling_scl = '1') then
					sda_o <= '1';
					state <= S_IDLE;
				end if;
			elsif(state = S_ADDRESS) then
				address_i <= shiftreg;
				address_o <= shiftreg;
				next_state <= S_WRITE;
				state <= S_SENDACK;
				address_incr <= '0';
			elsif(state = S_WRITE) then
				data_out <= shiftreg;
				data_o <= shiftreg;
				next_state <= S_IDLE;
				state <= S_SENDACK;
				packet_rdy_o <= '1';
				wr <= '1';
				address_incr <= '1';
			elsif(state = S_SHIFTOUT) then
				if (falling_scl = '1') then
					sda_o <= shiftreg(7);
					shiftreg(7 downto 1) <= shiftreg(6 downto 0);
					shiftreg(0) <= '1';
					if (counter = 0) then
						state <= S_READ;
						address_i <= next_address;
						rd_d <= '1';
					else
						counter <= counter - 1;
					end if;
				end if;
			elsif(state = S_READ) then
				rd_d <= '0';
				if (falling_scl = '1') then
					sda_o <= '1';
					state <= S_WAITACK;
				end if;
			elsif(state = S_WAITACK) then
				if (rising_scl = '1') then
					if (sda = '0') then
						state <= S_SHIFTOUT;
						counter <= 7;
						shiftreg <= data_in;
					else
						state <= S_IDLE;
					end if;
				end if;
			end if;
		end if;
	end process OTO;

end rtl;

