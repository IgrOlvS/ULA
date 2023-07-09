----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:34:20 07/04/2023 
-- Design Name: 
-- Module Name:    cntrl - cntrl_behavioral 
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

entity cntrl is
    Port (  -- operandos
            x: in STD_LOGIC_VECTOR(3 downto 0);
			y: in STD_LOGIC_VECTOR(3 downto 0);
        
            -- caso a operacao use somador
            usa_som: in STD_LOGIC;

            -- saidas das operacoes
            z_soma: in  STD_LOGIC_VECTOR (3 downto 0);
            z_nand: in  STD_LOGIC_VECTOR (3 downto 0);
            z_comp: in  STD_LOGIC_VECTOR (3 downto 0);
            z_pari: in  STD_LOGIC_VECTOR (3 downto 0);

            -- carry out, overflow e saida final em binario
            c_in:  in  STD_LOGIC;
            v_in:  in  STD_LOGIC;
            z_bin: out STD_LOGIC_VECTOR (3 downto 0);

            -- flags
            c_out: out  STD_LOGIC;
            v_out: out  STD_LOGIC;
            zero:  out  STD_LOGIC;
            neg:   out  STD_LOGIC);

end cntrl;

architecture cntrl_behavioral of cntrl is
signal z_temp: STD_LOGIC_VECTOR (3 downto 0);
begin

    -- unifica as opcoes de saida
	defzout: FOR i in 0 to 3 GENERATE
		z_temp(i) <= (z_soma(i) AND usa_som) OR ((NOT usa_som) AND (z_nand(i) OR z_comp(i) OR z_pari(i)));       
	end GENERATE;

    -- resultado em binario
	z_bin <= z_temp;                                                
    -- flags associadas ao somador
	c_out <= c_in AND usa_som;                   -- flag cout
	v_out <= v_in AND usa_som;                   -- flag overflow
    -- flags zero e negativo
	zero  <= NOT(z_temp(0) OR z_temp(1) OR z_temp(2) OR z_temp(3));  
	neg   <= z_temp(3);                                              
	
end cntrl_behavioral;

