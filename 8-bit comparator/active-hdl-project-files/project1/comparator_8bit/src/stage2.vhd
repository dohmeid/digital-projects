--Stage 2: Signed Comparator using Magnitude comparator and sign bit 
--************************************************************************************************

-- 1-bit Magnitude comparator 
library ieee;
use ieee.std_logic_1164.all; 
use work.basic_gates_with_delay.all;

entity magnitude_comparator_1bit is
	port(x,y:IN std_logic := '0';  		-- x & y are 1-bit inputs
	E,B,S: OUT std_logic := '0');  		-- E indicates that x=y, B indicates that x>y, S indicates that x<y.  
end entity magnitude_comparator_1bit ;

architecture structural of magnitude_comparator_1bit is 
signal n1,n2,n3 : std_logic := '0';
begin
	g1: xor_gate port map (x,y,n1); 
	g2: inverter port map (n1,E);    	 --E(equal) = not(x xor y) 
	g3: inverter port map (x,n2); 
	g4: and_gate port map (n2,y,S);       --S(smaller) = (not x) and y 
	g5: inverter port map (y,n3);
	g6: and_gate port map (x,n3,B); 	 --B(bigger) = x and (not y)	
end architecture structural; 
--************************************************************************************************ 

-- 7-bit Magnitude comparator 
library ieee;
use ieee.std_logic_1164.all; 

entity magnitude_comparator_7bit is
	port(x,y: in std_logic_vector(6 downto 0) :="0000000"; 	-- x & y are 7-bit inputs
	E,B,S: OUT std_logic :='0');                 				-- E indicates that x=y, B indicates that x>y, S indicates that x<y.   
end entity magnitude_comparator_7bit ; 

architecture structural of magnitude_comparator_7bit is 
component magnitude_comparator_1bit is
	port(x,y:IN std_logic :='0'; E,B,S: OUT std_logic :='0');    
end component;
signal EE,BB,SS : std_logic_vector(6 downto 0) :="0000000";
signal BBB: std_logic :='0'; 		--signal to hold the case when x>y 
begin
	   LOOPP : for i in 0 to 6 generate 
		gate: magnitude_comparator_1bit port map (x(i),y(i),EE(i),BB(i),SS(i));  
	   end generate LOOPP; 
	   BBB <= '1' when (BB(6)='1') or (EE(6)='1' and BB(5)='1') or (EE(6 downto 5) ="11" and BB(4)='1') or (EE(6 downto 4) ="111"  and BB(3)='1') or 
			 (EE(6 downto 3) ="1111" and BB(2)='1') or (EE(6 downto 2) ="11111" and BB(1)='1')
			  or ( EE(6 downto 1) = "111111" and BB(0)='1') else '0';	  --cases when x>y 
	   process(EE,BB,SS,x,y,BBB)
	   begin
		 if (EE = "1111111") then   --EE = "1111111" means that x=y
			 E <= '1';
			 B <= '0';
			 S <= '0'; 
		 elsif (BBB = '1') then	 
			 E <= '0';
			 B <= '1';
			 S <= '0';
		else 
			 E <= '0';
			 B <= '0';
			 S <= '1';
		end if;   
	   end process;
end architecture structural; 
--************************************************************************************************

-- 8-bit Signed comparator system  
--it will be implemented using 7-bit Magnitude comparator 

library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_signed.all; 

--entity signed_comparator_8bit is
--	port(A,B:IN std_logic_vector(7 downto 0) := X"00" ; 
--	F1_equal,F2_bigger,F3_smaller: OUT std_logic := '0');  
--end entity signed_comparator_8bit;	

-- another architecture for 8-bit Signed comparator system which it's entity was declared earlier (the entity is written above in comments as a reminder) 
architecture magnitude_comparator_design of signed_comparator_8bit is  
component magnitude_comparator_7bit is
	port(x,y: in std_logic_vector(6 downto 0):="0000000"; E,B,S: OUT std_logic :='0');                   
end component;		
signal EE,BB,SS : std_logic :='0';
begin 	 
	gate: magnitude_comparator_7bit port map (A(6 downto 0),B(6 downto 0),EE,BB,SS);
	process (A,B,EE,BB,SS) 
	begin
	if (A(7)/=B(7)) then              --if A and B have different signs then one of them is +ve and the other -ve
		if (A(7)='1' and B(7)='0') then	  --A is -ve and B is +ve which means A<B 
	       F1_equal <= '0';
		  F2_bigger <= '0';
		  F3_smaller <= '1';
		elsif (A(7)='0' and B(7)='1') then -- A is +ve and B is -ve  which means A>B 
		  F1_equal <= '0';
		  F2_bigger <= '1';
		  F3_smaller <= '0';	
		end if;
	elsif (A(7)=B(7)) then     		 --if A and B have the same signs then we have to use magnitude comparator to decicde which of them is +ve and which is -ve 
		  F1_equal <= EE;
		  F2_bigger <= BB;
		  F3_smaller <= SS;
     end if;	
     end process;	
end architecture magnitude_comparator_design;
--************************************************************************************************ 

-- test bench for the magnitude comparator design for the system(8-bit signed comparator)
library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_signed.all;

ARCHITECTURE magnitudeComparator_design_testbench OF comparator_test IS
	SIGNAL clk: std_logic:='0';
	SIGNAL TestA,TestB: STD_LOGIC_VECTOR(7 DOWNTO 0) := X"00" ;	      --Declarations of test inputs and outputs
	SIGNAL Expected_F1,Expected_F2,Expected_F3: STD_LOGIC :='0';
	SIGNAL actual_F1,actual_F2,actual_F3: STD_LOGIC :='0';
BEGIN
	clk <= NOT clk AFTER 25 NS;

	G1: ENTITY work.test_generator(tg) 	               -- an instance of test generation unit 
	PORT MAP (clk=>clk , TestA=>TestA , TestB=>TestB , Expected_F1=>Expected_F1 , Expected_F2=>Expected_F2 , Expected_F3=>Expected_F3);

	G2: ENTITY work.signed_comparator_8bit(magnitude_comparator_design) 	 -- an instance of comparator Unit Under Test 
	PORT MAP (A=>TestA , B=>TestB , F1_equal=>actual_F1 , F2_bigger=>actual_F2 , F3_smaller=>actual_F3);

	G3: ENTITY work.result_analyzer(ra) 	               -- an instance of result analyzer unit 
	port map (clk=>clk , TestA=>TestA , TestB=>TestB , Expected_F1=>Expected_F1 , Expected_F2=>Expected_F2 , Expected_F3=>Expected_F3 , 
	actual_F1=>actual_F1 , actual_F2=>actual_F2 , actual_F3=>actual_F3);

END ARCHITECTURE magnitudeComparator_design_testbench;

--************************************************************************************************ 