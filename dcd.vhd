----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/27/2020 05:41:08 PM
-- Design Name: 
-- Module Name: dcd - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dcd is
    Port ( clk : in STD_LOGIC;
           input : in STD_LOGIC_VECTOR (3 downto 0);
           output : out STD_LOGIC_VECTOR (15 downto 0));
end dcd;

architecture Behavioral of dcd is

begin
    process(input)
        begin
        case input is
            when "0000" => output <= "0000000000000001";
            when "0001" => output <= "0000000000000010";
            when "0010" => output <= "0000000000000100";
            when "0011" => output <= "0000000000001000";
            when "0100" => output <= "0000000000010000";
            when "0101" => output <= "0000000000100000";
            when "0110" => output <= "0000000001000000";
            when "0111" => output <= "0000000010000000";
            when "1000" => output <= "0000000100000000";
            when "1001" => output <= "0000001000000000";
            when "1010" => output <= "0000010000000000";
            when "1011" => output <= "0000100000000000";
            when "1100" => output <= "0001000000000000";
            when "1101" => output <= "0010000000000000";
            when "1110" => output <= "0100000000000000";
            when others => output <= "1000000000000000";
end case;
end process;

end Behavioral;
