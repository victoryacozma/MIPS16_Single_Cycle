
----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 02/24/2020 02:47:16 PM
-- Design Name:
-- Module Name: test_env - Behavioral
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

entity test_env is
Port ( clk : in STD_LOGIC;
btn : in STD_LOGIC_VECTOR (4 downto 0);
sw : in STD_LOGIC_VECTOR (15 downto 0);
led : out STD_LOGIC_VECTOR (15 downto 0);
an : out STD_LOGIC_VECTOR (3 downto 0);
cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is

component mpg is
Port ( btn : in STD_LOGIC;
clk : in STD_LOGIC;
en : out STD_LOGIC);
end component;


component afisor is
    Port ( clk : in STD_LOGIC;
           dig1 : in STD_LOGIC_VECTOR (3 downto 0);
           dig2 : in STD_LOGIC_VECTOR (3 downto 0);
           dig3 : in STD_LOGIC_VECTOR (3 downto 0);
           dig4 : in STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end component;

component Instr_Fetch is
    Port ( we: in std_logic;
            clk : in STD_LOGIC;
           clear: in STD_LOGIC;
           jump_control : in STD_LOGIC;
           pc_src : in STD_LOGIC;
           jump_adr : in STD_LOGIC_VECTOR (15 downto 0);
           branch_adr : in STD_LOGIC_VECTOR (15 downto 0);
           instr_curenta : out STD_LOGIC_VECTOR (15 downto 0);
           next_address : out STD_LOGIC_VECTOR (15 downto 0));
           
end component;

component ID is
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
end component;


component EX is
    Port ( nextAdr : in STD_LOGIC_VECTOR (15 downto 0);
           RD1 : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           Ext_Imm : in STD_LOGIC_VECTOR (15 downto 0);
           funct : in STD_LOGIC_VECTOR (2 downto 0);
           sa : in STD_LOGIC;
           AluSrc : in STD_LOGIC;
           AluOp : in STD_LOGIC_VECTOR (2 downto 0);
           AluRes : out STD_LOGIC_VECTOR (15 downto 0);
           BranchAddr: out STD_LOGIC_VECTOR(15 downto 0);
           ZeroFlag : out STD_LOGIC;
           Equal : out STD_LOGIC_VECTOR(3 downto 0));
end component;

component MEM is
    Port ( clk : in STD_LOGIC;
           AluResIn : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           MemWrite : in STD_LOGIC;
           MemWriteCtrl : in STD_LOGIC;
           MemData : out STD_LOGIC_VECTOR (15 downto 0);
           AluResOut : out STD_LOGIC_VECTOR (15 downto 0));
end component;

signal we, reset_pc, enable_pc: std_logic;
signal af : std_logic_vector(15 downto 0);
signal iesireIF1 : std_logic_vector(15 downto 0);
signal iesireIF2 : std_logic_vector(15 downto 0);
signal iesire_mux : std_logic_vector(15 downto 0);

signal RegDst, ExtOp, ALUSrc, Branch, Jump, MemWrite, MemtoReg, RegWrite, shift_amount: std_logic;
signal OpCode: std_logic_vector(2 downto 0);
signal ALUOp: std_logic_vector(2 downto 0);
signal functia, selectie: std_logic_vector(2 downto 0);
signal writeData,rd1,rd2, imediatul: std_logic_vector(15 downto 0);
signal clk2: std_logic;
signal myEqual: std_logic_vector(3 downto 0);

signal MemData: std_logic_vector(15 downto 0);
signal AluResFinal: std_logic_vector(15 downto 0);
signal ALuRes: std_logic_vector(15 downto 0);
signal PCSrc: std_logic;	
signal ZeroFlag: std_logic;
signal BranchAddress: std_logic_vector(15 downto 0);
signal JumpAddress: std_logic_vector(15 downto 0);

begin
u0: mpg port map (btn(2) , clk , we);
u1: mpg port map (btn(0) , clk , reset_pc);
u2: afisor port map(clk, af(15 downto 12), af(11 downto 8), af(7 downto 4), af(3 downto 0), cat, an);
u3: Instr_Fetch port map(we, clk, reset_pc, Jump , PCSrc , JumpAddress , BranchAddress , iesireIF1, iesireIF2);
u4: ID port map (clk2, iesireIF1, writeData, RegWrite, RegDst, ExtOp, rd1, rd2, imediatul, functia, shift_amount);
u5: EX port map(iesireIF2, rd1, rd2, imediatul, functia, shift_amount, ALUSrc, ALUOp, AluRes, BranchAddress , ZeroFlag, myEqual);
u6: MEM port map(clk, AluRes, rd2, MemWrite, we, MemData, AluResFinal);


clk2 <= clk and we;

selectie <= sw(15 downto 13);
process(selectie ,iesireIF1 ,iesireIF2)
begin
     case selectie is
        when "000" => iesire_mux <= iesireIF1;
        when "001" => iesire_mux <= iesireIF2;
        when "010" => iesire_mux <= rd1; 
        when "011" => iesire_mux <= rd2; 
        when "100" => iesire_mux <= AluResFinal;
        when "101" => iesire_mux <= imediatul;
        when others => iesire_mux <= x"0000";
     end case;    
end process;


OpCode<= iesireIF1(15 downto 13);

process(OpCode)
begin 
    RegDst <= '0';
    ExtOp <= '0';
    ALUSrc <= '0';
    Branch <= '0';
    Jump <= '0'; 
    ALUOp <= "000";
    MemWrite <= '0';
    MemtoReg <= '0';
    RegWrite <= '0';
    
    case OpCode is
        when "000" => RegDst <= '1'; ALUOp <= "000"; RegWrite <= '1'; --Tip R
        when "001" => ExtOp <= '1'; ALUSrc <= '1'; ALUOp <= "001"; --addi
        when "010" => ExtOp <= '1'; ALUSrc <= '1';  RegWrite <= '1'; MemtoReg <= '1'; ALUOp <= "010"; --lw
        when "011" => ExtOp <= '1'; ALUSrc <= '1';  MemWrite <= '1'; ALUOp <= "011"; --sw
        when "100" => ExtOp <= '0'; ALUSrc <= '1';  Branch <= '1'; ALUOp <= "100"; --beq
        when "101" => ExtOp <= '1'; ALUSrc <= '1'; RegWrite <= '1'; ALUOp <= "101"; --div
        when "110" => ExtOp <= '1'; ALUSrc <= '1';  RegWrite <= '1'; ALUOp <= "110"; --mod
        when "111" => Jump <= '1'; ALUOp <= "111"; --jump
    end case;    
end process; 
 

process(MemtoReg, AluResFinal, MemData)  
    begin
        case(MemtoReg) is
            when '1' => WriteData <= MemData;
            when '0' => WriteData <= AluResFinal;
        end case;
end process;   

--process(MemtoReg, AluRes, MemData)  
--    begin
--        case(MemtoReg) is
--            when '1' => WriteData <= MemData;
--            when '0' => WriteData <= AluRes;
--        end case;
--end process;    
    
PCSrc <= ZeroFlag and Branch; 

JumpAddress <= "000" & IesireIF1(12 downto 0);
   

af<=iesire_mux;
--af <= AluRes;

led(0) <= RegDst;
led(1) <= ExtOp;
led(2) <= ALUSrc;
led(3) <= Branch;
led(4) <= Jump ; 
led(5) <= MemWrite ;
led(6) <= MemtoReg;
led(7) <= RegWrite ;

process(myEqual)
begin
    if(myEqual > "0010")
        then led(15) <= '0';
    else 
        led(15) <= '1';
end if;
end process;
    

end Behavioral;
