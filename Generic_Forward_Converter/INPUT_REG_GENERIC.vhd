----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:59:04 07/26/2023 
-- Design Name: 
-- Module Name:    INPUT_REG_GENERIC - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;



entity INPUT_REG_GENERIC is
    generic (n: positive := 3);
    port(
        D: in STD_LOGIC_VECTOR((3 * n)-1  downto 0);
        R, L, CLK: IN STD_LOGIC;
        Q: out STD_LOGIC_VECTOR((3 * n)-1 downto 0)
    );
end INPUT_REG_GENERIC;

architecture Behavioral of INPUT_REG_GENERIC is

    signal tmp_d: STD_LOGIC_VECTOR((3 * n)-1 downto 0);

begin

    REG_GENERIC: process(CLK, tmp_d)
    begin
        if (rising_edge(CLK)) then

            if (R = '1') then
                tmp_d <= std_logic_vector(to_unsigned(integer(0), tmp_d'length));	--reset to 0
            elsif(R = '0') then
                if (L = '1') then
                    tmp_d <= D;
                elsif(L = '0') then
                    tmp_d <= tmp_d;
                end if ;
            end if ;

        end if ; 
            Q <= tmp_d;
    end process ; -- D_FF


end Behavioral;

