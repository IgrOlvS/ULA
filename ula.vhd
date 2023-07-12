----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:03:09 07/04/2023 
-- Design Name: 
-- Module Name:    ula - ula_behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ula is
    Port (  -- operandos de entrada
			x: 	 in STD_LOGIC_VECTOR (3 downto 0);
            y: 	 in STD_LOGIC_VECTOR (3 downto 0);

			-- entrada de controle e clock
            cnt:   in STD_LOGIC_VECTOR (2 downto 0);
			clk:   in STD_LOGIC;
				
			-- saida final em binario
            z_bin: out STD_LOGIC_VECTOR (3 downto 0);

			-- flags
            c_out: out STD_LOGIC;
            v: 	   out STD_LOGIC;
            zero:  out STD_LOGIC;
            neg:   out STD_LOGIC);
end ula;

architecture ula_behavioral of ula is

-- componente do somador de 4 bits
COMPONENT fourbitfa
	Port ( x: 	  in STD_LOGIC_VECTOR (3 downto 0);
	       y: 	  in STD_LOGIC_VECTOR (3 downto 0);
	       c_in:  in STD_LOGIC;	
	       z: 	  out STD_LOGIC_VECTOR (3 downto 0);
	       c_out: out STD_LOGIC);
end COMPONENT;

-- componente do overflow
COMPONENT overflow
    Port ( x : in  STD_LOGIC;
           y : in  STD_LOGIC;
           z : in  STD_LOGIC;
           v : out  STD_LOGIC);
end COMPONENT;

-- componente do comparador
COMPONENT comp
	Port ( x: in STD_LOGIC_VECTOR (3 downto 0);
	       y: in STD_LOGIC_VECTOR (3 downto 0);
          cp: in STD_LOGIC;	
           z: out STD_LOGIC_VECTOR (3 downto 0));
end COMPONENT;

-- componente de controle de saidas
COMPONENT cntrl
Port (	x: in STD_LOGIC_VECTOR(3 downto 0);
		y: in STD_LOGIC_VECTOR(3 downto 0);
		usa_som: in STD_LOGIC;
		z_soma:  in  STD_LOGIC_VECTOR (3 downto 0);
		z_nand:  in  STD_LOGIC_VECTOR (3 downto 0);
		z_comp:  in  STD_LOGIC_VECTOR (3 downto 0);
		z_pari:  in  STD_LOGIC_VECTOR (3 downto 0);
		c_in:    in  STD_LOGIC;
		v_in:    in  STD_LOGIC;
		z_bin: out  STD_LOGIC_VECTOR (3 downto 0);
		c_out: out  STD_LOGIC;
		v_out: out  STD_LOGIC;
		zero:  out  STD_LOGIC;
		neg:   out  STD_LOGIC);
end COMPONENT;

-- sinais para manipulacao dos operandos
signal a, b, a_temp, b_temp, count: STD_LOGIC_VECTOR(3 downto 0);

-- sinais para transmissao das saidas
signal z_nand, z_comp, z_pari, z_soma: STD_LOGIC_VECTOR(3 downto 0);
signal z_pari_temp, c_temp, v_temp: STD_LOGIC;

-- sinais para determinar a operacao
signal usa_som, cin, add, sub, invt, inc, nd, db, cp, par: STD_LOGIC;

begin
	
	-- contador define o segundo operando a cada subida de clock
	PROCESS(clk)
	begin
		IF (clk'event AND clk = '1') THEN
			count <= count + '1';
		end IF;
	end PROCESS;

	-- primeiro operando fixo em 5, segundo operando vem do contador
	a_temp <= "0101";
	b_temp <= count;

	-- definir a operacao a ser realizada a partir das entradas de controle
	add  <= (NOT cnt(2)) AND (NOT cnt(1)) AND (NOT cnt(0));		-- controle para adicao
	sub  <= (NOT cnt(2)) AND (NOT cnt(1)) AND cnt(0);			-- controle para subtracao
	invt <= (NOT cnt(2)) AND cnt(1) AND (NOT cnt(0));			-- controle para inverter sinal
	inc  <= (NOT cnt(2)) AND cnt(1) AND cnt(0);					-- controle para incremento
	nd   <= cnt(2) AND (NOT cnt(1)) AND (NOT cnt(0));			-- controle para nand
	db	 <= cnt(2) AND (NOT cnt(1)) AND cnt(0);					-- controle para dobro
	cp   <= cnt(2) AND cnt(1) AND (NOT cnt(0));					-- controle para metade
	par  <= cnt(2) AND cnt(1) AND cnt(0);						-- controle para paridade

	-- verifca se a operacao usa um somador ou nao
    usa_som <= NOT(nd OR cp OR par);       

	-- carry in igual a 1 para subtracao/inverter/incremento
	cin <= sub OR invt OR inc; 									

	-- define o primeiro operando de acordo com a operacao
	defx: FOR i in 0 to 3 GENERATE													-- igual a primeira entrada caso add,sub,nand,comparar ou paridade;
		a(i) <= (a_temp(i) AND (NOT (invt OR inc OR db))) OR (b_temp(i) AND db);	-- igual ao segundo operando caso dobro;			
	end GENERATE;																	-- 0 caso inverter ou incremento
																						
	-- define o segundo operando de acordo com a operacao																					
	defy: FOR i in 0 to 3 GENERATE
		b(i) <= b_temp(i) XOR (invt OR sub); 				-- inverte os bits da segunda entrada caso subtracao ou inverter sinal
	end GENERATE;

	-- operacao NAND bit a bit
	defnand: FOR i in 0 to 3 GENERATE
		z_nand(i) <= (a(i) NAND b(i)) AND nd;				
	end GENERATE;

	-- lógica para detectar paridade par
	z_pari_temp <= (b(0) XOR b(1)) XNOR (b(2) XOR b(3)) XNOR (a(0) XOR a(1)) XNOR (a(2) XOR a(3));	

	-- saida 0001 quando for par, 0000 caso contrario
	z_pari(0) <= z_pari_temp AND par;
	z_pari(3 downto 1) <= "000"; 

	-- realiza as operacoes que usam o somador (add,sub,inverter,incremento,dobro)
	adderFourbit: 	fourbitfa port map (a,b,cin,z_soma,c_temp);
	
	-- detecta overflow
	overflowDetec: 	overflow port map (a(3),b(3),z_soma(3),v_temp);	

	-- compara os dois operandos			        
	comparador: 	comp port map (a,b,cp,z_comp);									        	

	-- organiza e seleciona as saidas
	cntrlSaida: 	cntrl port map (a,b_temp,usa_som,z_soma,z_nand,z_comp,z_pari,c_temp,v_temp,
									z_bin,c_out,v,zero,neg);	

end ula_behavioral;
