--this is a package containing all the basic gates with certain delays as a components 

library ieee;
use ieee.std_logic_1164.all;  

PACKAGE basic_gates_with_delay is 
	
	component and_gate
		port(x,y: IN std_logic; z: OUT std_logic);
	end component and_gate;
	
	component or_gate
		port(x,y: IN std_logic; z: OUT std_logic);
	end component or_gate;
	
	component or3_gate
		port(a,b,c: IN std_logic; d: OUT std_logic);
	end component or3_gate;
	
	component nand_gate
		port(x,y: IN std_logic; z: OUT std_logic);
	end component nand_gate;
	
	component nor_gate
		port(x,y: IN std_logic; z: OUT std_logic);
	end component nor_gate;
	
	component xnor_gate
		port(x,y: IN std_logic; z: OUT std_logic);
	end component xnor_gate;
	
	component xor_gate
		port(x,y: IN std_logic; z: OUT std_logic);
	end component xor_gate;	
	
	component xor3_gate
		port(a,b,c: IN std_logic; d: OUT std_logic);
	end component xor3_gate;
	
	component or8_gate
		port(x1,x2,x3,x4,x5,x6,x7,x8: IN std_logic; d: OUT std_logic);
	end component or8_gate;
	
	component inverter
		port(x: IN std_logic; z: OUT std_logic);
	end component inverter;

end package basic_gates_with_delay;	 

--NOTES ON PACKAGE USING: 
--after compiling the package it will become part of the WORK library 
--to use all components declared in the package : use work.basic_gates_with_delay.all 
--to use only a specific gate in the package : use work.basic_gates_with_delay.component_name 
--component declarations are defined in the package while component Instantiation must be inculded in the main code when needed 
--to use a component it must be Instantiated inside the main code : e.g:	  gate1:  inverter port map (a,b,c);
--mapping can be done in 2 ways: 1.positional mapping 2.nominal mapping (by name)
--Ports can be left unconnected by using the keyword OPEN 