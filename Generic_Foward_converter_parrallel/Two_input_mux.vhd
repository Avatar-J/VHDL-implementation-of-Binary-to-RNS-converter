----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:50:21 07/28/2023 
-- Design Name: 
-- Module Name:    Two_input_mux - Behavioral 
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

entity Two_input_mux is
    generic(n: positive:= 5);
    port(
        INPUT0, INPUT1      : IN STD_LOGIC_VECTOR(n+1 downto 0);
        SEL                 : IN STD_LOGIC;
        OUTPUT              : OUT STD_LOGIC_VECTOR(n+1 downto 0)
    );
end Two_input_mux;

architecture Behavioral of Two_input_mux is

begin
    with SEL select OUTPUT <=   INPUT0 when '0',  
                                INPUT1 when others;


end Behavioral;

