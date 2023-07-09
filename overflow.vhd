----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:26:44 07/04/2023 
-- Design Name: 
-- Module Name:    overflow - overflow_behavioral 
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

entity overflow is
    Port ( -- bit de sinal de cada operando
           x : in  STD_LOGIC;
           y : in  STD_LOGIC;

           -- bit de sinal do resultado
           z : in  STD_LOGIC;

           -- flag de overflow
           v : out  STD_LOGIC);
end overflow;

architecture overflow_behavioral of overflow is

begin

    -- ocorre quando os bits de sinal dos operandos são iguais entre si e diferentes do bit de sinal do resultado
    v <= (x XNOR y) AND (z XOR y);      

end overflow_behavioral;



