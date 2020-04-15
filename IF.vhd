----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/23/2020 02:44:46 PM
-- Design Name: 
-- Module Name: IF - Behavioral
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

entity Instr_Fetch is
    Port ( we: in std_logic;
            clk : in STD_LOGIC;
           clear: in STD_LOGIC;
           jump_control : in STD_LOGIC;
           pc_src : in STD_LOGIC;
           jump_adr : in STD_LOGIC_VECTOR (15 downto 0);
           branch_adr : in STD_LOGIC_VECTOR (15 downto 0);
           instr_curenta : out STD_LOGIC_VECTOR (15 downto 0);
           next_address : out STD_LOGIC_VECTOR (15 downto 0));
           
end Instr_Fetch;

architecture Behavioral of Instr_Fetch is
type rom_type is array (0 to 255) of std_logic_vector (15 downto 0);
signal rom: rom_type :=(
X"0000", --noop
b"010_000_001_0000000", --lw $1 <= RAM($0)
b"110_001_011_0000000", --mod $1 $3
b"101_001_110_0000000", --div $1 $1
b"000_110_000_001_0_000",--vreau sa vad valoarea reg1
b"000_100_011_110_0_000", --add $4 $3 $4 adun in aux
b"000_110_000_100_0_000", 
b"100_001_000_0001001", --beq $1 $0 &7
b"111_0000000000010", --jmp &2
b"000_111_100_101_0_000", -- add $7 $4 $5 (concateman cu 5 ca sa afisam litera S-suma) 
b"111_0000000000000",--jmp &0

X"0005",X"0004",X"0003",X"0002",X"0001",others =>X"0000");

signal pc: STD_LOGIC_VECTOR(15 downto 0) := x"0000";
signal adresa: STD_LOGIC_VECTOR(15 downto 0):= "0000000000000000";
signal adresa_urmatoare: STD_LOGIC_VECTOR(15 downto 0);
signal iesire_mux1: STD_LOGIC_VECTOR(15 downto 0);
begin

--implementam pc-ul
process(clk, clear,we)
begin
if (clear = '1') then
    pc <= X"0000";
else   
if (rising_edge(clk) and we = '1') then
        pc <= adresa;
     end if;
     end if;
end process;


instr_curenta <= rom(conv_integer(pc));
adresa_urmatoare <= pc + 1;
next_address <= adresa_urmatoare;

process(pc_src, adresa_urmatoare, branch_adr)
begin
    if(pc_src = '0') then
        iesire_mux1 <= adresa_urmatoare;
    else
        iesire_mux1 <= branch_adr;
    end if;
end process;

process(jump_control, iesire_mux1, jump_adr)
begin
    if(jump_control = '0') then
        adresa <= iesire_mux1;
    else
        adresa <= jump_adr;
    end if;
end process;

end Behavioral;
