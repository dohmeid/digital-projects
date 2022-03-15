--Stage 1: Signed Comparator using ripple adder and look-ahead adder	  
--************************************************************************************************

--full adder: will be used in ripple adder/subtractor 
library ieee;
use ieee.std_logic_1164.all; 
use work.basic_gates_with_delay.all; -- the full adder will be built structurally using the logic gates with delay defines in the package basic_gates_with_delay 

entity full_adder is
	port(x,y,Cin:IN std_logic :='0';  -- x & y are 1-bit inputs , Cin is the carry input
	Cout,S: OUT std_logic :='0');     -- Cout is the carry output , S is the output(sum/result) of the full adder 
end entity full_adder;

architecture structural of full_adder is	
    signal n1,n2,n3 : std_logic :='0';
begin
	g1: xor3_gate port map (x,y,Cin,S);      -- S = x XOR y XOR Cin 
	g2: and_gate port map (x,y,n1);
	g3: and_gate port map (x,Cin,n2);
	g4: and_gate port map (y,Cin,n3);
	g5: or3_gate port map (n1,n2,n3,Cout);	-- Cout <= (x AND y) OR (x AND Cin) OR (y AND Cin) ;	 
end architecture structural;   

--partial full adder: will be used in look ahead adder/subtractor 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL; 
use work.basic_gates_with_delay.all;
 
entity partial_full_adder is
Port (x,y,Cin : in STD_LOGIC :='0';
	  S,P,G: out STD_LOGIC :='0');	 --P is the carry propagate , G is the carry generate , S is the result 
end partial_full_adder;
 
architecture structural of partial_full_adder is
begin
	g1: xor3_gate port map (x,y,Cin,S);	-- S = x xor y xor Cin 
	g2: xor_gate port map (x,y,P);        -- P = x+y = x or y 
	g3: and_gate port map (x,y,G);       -- G = x*y = x and y 
end structural;	  
--************************************************************************************************

-- general adder entity with two architectures (one using ripple adder and the other using look-ahead adder)
library ieee;
use ieee.std_logic_1164.all;
use work.basic_gates_with_delay.all;

entity adder8bit is
	port(A,B:IN std_logic_vector(7 downto 0) :=X"00"; -- A & B are 8-bit inputs
	Cin: IN std_logic :='0';    --Cin is the carry input
	Cout,overflow: OUT std_logic :='0';  --Cout is the carry output , overflow output to indicate if there is an overflow or not (it's used with signed numbers) 
	S: OUT std_logic_vector(7 downto 0) :=X"00"); --S is the output(result/sum) of the ripple adder 
end entity adder8bit ;

-- 8-bit ripple adder/subtractor architecture
architecture ripple_adder_subtractor of adder8bit is
component full_adder is
	port(x,y,Cin:IN std_logic :='0';Cout,S: OUT std_logic :='0');    
end component;
	signal carry_inout : std_logic_vector(8 downto 0) :="000000000"; --signal to hold all the carry values inculding Cin & Cout 
	signal B_comp : std_logic_vector(7 downto 0) :=X"00";	     --signal to hold the value of the complement of B (second input) in subtraction case 
begin	 
	carry_inout(0) <= Cin;
	Cout <= carry_inout(8);
	LOOPP : for i in 0 to 7 generate 
	G1: xor_gate port map (B(i),carry_inout(0),B_comp(i)); -- B's complement = B xor Cin (= B xor 0 = B in addition case) ,(= B xor 1 = B's comp in subtraction case)
	G2: full_adder port map (A(i),B_comp(i),carry_inout(i),carry_inout(i+1),S(i));
	end generate LOOPP; 
	G3: xor_gate port map (carry_inout(7),carry_inout(8),overflow); --to determine if there is an overflow or not such that overflow = C(7) xor C(8)  
															--overflow =1 indicates that there is an overflow
	                                                                --note: overflow value will be used in the next component (comparator)
end architecture ripple_adder_subtractor; 

library ieee;
use ieee.std_logic_1164.all;
use work.basic_gates_with_delay.all;

