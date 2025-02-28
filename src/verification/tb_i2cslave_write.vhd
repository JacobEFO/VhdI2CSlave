--###############################
--# Project Name : Placeholder_project_name
--# File         : tb_i2cslave_write.vhd
--# Project      : Placeholder_project
--# Engineer     : Jacob E. F. Overgaard
--# Modification History
--###############################

library IEEE;
use IEEE.std_logic_1164.all;

entity TB_I2CSLAVE_WRITE is
end TB_I2CSLAVE_WRITE;

architecture stimulus of TB_I2CSLAVE_WRITE is

-- COMPONENTS --
	component i2c_slave 
		generic( device: std_logic_vector(7 downto 0));
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

--
	signal RUNNING	: std_logic := '1';
	signal content : std_logic_vector(7 downto 0);

begin

-- PORT MAP --
	i_i2c_slave_0 : i2c_slave
		generic map (DEVICE => x"38")
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
				wait for 80 ns;
				d(7 downto 1) := d(6 downto 0);
			end loop;
			SDA_IN <= '1';
			wait for 80 ns;
			SCL_IN <= '1';
			wait for 80 ns;
			SCL_IN <= '0';
			wait for 80 ns;	
		end SendData;
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
		DATA_IN <= x"AA";
		wait for 1 ns;
		nRST <= '0';
		SDA_IN <= '1';
		SCL_IN <= '1';
		wait for 1000 ns;
		nRST <= '1';
		-- SDA_IN <= '0'; -- start
		start_cond;
		wait for 80 ns;
		SendData(x"70"); -- 38 < 1 + write
		SendData(x"55"); -- address
		SendData(x"11"); -- payload
		end_cond;
		wait for 10 us;
		start_cond;
		SendData(x"70"); -- 38 < 1 + write
		SendData(x"01"); -- address
		SendData(x"FF"); -- payload
		end_cond;
		wait for 10 us;
		start_cond;
		SendData(x"22");
		end_cond;
		wait for 80 ns;
		RUNNING <= '0';
		wait;
	end process GO;
	


end stimulus;
