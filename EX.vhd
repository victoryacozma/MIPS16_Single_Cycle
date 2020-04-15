----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/06/2020 07:38:45 PM
-- Design Name: 
-- Module Name: EX - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity EX is
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
           Equal: out std_logic_vector(3 downto 0));
end EX;

architecture Behavioral of EX is
signal AluIn2 : std_logic_vector(15 downto 0);
signal AluCtrl : std_logic_vector(3 downto 0);
signal AluResAux : std_logic_vector(15 downto 0);
signal temp : std_logic_vector(15 downto 0);

begin

BranchAddr <= Ext_Imm;

process(AluSrc, RD2, Ext_Imm)
    begin
        if(AluSrc = '0')
            then AluIn2 <= RD2;
        else
             AluIn2 <= Ext_Imm;
        end if;
end process;

process(AluOp, funct)
    begin
        case(AluOp) is
            when "000" => 
                case(funct) is 
                    when "000" => AluCtrl <= "0000"; --add
                    when "001" => AluCtrl <= "0001"; --sub
                    when "010" => AluCtrl <= "0010"; --sll
                    when "011" => AluCtrl <= "0011"; --srl
                    when "100" => AluCtrl <= "0100"; --and
                    when "101" => AluCtrl <= "0101"; --or
                    when "110" => AluCtrl <= "0110"; --xor
                    when "111" => AluCtrl <= "0111"; --set on less than          
                    when others => AluCtrl <= "0000";
                 end case;
            when "001" => AluCtrl <= "1000";--addi
            when "010" => AluCtrl <= "1001";--lw
            when "011" => AluCtrl <= "1010";--sw
            when "100" => AluCtrl <= "1011";--beq
            when "101" => AluCtrl <= "1100";--div
            when "110" => AluCtrl <= "1101";--mod
            when "111" => AluCtrl <= "1110";--jump
            when others => AluCtrl <= "1111"; 
        end case;
end process;


process(AluCtrl, RD1, AluIn2, sa)
variable temp1: std_logic_vector(15 downto 0) := "0000000000000000";
variable count : std_logic_vector(15 downto 0);
variable calc : std_logic_vector(3 downto 0) := "0000";
    begin
        case(AluCtrl) is
            when "0000" => AluResAux <=  RD1 + AluIn2; --ADD
            when "0001" => AluResAux <=  RD1 - AluIn2; --SUB
            when "0010" => 
                            case(sa) is
                                when '1' => AluResAux <=  RD1(14 downto 0) & "0"; --SLL
                                when others => AluResAux <= RD1;
                            end case;    
            when "0011" => 
                            case(sa) is
                                when '1' => AluResAux <=  "0" & RD1(15 downto 1); --SLR
                                when others => AluResAux <= RD1;
                            end case;  
            when "0100" => AluResAux <=  RD1 and AluIn2; --AND
            when "0101" => AluResAux <=  RD1 or AluIn2; --OR
            when "0110" => AluResAux <=  RD1 xor AluIn2; --XOR
            when "0111" =>  --SET ON LESS THAN
					       if RD1<AluIn2 then
						      AluResAux<=X"0001";
					       else AluResAux<=X"0000";
					       end if;
----------------------------------------------------------------------------------------------------					       
            when "1000" => AluResAux <= RD1 + AluIn2; --addi
            when "1001" => AluResAux <=  RD1; --lw
            when "1010" => AluResAux <=  RD1; --sw
            when "1011" => AluResAux <=  RD1 - RD2; --beq
            
            when "1100" => --division 
  
            Equal <= calc;
            calc := calc + "0001";
            temp1 := RD1;
            count := x"0000";
 myLoop:    for ii in 0 to 100 loop
                exit myLoop when (temp1 < "0000000000001010"); 
                temp1 := temp1 - "0000000000001010";
                count := count + "0000000000000001";
            end loop myLoop;
            AluResAux <= count;
            
            when "1101" =>  --mod
            temp1 := RD1;
            count := x"0000";
 myLoopMod:    for ii in 0 to 100 loop
                exit myLoopMod when (temp1 < "0000000000001010"); 
                temp1 := temp1 - "0000000000001010";
                count := count + "0000000000000001";
            end loop myLoopMod;
            AluResAux <= temp1;
            
            when "1110" => AluResAux <=  RD1 - RD2; --jump
            when others => AluResAux <=  x"0000"; --JUMP 
         end case;
end process;


process(AluResAux)
    begin
        if AluResAux = x"0000"
         then ZeroFlag <= '1';
        else ZeroFlag <= '0';
    end if;
end process;

AluRes <= AluResAux;
                                              
end Behavioral;
