----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:48:44 07/25/2023 
-- Design Name: 
-- Module Name:    Forward_converter_Top_Model - Behavioral 
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

entity Forward_converter_Top_Model is
    generic(
            n  : integer  := 3       
            );
    port(
        CLK, RST                 : IN STD_LOGIC;
        INPUT                    : IN STD_LOGIC_VECTOR((3*n)-1 downto 0);
        
        DONE                     : OUT STD_LOGIC;
        OUTPUT1, OUTPUT2, OUTPUT3: OUT STD_LOGIC_VECTOR(n downto 0)
    );
end Forward_converter_Top_Model;

architecture Behavioral of Forward_converter_Top_Model is

    signal cout_sig, grt_than_8_status_sig, allones_sig, neg_status_sig : std_logic;

    signal mod1_load_sig, mod1_reset_sig, mod2_load_sig, mod2_reset_sig, mod3_load_sig, mod3_reset_sig, input_load_sig, input_reset_sig: std_logic;

    signal cin_sig, done_sig: std_logic;
    signal mux0_sig         : std_logic_vector(1 downto 0);
    signal mux1_sig         : std_logic_vector(2 downto 0);

    signal output_1st_mod   : std_logic_vector(n downto 0);

    component Forward_converter_dp
        generic(
            n  : integer  := 3       
            );
        port(
            INPUT                   : IN STD_LOGIC_VECTOR((3 * n)-1 downto 0);
            CLK                     : IN STD_LOGIC;
    
            --control signals
            input_load, input_reset, mod1_load, mod1_reset, mod2_load, mod2_reset, mod3_load, mod3_reset, Cin: IN STD_LOGIC;
            mux_1                   : IN STD_LOGIC_VECTOR(2 downto 0);
            mux_0                   : IN STD_LOGIC_VECTOR(1 downto 0);
            done1, done2, done3     : IN STD_LOGIC;
    
            --status signals
            allones, cout, grt_than_8_status, neg_status    : OUT STD_LOGIC;
            OUTPUT1, OUTPUT2, OUTPUT3                       : OUT STD_LOGIC_VECTOR(n downto 0)
            
        );
    end component;

    component Forward_converter_CU
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
    end component;

begin

    DP_Fconverter: Forward_converter_dp port map(
        INPUT               => INPUT,
        CLK                 => CLK,
        input_load          => input_load_sig, 
        input_reset         => input_reset_sig, 
        mod1_load           => mod1_load_sig, 
        mod1_reset          => mod1_reset_sig, 
        mod2_load           => mod2_load_sig, 
        mod2_reset          => mod2_reset_sig, 
        mod3_load           => mod3_load_sig, 
        mod3_reset          => mod3_reset_sig, 
        Cin                 => cin_sig,
        mux_1               => mux1_sig, 
        mux_0               => mux0_sig,
        done1               => done_sig, 
        done2               => done_sig, 
        done3               => done_sig,
        allones             => allones_sig, 
        cout                => cout_sig, 
        grt_than_8_status   => grt_than_8_status_sig,
        neg_status          => neg_status_sig,
        OUTPUT1             => output_1st_mod,
        OUTPUT2             => OUTPUT2,
        OUTPUT3             => OUTPUT3

    );

       OUTPUT1            <= '0' & output_1st_mod(n-1 downto 0);

    CU_Fconverter: Forward_converter_CU port map(
            clk                 => CLK,
            greater_than_one    => grt_than_8_status_sig,
            cout                => cout_sig,
            allones             => allones_sig,
            sign_bit_3rd_mod    => neg_status_sig,
            reset               => RST,
            mux0                => mux0_sig, 
            mux1                => mux1_sig,
            InputRegLd          => input_load_sig, 
            InputRegCl          => input_reset_sig, 
            mod2RegLd           => mod2_load_sig, 
            mod2RegCl           => mod2_reset_sig, 
            Cin                 => cin_sig, 
            mod1RegLd           => mod1_load_sig, 
            mod1RegCl           => mod1_reset_sig, 
            mod3RegLd           => mod3_load_sig, 
            mod3RegCl           => mod3_reset_sig, 
            Done                => done_sig
    );

    DONE  <= done_sig;

end Behavioral;

