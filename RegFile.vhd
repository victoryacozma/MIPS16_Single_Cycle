----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/09/2020 08:51:42 PM
-- Design Name: 
-- Module Name: RegFile - Behavioral
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

entity RegFile is
        Port ( clk : in STD_LOGIC;
           ra1 : in STD_LOGIC_VECTOR (2 downto 0);
           ra2 : in STD_LOGIC_VECTOR (2 downto 0);
           wa : in STD_LOGIC_VECTOR (2 downto 0);
           regWr : in STD_LOGIC;
           wd: in STD_LOGIC_VECTOR(15 downto 0);
           rd1: out STD_LOGIC_VECTOR (15 downto 0);
           rd2: out STD_LOGIC_VECTOR (15 downto 0));
end RegFile;

architecture Behavioral of RegFile is

type reg_type is array (0 to 15) of std_logic_vector (15 downto 0);
signal reg: reg_type := ( x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",x"0000", b"0101_0000_0000_0000",others =>X"0000");


begin

rd1 <= reg(conv_integer(ra1));
rd2 <= reg(conv_integer(ra2)); 

--process(clk, ra1, ra2, wa)
process(clk)
begin
if rising_edge(clk) then
    if RegWr = '1' then
         reg(conv_integer(wa)) <= wd;    
    end if;
end if;      
end process;

end Behavioral;
