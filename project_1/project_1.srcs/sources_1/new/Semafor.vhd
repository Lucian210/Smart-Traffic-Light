----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/18/2021 11:18:10 AM
-- Design Name: 
-- Module Name: Semafor - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 
use IEEE.std_logic_arith.all;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

--NR MASINI CARE TREC PRIN INTERSECTIE PE MINUT
--ca si intrare am 1 sau 0 la afiecare  intrare in intersectie

entity Semafor is
        Port ( 
              clk  : in STD_LOGIC;
              senzor_jud : std_logic := '0';
              senzor_nat : std_logic := '0';
              nationala: out STD_LOGIC_VECTOR(2 downto 0);
              judeteana: out STD_LOGIC_VECTOR(2 downto 0)  --001 verde 100 rosu 010 galben
        );
end Semafor;

architecture Behavioral of Semafor is

signal time : integer := 0;

--TIMER
signal countg, countr : integer := 0;
signal galben, galben_done: std_logic := '0'; --3
signal rosu, rosu_done: std_logic := '0'; --10

--stari
signal state: integer range 0 to 3;

begin

seq: process (galben_done, clk)
    begin   --default state
    if (senzor_jud = '0' and senzor_nat = '0') then
        if (galben_done = '1' or rosu_done ='1') and rising_edge(clk) and (state = 0) then
            state <= 2;
        elsif (galben_done = '1' or rosu_done ='1') and rising_edge(clk) and (state = 2) then 
            state <= 1;
        elsif (galben_done = '1' or rosu_done ='1') and rising_edge(clk) and (state = 1) then 
            state <= 3;
        elsif (galben_done = '1' or rosu_done ='1') and rising_edge(clk) and (state = 3) then 
            state <= 0;
        end if;
        
        
     elsif ((senzor_jud /= '0' or senzor_nat /= '0') or (senzor_jud /= '0' and senzor_nat /= '0')) then --cases  
        if(senzor_jud /= '0') then
            if rising_edge(clk) and (state = 0) then    
                state <= 0;
            elsif (galben_done = '1' or rosu_done ='1') and rising_edge(clk) and (state = 1) then 
                state <= 3;
            elsif (galben_done = '1' or rosu_done ='1') and rising_edge(clk) and (state = 3) then 
                state <= 0;
            elsif (galben_done = '1' or rosu_done ='1') and rising_edge(clk) and (state = 2) then 
                 state <= 1;
            end if;
         elsif(senzor_jud /= '0') then
            if rising_edge(clk) and (state = 1) then   
                state <= 1;
            elsif (galben_done = '1' or rosu_done ='1') and rising_edge(clk) and (state = 0) then 
                state <= 2;
            elsif (galben_done = '1' or rosu_done ='1') and rising_edge(clk) and (state = 2) then 
                state <= 1;
            elsif (galben_done = '1' or rosu_done ='1') and rising_edge(clk) and (state = 3) then 
                state <= 0;
            end if;
         end if;
     end if;
        
end process;

comb: process (state)
begin
    galben <= '0';
    rosu <= '0';
        case state is 
            when 0 =>
                nationala <= "100";
                judeteana <= "001";     --v jud r nat
                rosu <= '1';
            when 1 =>
               nationala <= "001";
               judeteana <= "100";     --r jud v nat
               rosu <= '1';           
            when 2 =>                 
               nationala <= "100";
               judeteana <= "010";     --g jud r nat
               galben <= '1';
            when 3 =>                   
               nationala <= "010";
               judeteana <= "100";     --r jud g nat
               galben <= '1';
 end case;
end process;





---timere
timer_galben: process(galben, rosu, clk)
    begin
        if galben = '1' then
            if rising_edge(clk) and countg <= 3 then
                countg <= (countg + 1) mod 4;
            end if;
        elsif (galben = '0') then
            countg <= 0;
        end if;
        
        if (countg >= 3) then      
            galben_done <= '1';
		elsif (countg = 0) then 
		    galben_done <= '0';
		end if;   
		
		
end process;

timer_rosu: process(rosu, clk)
    begin
        if rosu = '1' then
            if rising_edge(clk) and countr <= 10 then
                countr <= (countr + 1) mod 11;
            end if;
        elsif (rosu = '0') then
            countr <= 0;
        end if;
        
        if (countr >= 10) then      
            rosu_done <= '1';
		elsif (countr = 0) then 
		    rosu_done <= '0';
		end if;   
end process;



end Behavioral;