-- 8-bit look-ahead adder/subtractor architecture 
architecture look_ahead_adder_subtractor of adder8bit is
component partial_full_adder is
	port(x,y,Cin: IN std_logic :='0';  
	S,P,G: OUT std_logic :='0');    
end component;
	signal carry_inout : std_logic_vector(8 downto 0) :="000000000"; --signal to hold all the carry values inculding Cin & Cout 
	signal P,G : std_logic_vector(7 downto 0) :=X"00";	     --signals to hold the values of carry propagate P and carry generate G 
	signal s1,s21,s22,s31,s32,s33,s41,s42,s43,s44 ,s51,s52,s53,s54,s55: std_logic;	
	signal s61,s62,s63,s64,s65,s66,s71,s72,s73,s74,s75,s76,s77,s81,s82,s83,s84,s85,s86,s87,s88,sp : std_logic;
	signal B_comp : std_logic_vector(7 downto 0)  :=X"00";	     --signal to hold the value of the complement of B (second input) in subtraction case 
begin
	carry_inout(0) <= Cin;
	Cout <= carry_inout(8);	  
	LOOPP : for i in 0 to 7 generate 
	G0: xor_gate port map (B(i),carry_inout(0),B_comp(i));	-- B's complement = B xor Cin (= B xor 0 = B in addition case) ,(= B xor 1 = B's comp in subtraction case)
	G1: partial_full_adder port map (A(i),B_comp(i),carry_inout(i),S(i),P(i),G(i));
	--G2: and_gate port map (P(i),carry_inout(i),s1(i));   --to generate next carry 
	--G3: or_gate port map (s1(i),G(i),carry_inout(i+1));  --to generate next carry 
	end generate LOOPP;	

GC11: and_gate port map (P(0),carry_inout(0),s1); 	 -- c1 <= G(0) OR (P(0) AND Cin);
GC12: or_gate port map (s1,G(0),carry_inout(1));

GC21: and_gate port map (P(1),s1,s21);                  --c2 <= G(1) OR (P(1) AND G(0)) OR (P(1) AND P(0) AND Cin);
GC22: and_gate port map (P(1),G(0),s22);
GC23: or3_gate port map (s21,s22,G(1),carry_inout(2));
									   --c3 <= G(2) OR (P(2) AND G(1)) OR (P(2) AND P(1) AND G(0)) OR (P(2) AND P(1) AND P(0) AND Cin);
GC31: and_gate port map (P(2),s22,s31);		   --s31 = P(2) AND P(1) AND G(0)
GC32: and_gate port map (P(2),G(1),s32);
GC33: and_gate port map (P(2),s21,s33);		  -- s33 = P(2) AND P(1) AND P(0) AND Cin)
GC34: or8_gate port map (s33,G(2),s32,s31,'0','0','0','0',carry_inout(3));

--C(4) <= G(3) OR (P(3) AND G(2)) OR (P(3) AND s32) OR (P(3) AND s31) OR (P(3) AND s33); 
GC41:  and_gate port map (P(3),s33,s41);
GC42:  and_gate port map(P(3),s31,s42);
GC43:  and_gate port map(P(3),s32,s43);
GC44:  and_gate port map(P(3),G(2),s44);
GC45:  or8_gate port map(G(3),s44,s43,s42,s41,'0','0','0',carry_inout(4));

        
GC51:  and_gate port map (P(4),s32,s54);	--   (g(1) and p(4) and p(3) and p(2))
GC52:  and_gate port map (P(3),s42,s53); ---(g(0) and p(4) and p(3) and p(2) and p(1))
GC53:  and_gate port map(P(3),s44,s52); --(g(2) and p(4) and p(3))
GC54:  and_gate port map(P(4),s41,s51); --(ci and p(4) and p(3) and p(2) and p(1) and p(0));
GC55:  and_gate port map(P(4),G(3),s55);
GC56:  or8_gate port map(G(4),s55,s51,s52,s53,s54,'0','0',carry_inout(5));	

