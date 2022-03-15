--************************************************************************************************ 

--AND gate with delay of 7ns:
library ieee;
use ieee.std_logic_1164.all; 

entity and_gate is
	port(x,y: IN std_logic; z: OUT std_logic);
end entity and_gate ;

architecture behavioral_delay of and_gate is
begin
	 z <= x AND y after 7 NS ;
end architecture behavioral_delay; 

--************************************************************************************************ 

--OR gate with delay of 7ns:
library ieee;
use ieee.std_logic_1164.all; 

entity or_gate is
	port(x,y: IN std_logic; z: OUT std_logic);
end entity or_gate ;

architecture behavioral_delay of or_gate is
begin
	 z <= x OR y after 7 NS ;
end architecture behavioral_delay; 

--3 inputs OR gate with delay of 7ns:
library ieee;
use ieee.std_logic_1164.all; 

entity or3_gate is
	port(a,b,c: IN std_logic; d: OUT std_logic);
end entity or3_gate ;

architecture behavioral_delay of or3_gate is
begin
	 d <= a OR b OR c after 7 NS ;
end architecture behavioral_delay; 

--8 inputs OR gate with delay of 7ns:
library ieee;
use ieee.std_logic_1164.all; 

entity or8_gate is
	port(x1,x2,x3,x4,x5,x6,x7,x8: IN std_logic; d: OUT std_logic);
end entity or8_gate ;

architecture behavioral_delay of or8_gate is
begin
	 d <= x1 OR x2 OR x3 OR x4 OR x5 OR x6 OR x7 OR x8 after 7 NS ;
end architecture behavioral_delay; 

--************************************************************************************************ 

--NAND gate with delay of 5ns:
library ieee;
use ieee.std_logic_1164.all; 

entity nand_gate is
	port(x,y: IN std_logic; z: OUT std_logic);
end entity nand_gate ;

architecture behavioral_delay of nand_gate is
begin
	z <= x NAND y after 5 NS ;	
	-- z <= NOT (x AND y) after 5 NS ;	
end architecture behavioral_delay; 

--************************************************************************************************ 

--NOR gate with delay of 5ns:
library ieee;
use ieee.std_logic_1164.all; 

entity nor_gate is
	port(x,y: IN std_logic; z: OUT std_logic);
end entity nor_gate ;

architecture behavioral_delay of nor_gate is
begin
	 z <= x NOR y after 5 NS ;
end architecture behavioral_delay; 	 

--************************************************************************************************

--XNOR gate with delay of 9ns:
library ieee;
use ieee.std_logic_1164.all; 

entity xnor_gate is
	port(x,y: IN std_logic; z: OUT std_logic);
end entity xnor_gate ;

architecture behavioral_delay of xnor_gate is
begin
	 z <= x XNOR y after 12 NS ;
end architecture behavioral_delay;

--************************************************************************************************ 

--XOR gate with delay of 12ns:
library ieee;
use ieee.std_logic_1164.all; 

entity xor_gate is
	port(x,y: IN std_logic; z: OUT std_logic);
end entity xor_gate ;

architecture behavioral_delay of xor_gate is
begin
	 z <= x XOR y after 12 NS ;
end architecture behavioral_delay; 

--3 inputs xor gate with daley of 12ns:
library ieee;
use ieee.std_logic_1164.all; 

entity xor3_gate is
	port(a,b,c: IN std_logic; d: OUT std_logic);
end entity xor3_gate ;

architecture behavioral_delay of xor3_gate is
begin
	 d <= a XOR b XOR c after 12 NS ;
end architecture behavioral_delay; 

--************************************************************************************************	   

--inverter with delay of 2ns:
library ieee;
use ieee.std_logic_1164.all; 

entity inverter is
	port(x: IN std_logic; z: OUT std_logic);
end entity inverter ;

architecture behavioral_delay of inverter is
begin
	 z <= not x after 2 NS ;
end architecture behavioral_delay; 	  

--************************************************************************************************ 