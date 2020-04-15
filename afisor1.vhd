----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/02/2020 02:20:46 PM
-- Design Name: 
-- Module Name: afisor - Behavioral
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
use IEEE.STD_LOGIC_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity afisor is
    Port ( clk : in STD_LOGIC;
           dig1 : in STD_LOGIC_VECTOR (3 downto 0);
           dig2 : in STD_LOGIC_VECTOR (3 downto 0);
           dig3 : in STD_LOGIC_VECTOR (3 downto 0);
           dig4 : in STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end afisor;

architecture Behavioral of afisor is
signal cnt : std_logic_vector(15 downto 0) := "0000000000000000";
signal S: std_logic_vector(1 downto 0) := "00";
signal out1 : std_logic_vector(3 downto 0);
--signal out2 : std_logic_vector(3 downto 0);
begin

process(clk)
begin
 if rising_edge(clk) then
 cnt <= cnt + 1;
 end if;
end process;

S <= cnt(15 downto 14); 

process(S, dig1, dig2, dig3, dig4)
begin
 case S is
 when "00" => out1 <= dig1;
 when "01" => out1 <= dig2;
 when "10" => out1 <= dig3;
 when others => out1 <= dig4;
 end case;
end process;


process(clk,out1)
begin
case out1 is
    when x"0000" => cat <= "0000001";
    when x"0001" =>  cat <= "1001111"; -- "1" 
    when x"0002" => cat <= "0010010"; -- "2" 
    when x"0003" =>  cat <= "0000110"; -- "3" 
    when x"0004" =>  cat <= "1001100"; -- "4" 
    when x"0005" => cat <= "0100100"; -- "5" 
    when x"0006" =>  cat <= "0100000"; -- "6" 
    when x"0007" => cat <= "0001111"; -- "7" 
    when x"0008" =>  cat <= "0000000"; -- "8"     
    when x"0009" =>  cat <= "0000100"; -- "9" 
    when "1010" => cat <= "0000010"; -- a
    when "1011" => cat <= "1100000"; -- b
    when "1100" => cat <= "0110001"; -- C
    when "1101" => cat <= "1000010"; -- d
    when "1110" => cat <= "0110000"; -- E
    when "1111" => cat <= "0111000"; -- F
end case;    
end process;


process(S)
begin
 case S is
 when "00" => an <= "0111";
 when "01" => an <= "1011";
 when "10" => an <= "1101";
 when others => an <= "1110";
 end case;
end process;

end Behavioral;