GC60:  and_gate port map(P(5),s51,s66); --(ci and p(5) and p(4) and p(3) and p(2) and p(1) and p(0))
GC61:  and_gate port map (P(5),s54,s65);	--   (g(1) and p(5) and p(4) and p(3) and p(2)) 
GC62:  and_gate port map (P(5),s53,s64); ---(g(0) and p(5) and p(4) and p(3) and p(2) and p(1)) 
GC63:  and_gate port map(P(5),s52,s63); --(g(2) and p(5) and p(4) and p(3))
GC64:  and_gate port map(P(5),s55,s62); --(g(3) and p(5) and p(4))
GC65:  and_gate port map(P(5),G(4),s61);
GC66:  or8_gate port map(G(5),s61,s62,s63,s64,s65,s66,'0',carry_inout(6));

GC77:  and_gate port map(P(6),s61,s77);	  --(g(4) and p(6) and p(5))
GC70:  and_gate port map(P(6),s66,s76); --(ci and p(6) and p(5) and p(4) and p(3) and p(2) and p(1) and p(0))
GC71:  and_gate port map (P(6),s65,s75);	--   (g(1) and p(6) and p(5) and p(4) and p(3) and p(2)) or
GC72:  and_gate port map (P(6),s64,s74); ---((g(0) and p(6) and p(5) and p(4) and p(3) and p(2) and p(1))) 
GC73:  and_gate port map(P(6),s63,s73); --((g(2) and p(6) and p(5) and p(4) and p(3)))
GC74:  and_gate port map(P(6),s62,s72); --(g(3) and p(6) and p(5) and p(4))
GC75:  and_gate port map(P(6),G(5),s71);
GC76:  or8_gate port map(G(6),s71,s72,s73,s74,s75,s76,s77,carry_inout(7));

