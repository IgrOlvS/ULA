----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:24:37 07/04/2023 
-- Design Name: 
-- Module Name:    fourbitfa - fourbitfa_behavioral 
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

entity fourbitfa is
	Port ( -- primeiro e segundo operandos
		   x: in STD_LOGIC_VECTOR (3 downto 0);
	       y: in STD_LOGIC_VECTOR (3 downto 0);
		   
		   -- carry in
	       c_in: in STD_LOGIC;	
		   
		   -- resultado e carry out
	       z: out STD_LOGIC_VECTOR (3 downto 0);
	       c_out: out STD_LOGIC);
end fourbitfa;

architecture fourbitfa_behavioral of fourbitfa is

-- componente do somadar de 1 bit
COMPONENT fa
	Port ( x:    in STD_LOGIC;
	       y:    in STD_LOGIC;
	       cin:  in STD_LOGIC;	
	       z:    out STD_LOGIC;
	       cout: out STD_LOGIC);
end COMPONENT;

-- sinais para operandos a e b, carry
signal a,b: STD_LOGIC_VECTOR(3 downto 0);
signal c: STD_LOGIC_VECTOR(4 downto 0); 
begin

    c(0) <= c_in;
    a <= x;
    b <= y;

	-- usa um full adder para cada bit
    fa0	: fa port map (a(0),b(0),c(0),z(0),c(1));		
    fa1	: fa port map (a(1),b(1),c(1),z(1),c(2));
    fa2	: fa port map (a(2),b(2),c(2),z(2),c(3));
    fa3	: fa port map (a(3),b(3),c(3),z(3),c(4));

    c_out <= c(4);
end fourbitfa_behavioral;


