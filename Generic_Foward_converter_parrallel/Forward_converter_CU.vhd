----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:32:33 07/19/2023 
-- Design Name: 
-- Module Name:    Forward_converter_CU - Behavioral 
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

entity Forward_converter_CU is
    port(
        clk              	:in STD_LOGIC;
        greater_than_one 	:in STD_LOGIC;
        cout             	:in STD_LOGIC;
        allones          	:in STD_LOGIC;
        sign_bit_3rd_mod    :in STD_LOGIC;
        reset            	:in STD_LOGIC;

        mux0,mux2		     	:out STD_LOGIC;
		mux1,mux3				:out STD_LOGIC_VECTOR(1 downto 0);
        InputRegLd, InputRegCl, mod2RegLd, mod2RegCl, Cin0,Cin1, mod1RegLd, mod1RegCl, mod3RegLd, mod3RegCl, Done :out STD_LOGIC 

    );
end Forward_converter_CU;

architecture Behavioral of Forward_converter_CU is

    type state_type is ( ST0, ST1, ST2, ST3, ST4, ST5, ST6, ST7);
	signal PresentState, NextState : state_type; 
    signal currentcount, nextcount : std_logic_vector(1 downto 0);
	signal control_sig             : std_logic_vector(16 downto 0);
	signal statecount              : std_logic_vector(1 downto 0);

begin

statecount <= currentcount;

sync: process(clk, Reset, NextState, nextcount) 
		begin
			if(reset = '1') then
				PresentState <= ST0;
				currentcount <= "00";
			elsif(rising_edge(clk)) then
				PresentState <= NextState;
				currentcount <= nextcount;
			end if;
	end process sync;


comb_proc: process(PresentState, statecount, sign_bit_3rd_mod, greater_than_one, cout, allones)

        begin

        case PresentState is
				    when ST0 => 
						  control_sig <= b"000_000_100_100_010_10";
						  NextState <= ST1;
						  
				    when ST1 => 
							control_sig <= b"000_000_001_001_101_00";
							if (cout = '1') then
								NextState <= ST2;
							else NextState <= ST3;
							end if;

                    when ST2 => 
							control_sig <= b"110_000_001_000_000_00";
							if (statecount = "00") then
								NextState   <= ST3;
							else 
								NextState <= ST4;
							end if;

                    when ST3 =>
							control_sig <= b"101_101_001_000_001_00";
							if (cout = '1') then
								NextState   <= ST2;
							else NextState <= ST4;
							end if;
					
					when ST4 =>
						control_sig <= b"000_000_000_000_000_00";
						if (allones = '1') then
							NextState   <= ST2;
						elsif (sign_bit_3rd_mod = '1') then
							NextState <= ST5;
						elsif (greater_than_one = '1') then
							NextState  <= ST6;
						else 
							NextState   <= ST7;
						end if;


                    when ST5 => 
						control_sig <= b"000_110_000_000_001_00";
						NextState <= ST7;

                    when ST6 => 
						control_sig <= b"000_110_000_001_001_00";
						NextState <= ST7;

                    when ST7 => 
						control_sig <= b"000_000_000_000_000_00";
						NextState <= ST7;

         end case;			


end process comb_proc;



statecount_proc: process(PresentState, currentcount)
			begin
				
				case PresentState is
						when ST0 =>
									nextcount <= "00";
						when ST1 => 
									nextcount <= "00";
						when ST2 =>
									nextcount <= currentcount;
						when ST3 =>
									nextcount <= "01";
						when ST4 =>
									nextcount <= "10";
						when ST5 =>
									nextcount <= currentcount;
                        when ST6 =>
									nextcount <= currentcount;
                        when ST7 =>
									nextcount <= currentcount;
                
                            
				end case;
	
end process statecount_proc;


mux0                <= control_sig(16);
mux1                <= control_sig(15 downto 14);
mux2 				<= control_sig(13);
mux3 				<= control_sig(12 downto 11);
InputRegLd          <= control_sig(10);
InputRegCl          <= control_sig(9); 
mod1RegLd           <= control_sig(8); 
mod1RegCl           <= control_sig(7); 
Cin0                <= control_sig(6); 
Cin1                <= control_sig(5);
mod2RegLd           <= control_sig(4); 
mod2RegCl           <= control_sig(3); 
mod3RegLd           <= control_sig(2); 
mod3RegCl           <= control_sig(1); 
Done                <= control_sig(0);


end Behavioral;

