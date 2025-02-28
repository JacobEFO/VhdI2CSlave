--###############################
--# Project Name : Placeholder_project_name
--# File         : tb_i2cslave_read_reg_map.vhd
--# Project      : Placeholder_project
--# Engineer     : Jacob E. F. Overgaard
--# Modification History
--###############################

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_i2cslave_read_reg_map is
end tb_i2cslave_read_reg_map;

architecture stimulus of tb_i2cslave_read_reg_map is

-- COMPONENTS --
	component I2CSLAVE
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

--
-- SIGNALS --
	signal MCLK			: std_logic;
	signal nRST			: std_logic;
	signal SDA_IN		: std_logic;
	signal SCL_IN		: std_logic;
	signal SDA_OUT		: std_logic;
	signal SCL_OUT		: std_logic;
	signal ADDRESS		: std_logic_vector(7 downto 0);
	signal DATA_OUT		: std_logic_vector(7 downto 0);
	signal DATA_IN		: std_logic_vector(7 downto 0);
	signal WR			: std_logic;
	signal RD			: std_logic;
	signal packet_rdy_s	: std_logic;
	signal data_s		: std_logic_vector(7 downto 0);
	signal address_s	: std_logic_vector(7 downto 0);

	signal soft_reset_ns	: std_logic;
	signal gpio0_s			: std_logic;
--
	signal RUNNING	: std_logic := '1';
	signal result	: std_logic_vector(7 downto 0);
	signal content : std_logic_vector(7 downto 0);

begin

-- PORT MAP --
	I_I2CSLAVE_0 : I2CSLAVE
		port map (
			MCLK			=> MCLK,
			nRST			=> nRST,
			SDA_IN			=> SDA_IN,
			SCL_IN			=> SCL_IN,
			SDA_OUT			=> SDA_OUT,
			SCL_OUT			=> SCL_OUT,
			ADDRESS			=> ADDRESS,
			DATA_OUT		=> DATA_OUT,
			DATA_IN			=> DATA_IN,
			WR				=> WR,
			RD				=> RD,
			packet_rdy_o	=> packet_rdy_s,
			data_o			=> data_s,
			address_o		=> address_s
		);

	i_reg_map_o : reg_map
		port map (
			reset_nai       => nRST,
			clk_i           => MCLK,
			rdy_i           => WR,
			address_i       => address_s,
			data_i          => data_s,
			gpio0_o         => gpio0_s,
			soft_reset_no   => soft_reset_ns
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

	GO: process
		procedure SendData(data : in std_logic_vector(7 downto 0)) is
			variable d : std_logic_vector(7 downto 0);
		begin
			d := data;
			content <= data;
			SCL_IN <= '0';
			for i in 0 to 7 loop
				SDA_IN <= d(7);
				wait for 80 ns;
				SCL_IN <= '1';
				wait for 80 ns;
				SCL_IN <= '0';
				d(7 downto 1) := d(6 downto 0);
				wait for 80 ns;
			end loop;
			SDA_IN <= '1';
			wait for 80 ns;
			SCL_IN <= '1';
			wait for 80 ns;
			SCL_IN <= '0';
			wait for 80 ns;	
		end SendData;
		procedure ReadData(nack: in std_logic)  is
			variable d: std_logic_vector(7 downto 0);
		begin
			SCL_IN <= '0';
			for i in 0 to 7 loop
				d(7 downto 1) := d(6 downto 0); 
				wait for 80 ns;
				SCL_IN <= '1';
				d(0) := SDA_OUT;
				wait for 80 ns;
				SCL_IN <= '0';
				wait for 80 ns;
			end loop;
			SDA_IN <= nack;
			result <= d;
			wait for 80 ns;
			SCL_IN <= '1';
			wait for 80 ns;
			SCL_IN <= '0';
			wait for 80 ns;
			SDA_IN <= '1';
		end ReadData;
		procedure start_cond is
		begin
			SDA_IN <= '0';
			wait for 80 ns;
		end start_cond;
		procedure end_cond is
		begin
			SDA_IN <= '0';
			wait for 80 ns;
			SCL_IN <= '1';
			wait for 80 ns;
			SDA_IN <= '1'; -- stop
		end end_cond;
	begin
		result <= x"FF";
		wait for 1 ns;
		nRST <= '0';
		SDA_IN <= '1';
		SCL_IN <= '1';
		wait for 1000 ns;
		nRST <= '1';
		wait for 80 ns;
		start_cond;
		SendData(x"70"); -- 38 < 1 + write
		SendData(x"01"); -- address
		SendData(x"55"); -- address
		SDA_IN <= '1';
		wait for 80 ns;
		SCL_IN <= '1';
		wait for 80 ns;
		start_cond;
		SendData(x"71"); -- 38 < 1 + read
		ReadData('0'); -- ack
		ReadData('0'); -- ack
		ReadData('1'); -- nack
		SCL_IN <= '1';
		wait for 80 ns;
		SDA_IN <= '1'; -- stop
		wait for 80 ns;
		RUNNING <= '0';
		wait;
	end process GO;
	
	P_READ: process
	begin
		wait for 100 ns;
		DATA_IN <= x"FF";
		wait until RD'event and RD='0';
		DATA_IN <= x"66";
		wait until RD'event and RD='0';
		DATA_IN <= x"77";
		wait until RD'event and RD='0';
		DATA_IN <= x"88";
		wait;
	end process P_READ;
	
end stimulus;
