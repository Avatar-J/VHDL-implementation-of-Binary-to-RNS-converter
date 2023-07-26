----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    07:47:05 07/21/2023 
-- Design Name: 
-- Module Name:    Mux0 - Behavioral 
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

entity Mux0 is
    generic(n: positive:= 3);
    port(
        INPUT0, INPUT1, INPUT2, INPUT3      : IN STD_LOGIC_VECTOR(n+1 downto 0);
        SEL                                 : IN STD_LOGIC_VECTOR(1 downto 0);
        OUTPUT                              : OUT STD_LOGIC_VECTOR(n+1 downto 0)
    );
end Mux0;

architecture Behavioral of Mux0 is

begin
    with SEL select OUTPUT <=   INPUT0 when "00", 
                                INPUT1 when "01", 
                                INPUT2 when "10", 
                                INPUT3 when others;


end Behavioral;

