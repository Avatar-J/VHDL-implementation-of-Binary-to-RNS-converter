----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:02:13 07/24/2023 
-- Design Name: 
-- Module Name:    Forward_converter_dp - Behavioral 
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


entity Forward_converter_dp is
    generic(
        n  : integer  := 5
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
end Forward_converter_dp;

architecture Behavioral of Forward_converter_dp is

    constant third_modulo       : integer := (2 ** n) + 1;
    constant one                : integer := 1;
    constant zero               :integer  := 0;


    signal i_one                :std_logic_vector(n+1 downto 0);
    signal third_mod            :std_logic_vector(n+1 downto 0);
    signal all_zeros            :std_logic_vector(n+1 downto 0);


    signal tmp_input_reg        : STD_LOGIC_VECTOR((3 * n)-1 downto 0);

    signal block0               : STD_LOGIC_VECTOR(n-1 downto 0);
    signal block1               : STD_LOGIC_VECTOR((2*n)-1 downto n);
    signal block2               : STD_LOGIC_VECTOR((3*n)-1 downto (2*n));

    signal third_reg_input      : STD_LOGIC_VECTOR(n+1 downto 0);

    signal tmp_input_reg_B2, tmp_input_reg_B0, tmp_input_reg_B1                  : STD_LOGIC_VECTOR(n+1 downto 0);
    signal tmp_output_1st_mod, tmp_output_3rd_mod, tmp_output_2nd_mod            : STD_LOGIC_VECTOR(n+1 downto 0);
    signal mux0_output, mux1_output, tmp_adder_output                            : STD_LOGIC_VECTOR(n+1 downto 0);

    signal tmp_output_1st_mod_n  :STD_LOGIC_VECTOR(n+1 downto 0);


    signal allones_tmp          : std_logic_vector(n+1 downto 0) := (others => '1');
    signal or_tmp               : std_logic_vector(n+1 downto 0) := (others => '0'); 



    component INPUT_REG_GENERIC
    generic (n: positive := 5);
    port(
        D           : in STD_LOGIC_VECTOR((3 * n)-1  downto 0);
        R, L, CLK   : IN STD_LOGIC;
        Q           : out STD_LOGIC_VECTOR((3 * n)-1 downto 0)
    );
    end component;


    component gen_mod_reg is
        generic (
            n: positive := 5
            );
        port(
            D           : in STD_LOGIC_VECTOR(n+1  downto 0);
            R, L, CLK   : IN STD_LOGIC;
            Q           : out STD_LOGIC_VECTOR(n+1 downto 0)
        );
    end component;


    component Mux0 
    generic(n: positive:= 5);
    port(
        INPUT0, INPUT1, INPUT2, INPUT3      : IN STD_LOGIC_VECTOR(n+1 downto 0);
        SEL                                 : IN STD_LOGIC_VECTOR(1 downto 0);
        OUTPUT                              : OUT STD_LOGIC_VECTOR(n+1 downto 0)
    );
    end component;



    component Mux1 
        generic(n: positive:= 5);
        port(
            INPUT0, INPUT1, INPUT2, INPUT3, INPUT4, INPUT5, INPUT6, INPUT7  : IN STD_LOGIC_VECTOR(n+1 downto 0);
            SEL                                                             : IN STD_LOGIC_VECTOR(2 downto 0);
            OUTPUT                                                          : OUT STD_LOGIC_VECTOR(n+1 downto 0)
        );
    end component;



    component ADDER_GENERIC
        generic(n  : integer  := 5 );
        port(
            A, B        : IN STD_LOGIC_VECTOR(n+1 downto 0);
            Cin         : IN STD_LOGIC;
            Cout        : OUT STD_LOGIC;
            Y           : OUT STD_LOGIC_VECTOR(n+1 downto 0)
        );
    end component;


    component Tri_state_buffer is
        generic (n: positive := 5);
        port(
            input           : in std_logic_vector(n downto 0);
            done            : in std_logic;
            output          : out std_logic_vector(n downto 0)
    );
    end component;

    

begin

    INPUTREG: INPUT_REG_GENERIC generic map(n) port map(
        D       => INPUT,
        R       => input_reset, 
        L       => input_load, 
        CLK     => CLK,
        Q       => tmp_input_reg
    ); 


    --block sizes
    block0  <= tmp_input_reg(n-1 downto 0);
    block1  <= tmp_input_reg((2*n)-1 downto n);
    block2  <= tmp_input_reg((3*n)-1 downto (2*n));


    tmp_input_reg_B2   <=  "00" & block2;
    tmp_input_reg_B0   <=  "00" & block0;
    tmp_input_reg_B1   <=  "00" & block1;

    

    MUTIPLEXER_0: Mux0 generic map(n) port map(
        INPUT0      => tmp_input_reg_B2, 
        INPUT1      => tmp_output_1st_mod_n, 
        INPUT2      => tmp_output_3rd_mod, 
        INPUT3      => tmp_input_reg_B0,  
        SEL         => mux_0,
        OUTPUT      => mux0_output
    );


    -- converts constants to binary inputs for mux
    i_one       <= std_logic_vector(to_unsigned(one, i_one'length));
    third_mod   <= std_logic_vector(to_unsigned(third_modulo, third_mod'length));
    all_zeros   <= std_logic_vector(to_unsigned(zero, all_zeros'length));



    MUTIPLEXER_1: Mux1 generic map(n) port map(
        INPUT0      => tmp_input_reg_B1,
        INPUT1      => tmp_output_3rd_mod, 
        INPUT2      => i_one,
        INPUT3      => tmp_input_reg_B0, 
        INPUT4      => third_mod, 
        INPUT5      => all_zeros, 
        INPUT6      => all_zeros, 
        INPUT7      => all_zeros, 
        SEL         => mux_1,
        OUTPUT      => mux1_output
    );

    ADDER0: ADDER_GENERIC generic map(n) port map(
        A       => mux0_output, 
        B       => mux1_output,
        Cin     => Cin,
        Cout    => Cout,
        Y       => tmp_adder_output
    );

    --Takes n bits from 1st mod reg and concatenates zeros so that carry out does not affect result
    tmp_output_1st_mod_n  <= "00" & tmp_output_1st_mod(n-1 downto 0);

    MOD_ONE_REG: gen_mod_reg generic map(n) port map(
        D       => tmp_adder_output,
        R       => mod1_reset, 
        L       => mod1_load, 
        CLK     => CLK,
        Q       => tmp_output_1st_mod
    );

    T_state_buffer_mod1: Tri_state_buffer generic map(n) port map(
        input           => tmp_output_1st_mod(n downto 0),
        done            => done1,
        output          => OUTPUT1
    );

    --output of second modulo
    third_reg_input  <= "00" & block0;

    MOD_TWO_REG: gen_mod_reg generic map(n) port map(
        D       => third_reg_input,
        R       => mod2_reset, 
        L       => mod2_load, 
        CLK     => CLK,
        Q       => tmp_output_2nd_mod
    );

    T_state_buffer_mod2: Tri_state_buffer generic map(n) port map(
        input           => tmp_output_2nd_mod(n downto 0),
        done            => done2,
        output          => OUTPUT2
    );

    MOD_THREE_REG: gen_mod_reg generic map(n) port map(
        D       => tmp_adder_output,
        R       => mod3_reset, 
        L       => mod3_load, 
        CLK     => CLK,
        Q       => tmp_output_3rd_mod
    );

    T_state_buffer_mod3: Tri_state_buffer generic map(n) port map(
        input           => tmp_output_3rd_mod(n downto 0),
        done            => done3,
        output          => OUTPUT3
    );
   

    --status signals

    allones_1 : for i in 1 to n generate
        allones_tmp(i) <= allones_tmp(i-1) and tmp_output_1st_mod(i-1);
    end generate;

    allones <= allones_tmp(n);


    greater_than: for i in 1 to n generate
        or_tmp(i) <= or_tmp(i-1) or tmp_output_3rd_mod(i-1);
    end generate;

    grt_than_8_status <= or_tmp(n) and tmp_output_3rd_mod(n);

    neg_status  <= tmp_output_3rd_mod(n+1);


end Behavioral;

