--###############################
--# Project Name : Placeholder_project_name
--# File         : tb_i2cslave_write
--# Project      : Placeholder_project
--# Engineer     : Jacob E. F. Overgaard
--# Modification History
--###############################

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_reg_map is
end tb_reg_map;

architecture stimulus of tb_reg_map is

	-- COMPONENTS --
	component reg_map
		port(
			reset_nai       : in std_logic;
			clk_i			: in std_logic;
			address_i       : in std_logic_vector(7 downto 0);
			data_i          : in std_logic_vector(7 downto 0);
			gpio0_o			: out std_logic;
			soft_reset_no   : out std_logic
		);
	end component;
	--

	-- SIGNALS --
	signal MCLK				: std_logic;
	signal reset_s			: std_logic;
	signal clk_s			: std_logic := '0';
	signal address_s		: std_logic_vector(7 downto 0);
	signal data_s			: std_logic_vector(7 downto 0);
	signal soft_reset_s		: std_logic;

	--
	signal RUNNING	: std_logic := '1';

	-- Constants
	constant half_packet_period : time := 25 us; -- 20 kHz

begin

	clk_s <= not clk_s after half_packet_period when reset_s = '1' else '0';

-- PORT MAP --
	i_reg_map_0 : reg_map
		port map (
			reset_nai			=> reset_s,
			clk_i				=> clk_s,
			address_i			=> address_s,
			data_i				=> data_s,
			soft_reset_no		=> soft_reset_s
		);

	-- Creates a 50 MHz clock
	CLOCK: process
	begin
		while (RUNNING = '1') loop
			MCLK <= '1';
			wait for 10 ns;
			MCLK <= '0';
			wait for 10 ns;
		end loop;
		wait;
	end process CLOCK;

	-- 16-bit packet received clock, 50 us period = 20 kHz
	-- packet_clock: process
	-- begin
		-- while (reset_s = '1') loop
			-- clk_s <= '1';
			-- wait for 25 us;
			-- clk_s <= '0';
			-- wait  for 25 us;
		-- end loop;
		-- wait;
	-- end process packet_clock;

	GO: process
	begin
		reset_s		<= '0';
		address_s	<= x"00";
		data_s		<= x"00";
		wait for 1 us;
		reset_s		<= '1';
		wait for 1 us;
		address_s	<= x"01";
		data_s		<= x"FF";
		wait for 50 us;
		address_s	<= x"01";
		data_s		<= x"00";
		wait for 50 us;
		address_s	<= x"01";
		data_s		<= x"FE";
		wait for 1 us;
		reset_s <= '0';
		RUNNING <= '0';
		wait;
	end process GO;

end stimulus;