GC87:  and_gate port map(P(7),s77,s88);	  --(g(4) and p(6) and p(5))
GC80:  and_gate port map(P(7),s76,s87); --(ci and p(7) and p(6) and p(5) and p(4) and p(3) and p(2) and p(1) and p(0)
GC81:  and_gate port map (P(7),s75,s86);	--   (g(1) and p(7) and p(6) and p(5) and p(4) and p(3) and p(2))
GC82:  and_gate port map (P(7),s74,s85); ---(((g(0) and p(7) and p(6) and p(5) and p(4) and p(3) and p(2) and p(1)) 
GC83:  and_gate port map(P(7),s73,s84); --((g(2) and p(7) and p(6) and p(5) and p(4) and p(3))
GC84:  and_gate port map(P(7),s72,s83); --(g(3) and p(7) and p(6) and p(5) and p(4))
GC855: and_gate port map(P(7),s71,s82);	--(g(5) and p(7) and p(6))
GC85:  and_gate port map(P(7),G(6),s81);
GC86:  or8_gate port map(G(7),s81,s82,s83,s84,s85,s86,s87,sp); 
Gg: or_gate port map (sp,s88,carry_inout(8))	;

GOV: xor_gate port map (carry_inout(7),carry_inout(8),overflow);
	 --to generate overflow value  
	
end architecture look_ahead_adder_subtractor;
--************************************************************************************************

-- subtraction result comparator: this unit will be used in the 8-bit signed comparator system 
library ieee;
use ieee.std_logic_1164.all; 

entity sub_res_comparator is
	port(subtraction_result: IN std_logic_vector(7 downto 0)  :=X"00";
	overflow: IN std_logic :='0';
	F1_equal,F2_bigger,F3_smaller: OUT std_logic :='0'); 	-- F1 indicates that A=B, F2 indicates that A>B, F3 indicates that A<B. 
end entity sub_res_comparator ;

architecture structural of sub_res_comparator is
begin		
	process (subtraction_result,overflow) 
	begin
	  if (subtraction_result="00000000") then 		 -- A=B if A-B = zero (subtraction result = 0)
		  F1_equal <= '1';
		  F2_bigger <= '0';
		  F3_smaller <= '0';
	  elsif (overflow = '0' and subtraction_result(7)='0') then	 -- A>B if there is no overflow and the subtraction result is positive (which occurs when the sign bit='0')  
	      F1_equal <= '0';
		  F2_bigger <= '1';
		  F3_smaller <= '0'; 	
	  else 				   -- otherwise A<B 
		  F1_equal <= '0';
		  F2_bigger <= '0';
		  F3_smaller <= '1';
	end if;
end process;
end architecture structural; 
--************************************************************************************************

-- 8-bit signed comparator system  
---it will be implemented twice once using 8-bit ripple adder/subtractor and the other using 8-bit look-ahead adder/subtractor 
library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_signed.all; 

entity signed_comparator_8bit is
	port(A,B:IN std_logic_vector(7 downto 0) :=X"00"; -- A & B are 8-bit inputs
	F1_equal,F2_bigger,F3_smaller: OUT std_logic :='0') ;  -- F1 indicates that A=B, F2 indicates that A>B, F3 indicates that A<B.  
end entity signed_comparator_8bit ;

--8 bit comparator using 8-bit ripple adder/subtractor 
architecture ripple_design of signed_comparator_8bit is  
signal c1,c2: std_logic := '0' ;
signal S: std_logic_vector(7 downto 0) := x"00" ;
begin	 
	gate1 : entity work.adder8bit(ripple_adder_subtractor) port map (A,B,'1',c1,c2,S);
	gate2 : entity work.sub_res_comparator(structural) port map (S,c2,F1_equal,F2_bigger,F3_smaller);
end architecture ripple_design; 

--8 bit comparator using 8-bit look ahead adder/subtractor 
architecture lookahead_design of signed_comparator_8bit is  
signal c1,c2: std_logic := '0' ;
signal S: std_logic_vector(7 downto 0) := x"00" ;
begin	 
	gate1 : entity work.adder8bit(look_ahead_adder_subtractor) port map (A,B,'1',c1,c2,S);
	gate2 : entity work.sub_res_comparator(structural) port map (S,c2,F1_equal,F2_bigger,F3_smaller);
end architecture lookahead_design; 
--************************************************************************************************ 

--functional verification  

--test generator 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_signed.all;

ENTITY test_generator IS
PORT ( clk: IN STD_LOGIC := '0';
	TestA,TestB: OUT STD_LOGIC_VECTOR(7 DOWNTO 0) := X"00";
	Expected_F1,Expected_F2,Expected_F3: OUT STD_LOGIC := '0');   -- F1 indicates that A=B (equality case), F2 indicates that A>B (bigger case), F3 indicates that A<B (smaller case).
END ENTITY test_generator;

ARCHITECTURE tg OF test_generator IS
SIGNAL TestAA,TestBB:  STD_LOGIC_VECTOR(7 DOWNTO 0) := X"00"; --signals that equal test inputs
BEGIN 
	PROCESS									 							  
	BEGIN
		FOR I IN -127 TO 128 LOOP	       --since inputs are 8-bit length then there are 2^8=256 different possible value for each input
			FOR J IN -127 TO 128 LOOP	   --since we are dealing with signed numbers, they'll range between -127 and 128			 
				TestA <= CONV_STD_LOGIC_VECTOR(I,8);   --Setting the inputs to the comparator 	
				TestAA <= CONV_STD_LOGIC_VECTOR(I,8);
				TestB <= CONV_STD_LOGIC_VECTOR(J,8);
				TestBB <= CONV_STD_LOGIC_VECTOR(J,8);
				WAIT until rising_edge(clk);       		 --Waiting until comparator output has settled 
			END LOOP;
		END LOOP;
		WAIT;
	END PROCESS; 
	
	PROCESS(TestAA,TestBB,clk)									 							  
	BEGIN
		  							--calculating the expected output of the comparator 
				if (TestAA=TestBB) then
				  Expected_F1 <= '1';
				  Expected_F2 <= '0';
				  Expected_F3 <= '0';
				elsif (TestAA>TestBB) then
				  Expected_F1 <= '0';
				  Expected_F2 <= '1';
				  Expected_F3 <= '0';
				else 
				  Expected_F1 <= '0';
				  Expected_F2 <= '0';
				  Expected_F3 <= '1';
				end if;	
	END PROCESS;
	
END ARCHITECTURE tg;


--result analyzer 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_signed.all;

ENTITY result_analyzer IS
PORT ( clk: IN STD_LOGIC := '0';
	TestA,TestB: IN STD_LOGIC_VECTOR(7 DOWNTO 0) := X"00";
	Expected_F1,Expected_F2,Expected_F3: IN STD_LOGIC := '0';
	actual_F1,actual_F2,actual_F3: IN STD_LOGIC := '0' );   -- F1 indicates that A=B (equality case), F2 indicates that A>B (bigger case), F3 indicates that A<B (smaller case).
END ENTITY result_analyzer;

ARCHITECTURE ra OF result_analyzer IS
BEGIN
    PROCESS(clk)
    BEGIN
      IF rising_edge(clk) THEN
        ASSERT   Expected_F1 =  actual_F1  	 -- Checking whether comparator output matches expectation 
			and Expected_F2 =  actual_F2
			and Expected_F3 =  actual_F3
        REPORT   "comparator output is incorrect" 
        SEVERITY ERROR;
      END IF;
    END PROCESS;
END ARCHITECTURE ra;
 
  
-- test bench for the comparator 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL; 

ENTITY comparator_test IS
END ENTITY comparator_test;	 													   										

ARCHITECTURE ripple_design_testbench OF comparator_test IS
	SIGNAL clk: std_logic:='0';
	SIGNAL TestA,TestB: STD_LOGIC_VECTOR(7 DOWNTO 0) := X"00" ;	      --Declarations of test inputs and outputs
	SIGNAL Expected_F1,Expected_F2,Expected_F3: STD_LOGIC :='0';
	SIGNAL actual_F1,actual_F2,actual_F3: STD_LOGIC :='0';
BEGIN
	clk <= NOT clk AFTER 150 NS;

	G1: ENTITY work.test_generator(tg) 	               -- an instance of test generation unit 
	PORT MAP (clk=>clk , TestA=>TestA , TestB=>TestB , Expected_F1=>Expected_F1 , Expected_F2=>Expected_F2 , Expected_F3=>Expected_F3);

	G2: ENTITY work.signed_comparator_8bit(ripple_design) 	 -- an instance of comparator Unit Under Test 
	PORT MAP (A=>TestA , B=>TestB , F1_equal=>actual_F1 , F2_bigger=>actual_F2 , F3_smaller=>actual_F3);

	G3: ENTITY work.result_analyzer(ra) 	               -- an instance of result analyzer unit 
	port map (clk=>clk , TestA=>TestA , TestB=>TestB , Expected_F1=>Expected_F1 , Expected_F2=>Expected_F2 , Expected_F3=>Expected_F3 , 
	actual_F1=>actual_F1 , actual_F2=>actual_F2 , actual_F3=>actual_F3);

END ARCHITECTURE ripple_design_testbench; 


ARCHITECTURE lookahead_design_testbench OF comparator_test IS
	SIGNAL clk: std_logic:='0';
	SIGNAL TestA,TestB: STD_LOGIC_VECTOR(7 DOWNTO 0) := X"00" ;	      --Declarations of test inputs and outputs
	SIGNAL Expected_F1,Expected_F2,Expected_F3: STD_LOGIC :='0';
	SIGNAL actual_F1,actual_F2,actual_F3: STD_LOGIC :='0';
BEGIN
	clk <= NOT clk AFTER 100 NS;

	G1: ENTITY work.test_generator(tg) 	               -- an instance of test generation unit 
	PORT MAP (clk=>clk , TestA=>TestA , TestB=>TestB , Expected_F1=>Expected_F1 , Expected_F2=>Expected_F2 , Expected_F3=>Expected_F3);

	G2: ENTITY work.signed_comparator_8bit(lookahead_design) 	 -- an instance of comparator Unit Under Test 
	PORT MAP (A=>TestA , B=>TestB , F1_equal=>actual_F1 , F2_bigger=>actual_F2 , F3_smaller=>actual_F3);

	G3: ENTITY work.result_analyzer(ra) 	               -- an instance of result analyzer unit 
	port map (clk=>clk , TestA=>TestA , TestB=>TestB , Expected_F1=>Expected_F1 , Expected_F2=>Expected_F2 , Expected_F3=>Expected_F3 , 
	actual_F1=>actual_F1 , actual_F2=>actual_F2 , actual_F3=>actual_F3);

END ARCHITECTURE lookahead_design_testbench;


--************************************************************************************************	