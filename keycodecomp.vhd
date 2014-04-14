library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity keycodecomp is
	port(
		rd			: out std_logic;
		rd_ack	: in 	std_logic;
		data		: in  std_logic_vector(7 downto 0);
		empty		: in  std_logic;
		listnext : out std_logic;
		listprev : out std_logic
		);
end keycodecomp;

architecture keycodecomp_arch of keycodecomp is

begin
main: process (rd_ack, data, empty)
	begin
		if    (data = x"72" and rd_ack = '1') then
					listnext <= '1';
					listprev <= '0';
					rd <= not empty;
		elsif (data = x"75" and rd_ack = '0') then
					listprev <= '1';
					listnext <= '0';
					rd <= not empty;
		else
					rd <= not empty;
					listnext <= '0';
					listprev <= '0';
		end if;		
	end process;
end keycodecomp_arch;

--TETST--TROLL--HAHAHA--
