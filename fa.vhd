----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:22:11 07/04/2023 
-- Design Name: 
-- Module Name:    fa - fa_behavioral 
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

entity fa is
	Port ( -- operandos 1 e 2
	       x: in STD_LOGIC;
	       y: in STD_LOGIC;

	       -- carry in
	       cin: in STD_LOGIC;	

	       -- resultado e carry out
	       z: out STD_LOGIC;
	       cout: out STD_LOGIC);
end fa;

architecture fa_behavioral of fa is

begin
	-- calculo da soma
	z <= x xor y xor cin;		
	
	-- calculo do carry				
	cout <= ((x xor y) and cin) or (x and y);	

end fa_behavioral;

