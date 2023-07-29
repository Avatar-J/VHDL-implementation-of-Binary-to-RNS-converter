----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    07:51:51 07/21/2023 
-- Design Name: 
-- Module Name:    Mux1 - Behavioral 
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

entity Mux1 is
    generic(n: positive:= 5);
    port(
        INPUT0, INPUT1, INPUT2, INPUT3, INPUT4, INPUT5, INPUT6, INPUT7  : STD_LOGIC_VECTOR(n+1 downto 0);
        SEL                                                             : IN STD_LOGIC_VECTOR(2 downto 0);
        OUTPUT                                                          : OUT STD_LOGIC_VECTOR(n+1 downto 0)
    );
end Mux1;

architecture Behavioral of Mux1 is

begin
    with SEL select OUTPUT <=   INPUT0 when "000", 
                                INPUT1 when "001", 
                                INPUT2 when "010", 
                                INPUT3 when "011",
                                INPUT4 when "100", 
                                INPUT5 when "101", 
                                INPUT6 when "110", 
                                INPUT7 when "111",
                                (others => 'Z') when others;


end Behavioral;

