library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity listctrl is
    port( 
		clk 		  : in  std_logic;
		reset 	  : in  std_logic;
      listnext   : in  std_logic;
      listprev   : in  std_logic;
      req 		  : out std_logic;
      gnt 		  : in  std_logic;
      busi 		  : out std_logic_vector (7 downto 0);
      busiv 	  : out std_logic;
      ctrl 		  : out  std_logic;
      busy 		  : in  std_logic;
      info_start : out std_logic;
      info_ready : in  std_logic);
end listctrl;

architecture listctrl_arch of listctrl is

type state_type is (idle, wrdy, winfo);
signal current_s, next_s: state_type;

begin

-- state registers and asynchronous reset
process (clk, reset)
	begin
		if 	(reset = '1') then
					current_s <= idle;  
		elsif (rising_edge(clk)) then
					current_s <= next_s;   
		end if;
end process;

--state machine process
process (current_s, listnext, listprev, gnt, busy, info_ready)
	begin
		case current_s is
			when idle =>
				if (listnext = '0' and listprev = '0') then
						req <= '0';
						busiv <= '0';
						ctrl <= '0';		-- ctrl is don't care
						info_start <= '0';
						next_s <= idle;
				else
						req <= '1';
						busiv <= '0';
						ctrl <= '0';		-- ctrl is don't care
						info_start <= '0';
						next_s <= wrdy;
				end if;
			when wrdy =>
				if (gnt = '1' and busy = '0') then
						req <= '1';
						busiv <= '1';
						ctrl <= '1';		
						info_start <= '1';
						next_s <= winfo;
				else
						req <= '1';
						busiv <= '0';
						ctrl <= '0';		-- ctrl is don't care
						info_start <= '0';
						next_s <= wrdy;
				end if;
			when winfo =>
				if (info_ready ='1') then
						req <= '0';
						busiv <= '0';
						ctrl <= '0';		-- ctrl is don't care
						info_start <= '0';
						next_s <= idle;
				else
						req <= '1';
						busiv <= '0';
						ctrl <= '-';
						info_start <= '0';
						next_s <= winfo;
				end if;
		end case;
end process;

process(current_s, listnext, listprev)
begin
		if 	(current_s = idle and listnext = '1') then
					busi <= x"00";
		elsif (current_s = idle and listprev = '1') then
					busi <= x"01";
		end if;
end process;
end listctrl_arch;

