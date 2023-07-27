----------------------------------------------------------------------------------
---------------------------------------ADDER-GENERIC------------------------------
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.math_real.all;
--library UNISIM;
--use UNISIM.VComponents.all;

entity ADDER_GENERIC is
    generic(
        n  : integer  := 5       
        );
    port(
        A, B        : IN STD_LOGIC_VECTOR(n+1 downto 0);
        Cin         : IN STD_LOGIC;
        Cout        : OUT STD_LOGIC;
        Y           : OUT STD_LOGIC_VECTOR(n+1 downto 0)
    );
end ADDER_GENERIC;

architecture Behavioral of ADDER_GENERIC is
    --internal signals
    signal tmp_adder : std_logic_vector(n+1 downto 0);

    begin
        process(A,B,Cin)
            begin
                if(Cin = '1') then
                    tmp_adder <= std_logic_vector(unsigned(A) - unsigned(B));
                else
                    tmp_adder <= std_logic_vector(unsigned(A) + unsigned(B));
                end if;
        end process;

    Cout <= tmp_adder(n); 
    Y    <= tmp_adder;





end Behavioral;

