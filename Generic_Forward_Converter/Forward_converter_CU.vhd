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

        mux0		     	:out STD_LOGIC_VECTOR(1 downto 0);
		mux1				:out STD_LOGIC_VECTOR(2 downto 0);
        InputRegLd, InputRegCl, mod2RegLd, mod2RegCl, Cin, mod1RegLd, mod1RegCl, mod3RegLd, mod3RegCl, Done :out STD_LOGIC 

    );
end Forward_converter_CU;

architecture Behavioral of Forward_converter_CU is

    type state_type is ( ST0, ST1, ST2, ST3, ST4, ST5, ST6, ST7, ST8, ST9);
	signal PresentState, NextState : state_type; 
    signal currentcount, nextcount : std_logic_vector(1 downto 0);
	signal control_sig             : std_logic_vector(14 downto 0);
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
						  control_sig <= b"00_000_100_100_101_0";
						  NextState <= ST1;
						  
				    when ST1 => 
							control_sig <= b"00_000_001_001_000_0";
							if (cout = '1') then
								NextState <= ST2;
							else NextState <= ST3;
							end if;

                    when ST2 => 
							control_sig <= b"01_010_000_001_000_0";
							if (statecount = "00") then
								NextState   <= ST3;
							elsif (statecount = "01") then
								NextState <= ST4;
							else NextState <= ST5;
							end if;

                    when ST3 =>
							control_sig <= b"01_011_000_001_000_0";
							if (cout = '1') then
								NextState   <= ST2;
							else NextState <= ST4;
							end if;
					
					when ST4 =>
						control_sig <= b"00_000_000_000_000_0";
                         if (statecount = "11") then
							if (sign_bit_3rd_mod = '1') then
                                NextState <= ST7;
                            elsif (greater_than_one = '1') then
                                NextState  <= ST8;
						    else 
							    NextState   <= ST9;
                            end if;

						elsif (allones = '1') then
						   NextState   <= ST2;
                        else 
                            NextState  <= ST5;
                       
						end if;

                    when ST5 => 
						control_sig <= b"11_000_000_010_010_0";
						NextState <= ST6;

                    when ST6 => 
						control_sig <= b"00_001_000_000_010_0";
						NextState <= ST4;

                    when ST7 => 
						control_sig <= b"10_100_000_000_010_0";
						NextState <= ST9;

                    when ST8 => 
						control_sig <= b"10_100_000_010_010_0";
						NextState <= ST9;

                    when ST9 => 
						control_sig <= b"00_000_010_000_000_1";
						NextState <= ST9;

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
									nextcount <= "00";
                        when ST6 =>
									nextcount <= "11";
                        when ST7 =>
									nextcount <= currentcount;
                        when ST8 =>
									nextcount <= currentcount;
                        when ST9 =>
									nextcount <= currentcount;
                            
				end case;
	
end process statecount_proc;


mux0                <= control_sig(14 downto 13);
mux1                <= control_sig(12 downto 10);
InputRegLd          <= control_sig(9);
InputRegCl          <= control_sig(8); 
mod2RegLd           <= control_sig(7); 
mod2RegCl           <= control_sig(6); 
Cin                 <= control_sig(5); 
mod1RegLd           <= control_sig(4); 
mod1RegCl           <= control_sig(3); 
mod3RegLd           <= control_sig(2); 
mod3RegCl           <= control_sig(1); 
Done                <= control_sig(0);


end Behavioral;

