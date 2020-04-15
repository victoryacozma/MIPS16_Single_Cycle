----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/30/2020 03:12:57 PM
-- Design Name: 
-- Module Name: ID - Behavioral
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

entity ID is
    Port ( clk : in STD_LOGIC;
           Instr : in STD_LOGIC_VECTOR (15 downto 0);
           Wdata : in STD_LOGIC_VECTOR (15 downto 0);
           RegWrite : in STD_LOGIC;
           RegDst : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR (15 downto 0);
           RD2 : out STD_LOGIC_VECTOR (15 downto 0);
           Ext_Imm : out STD_LOGIC_VECTOR (15 downto 0);
           Funct : out STD_LOGIC_VECTOR (2 downto 0);
           sa : out STD_LOGIC);
end ID;

architecture Behavioral of ID is

component RegFile is
        Port ( clk : in STD_LOGIC;
           ra1 : in STD_LOGIC_VECTOR (2 downto 0);
           ra2 : in STD_LOGIC_VECTOR (2 downto 0);
           wa : in STD_LOGIC_VECTOR (2 downto 0);
           regWr : in STD_LOGIC;
           wd: in STD_LOGIC_VECTOR(15 downto 0);
           rd1: out STD_LOGIC_VECTOR (15 downto 0);
           rd2: out STD_LOGIC_VECTOR (15 downto 0));
end component;

signal iesireMux : STD_LOGIC_VECTOR(2 downto 0);
signal ra1: std_logic_vector(3 downto 0);
signal ra2: std_logic_vector(3 downto 0);
type reg_type is array (0 to 15) of std_logic_vector (15 downto 0);
signal reg: reg_type := (x"0009", x"0008", x"0007", x"0006", x"0005", x"0004", x"0003", x"0002", x"0001", others =>X"0007");

begin

RF1: RegFile port map(clk, Instr(12 downto 10), Instr(9 downto 7), iesireMux, RegWrite, Wdata, rd1, rd2);

process(ExtOp, Instr)
begin
if(ExtOp = '0')
    then Ext_Imm <= "000000000" & Instr(6 downto 0);
else     
    Ext_Imm <= "111111111" & Instr(6 downto 0);
end if;    
end process;

process(RegDst)
begin
case(RegDst) is
    when '0' => iesireMux <= Instr(9 downto 7);
    when '1' => iesireMux <= Instr(6 downto 4);
end case;
end process;

 funct <= Instr(2 downto 0);
 sa <= Instr(3);

end Behavioral;
