----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:39:37 07/26/2023 
-- Design Name: 
-- Module Name:    gen_mod_reg - Behavioral 
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
use IEEE.MATH_REAL.ALL;



entity gen_mod_reg is
    generic (
        n: positive := 3
        );
    port(
        D           : in STD_LOGIC_VECTOR(n+1  downto 0);
        R, L, CLK   : IN STD_LOGIC;
        Q           : out STD_LOGIC_VECTOR(n+1 downto 0)
    );
end gen_mod_reg;

architecture Behavioral of gen_mod_reg is

    signal tmp_d    : STD_LOGIC_VECTOR(n+1 downto 0);

begin

    REG_GENERIC: process(CLK, tmp_d)
    begin
        if (rising_edge(CLK)) then

            if (R = '1') then
                tmp_d <= std_logic_vector(to_unsigned(integer(0), tmp_d'length));
            elsif(R = '0') then
                if (L = '1') then
                    tmp_d <= D;
                elsif(L = '0') then
                    tmp_d <= tmp_d;
                end if ;
            end if ;

        end if ; 
        
            Q <= tmp_d;
    end process ; 


end Behavioral;

