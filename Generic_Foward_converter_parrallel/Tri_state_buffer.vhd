----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:15:53 07/26/2023 
-- Design Name: 
-- Module Name:    Tri_state_buffer - Behavioral 
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



entity Tri_state_buffer is
    generic (n: positive := 3);
    port(
        input           : in std_logic_vector(n downto 0);
        done            : in std_logic;
        output          : out std_logic_vector(n downto 0)
);
end Tri_state_buffer;

architecture Behavioral of Tri_state_buffer is

begin

    output <= input when done = '1' else
					(others => '0');


end Behavioral;

