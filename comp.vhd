----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:28:58 07/04/2023 
-- Design Name: 
-- Module Name:    comp - comp_behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity comp is
	Port ( x: in STD_LOGIC_VECTOR (3 downto 0);
	       y: in STD_LOGIC_VECTOR (3 downto 0);
          cp: in STD_LOGIC;	
           z: out STD_LOGIC_VECTOR (3 downto 0));
end comp;

architecture comp_behavioral of comp is

-- sinais de comparacao bit a bit
signal G,E,S: STD_LOGIC_VECTOR(2 downto 0);
-- sinais para operandos
signal a,b: STD_LOGIC_VECTOR(3 downto 0);
-- sinais de comparacao entre os numeros
signal zG,zE,zS: STD_LOGIC;

begin

    a <= x;    
    b <= y;

    -- compara as entradas bit a bit
    defcomp: FOR i in 0 to 2 GENERATE              
        G(i) <= a(i) AND (NOT b(i));
        E(i) <= a(i) XNOR b(i);         
        S(i) <= (NOT a(i)) AND b(i);
    end GENERATE;

    -- se o bit de sinal do primeiro 0 e o do segundo 1, ZG = 1 
    zG <= ((NOT a(3)) AND b(3)) OR ((a(3) XNOR b(3)) AND (G(2) OR (E(2) AND G(1)) OR (E(2) AND E(1) AND G(0))));
    -- se todos os bits sao iguais, ZE = 1
    zE <= (a(3) xnor b(3)) AND E(2) AND E(1) AND E(0);               
    -- se o bit de sinal do primeiro 1 e o do segundo 0, ZS = 1  
    zS <= (a(3) AND (NOT b(3))) OR ((a(3) XNOR b(3)) AND (S(2) OR (E(2) AND S(1)) OR (E(2) AND E(1) AND S(0))));
    

    -- saida 0011 (3) caso maior, 0010 (2) caso igual, 0001 (1) caso menor                            
    z(3 downto 2) <= "00";
    z(1) <= cp AND (zG OR zE);           
    z(0) <= cp AND (zG OR zS);
    
end comp_behavioral;


