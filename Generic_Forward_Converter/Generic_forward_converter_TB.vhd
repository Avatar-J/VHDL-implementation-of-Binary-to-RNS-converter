----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:33:24 07/26/2023 
-- Design Name: 
-- Module Name:    Generic_forward_converter_TB - Behavioral 
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
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.std_logic_textio.ALL;
USE ieee.numeric_std.ALL;

library STD;
USE STD.textio.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Generic_forward_converter_TB is
    generic(
        n  : integer  := 5       
        );
end Generic_forward_converter_TB;

architecture Behavioral of Generic_forward_converter_TB is

    --constant range       : integer := (2 ** n) - 1;
        
    signal INPUT : std_logic_vector((3*n)-1 downto 0);
    signal CLK : std_logic  :=  '0';
    signal RST : std_logic  :=  '0';
    signal DONE : std_logic := '0';

    signal OUTPUT1 : std_logic_vector(n downto 0);
    signal OUTPUT2 : std_logic_vector(n downto 0);
    signal OUTPUT3 : std_logic_vector(n downto 0);

    constant CLK_period : time := 10 ns;


    component Forward_converter_Top_Model is
        generic(
                n  : integer  := 5       
                );
        port(
            CLK, RST                 : IN STD_LOGIC;
            INPUT                    : IN STD_LOGIC_VECTOR((3*n)-1 downto 0);
            
            DONE                     : OUT STD_LOGIC;
            OUTPUT1, OUTPUT2, OUTPUT3: OUT STD_LOGIC_VECTOR(n downto 0)
        );
    end component;



begin

    uut: Forward_converter_Top_Model PORT MAP (
          INPUT => INPUT,
          CLK => CLK,
          RST => RST,
          DONE => DONE,
          OUTPUT1 => OUTPUT1,
          OUTPUT2 => OUTPUT2,
          OUTPUT3 => OUTPUT3
        );

    CLK_process :process
        begin
            CLK <= '0';
            wait for CLK_period/2;
            CLK <= '1';
            wait for CLK_period/2;
    end process;


--     stim_proc: process
--         begin		
      
--          wait for 20 ns;	

--          wait for CLK_period*10;

--          wait;
--    end process;


   STIMULUS : process
      file Fout: TEXT open WRITE_MODE is "RESULT_313233.txt";
      variable current_line: line;
   begin
      write(current_line, string'("TESTFILE FOR  FORWARD CONVERTER"));
      writeline(Fout, current_line);

      write(current_line, string'("      INPUT "));
      write(current_line, string'("                           1st_MOD "));
      write(current_line, string'("  2nd_MOD "));
      write(current_line, string'("  3rd_MOD "));
      writeline(Fout, current_line);
      write(current_line, string'(""));
      writeline(Fout, current_line);

      RST <= '1';
      wait for 10 ns;

      for i in 0 to 4079 loop
         RST <= '0';
         INPUT <= STD_LOGIC_VECTOR(to_unsigned(i, INPUT'length));
         wait until DONE = '1';
         wait until falling_edge(clk);

         
         write(current_line, to_integer(unsigned(INPUT)));
         write(current_line, string'(" RNS(313233) === "));
         write(current_line, to_integer(unsigned(OUTPUT1)));
         write(current_line, string'(" "));
         write(current_line, to_integer(unsigned(OUTPUT2)));
         write(current_line, string'(" "));
         write(current_line, to_integer(unsigned(OUTPUT3)));
         write(current_line, string'(" "));
        -- writeline(Fout, current_line);
        -- write(current_line, string'(" "));
        -- writeline(Fout, current_line);
         write(current_line, string'(" ---------------- "));
         --write(current_line, INPUT);
         --write(current_line, string'(" MOD 7 "));
         write(current_line, OUTPUT1);
         write(current_line, string'(" | "));
         --write(current_line, string'(" MOD 8 "));
         write(current_line, OUTPUT2);
         --write(current_line-- write(current, string'(" MOD 9 "));
         write(current_line, string'(" | "));
         write(current_line, OUTPUT3);
         write(current_line, string'(""));
         writeline(Fout, current_line);
         write(current_line, string'(""));
         writeline(Fout, current_line);

         RST <= '1';
         wait for CLK_period;
         if(INPUT = X"1FF") then
            wait; 
         end if;
      end loop;
      
   end process ; 


end Behavioral;

