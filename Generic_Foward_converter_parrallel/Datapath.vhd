----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:24:29 07/28/2023 
-- Design Name: 
-- Module Name:    Datapath - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Datapath is
    generic(
        n  : integer  := 5
        );
    port(
        INPUT                   : IN STD_LOGIC_VECTOR((3 * n)-1 downto 0);
        CLK                     : IN STD_LOGIC;

        --control signals
        input_load, input_reset, mod1_load, mod1_reset, mod2_load, mod2_reset, mod3_load, mod3_reset, Cin0,Cin1 : IN STD_LOGIC;
        mux_3, mux_1             : IN STD_LOGIC_VECTOR(1 downto 0);
        mux_0, mux_2             : IN STD_LOGIC;
        done1, done2, done3     : IN STD_LOGIC;

        --status signals
        allones, cout0, grt_than_8_status, neg_status    : OUT STD_LOGIC;
        OUTPUT1, OUTPUT2, OUTPUT3                       : OUT STD_LOGIC_VECTOR(n downto 0)
        
    );

end Datapath;

architecture Behavioral of Datapath is

    signal ground                  : STD_LOGIC;

    signal tmp_input_reg           : STD_LOGIC_VECTOR((3 * n)-1 downto 0);

    --multiplexer inputs
    signal block0                  : STD_LOGIC_VECTOR(n-1 downto 0);
    signal block1                  : STD_LOGIC_VECTOR((2*n)-1 downto n);
    signal block2                  : STD_LOGIC_VECTOR((3*n)-1 downto (2*n));
    signal result_feedback_1st_mod : STD_LOGIC_VECTOR(n+1 downto 0);

    --multiplexer and adder outputs
    signal mux0_output, mux1_output, mux2_output, mux3_output, tmp_adder0_output, tmp_adder1_output       : STD_LOGIC_VECTOR(n+1 downto 0);

    signal tmp_output_1st_mod, tmp_output_3rd_mod, tmp_output_2nd_mod            : STD_LOGIC_VECTOR(n+1 downto 0);

    --for status signals 
    signal allones_tmp          : std_logic_vector(n+1 downto 0) := (others => '1');
    signal or_tmp               : std_logic_vector(n+1 downto 0) := (others => '0');


    constant third_modulo       : integer := (2 ** n) + 1;
    constant one                : integer := 1;
    constant zero               :integer  := 0;

    --for constant conversion to binary
    signal i_one                :std_logic_vector(n+1 downto 0);
    signal third_mod            :std_logic_vector(n+1 downto 0);
    signal all_zeros            :std_logic_vector(n+1 downto 0);


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

    component Two_input_mux is
        generic(n: positive:= 5);
        port(
            INPUT0, INPUT1      : IN STD_LOGIC_VECTOR(n+1 downto 0);
            SEL                 : IN STD_LOGIC;
            OUTPUT              : OUT STD_LOGIC_VECTOR(n+1 downto 0)
        );
    end component;

    component Three_input_mux is
        generic(n: positive:= 5);
        port(
            INPUT0, INPUT1, INPUT2, INPUT3      : IN STD_LOGIC_VECTOR(n+1 downto 0);
            SEL                                 : IN STD_LOGIC_VECTOR(1 downto 0);
            OUTPUT                              : OUT STD_LOGIC_VECTOR(n+1 downto 0)
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
     block0  <= "00" & tmp_input_reg(n-1 downto 0);
     block1  <= "00" & tmp_input_reg((2*n)-1 downto n);
     block2  <= "00" & tmp_input_reg((3*n)-1 downto (2*n));

     --Takes n bits from 1st mod reg and concatenates zeros so that carry out does not affect result
    result_feedback_1st_mod  <= "00" & tmp_output_1st_mod(n-1 downto 0);
 
 
     MUTIPLEXER_0: Two_input_mux generic map(n) port map(
        INPUT0      => block2, 
        INPUT1      => result_feedback_1st_mod,  
        SEL         => mux_0,
        OUTPUT      => mux0_output
    );


    MUTIPLEXER_2: Two_input_mux generic map(n) port map(
        INPUT0      => block0, 
        INPUT1      => tmp_output_3rd_mod,  
        SEL         => mux_2,
        OUTPUT      => mux2_output
    );

    MUTIPLEXER_1: Three_input_mux generic map(n) port map(
        INPUT0      => block1, 
        INPUT1      => block0,  
        INPUT2      => i_one,
        INPUT3      => all_zeros,
        SEL         => mux_1,
        OUTPUT      => mux1_output
    );

     -- converts constants to binary inputs for mux
     i_one       <= std_logic_vector(to_unsigned(one, i_one'length));
     third_mod   <= std_logic_vector(to_unsigned(third_modulo, third_mod'length));
     all_zeros   <= std_logic_vector(to_unsigned(zero, all_zeros'length));
    
    MUTIPLEXER_3: Three_input_mux generic map(n) port map(
        INPUT0      => block1, 
        INPUT1      => block2,  
        INPUT2      => third_mod,
        INPUT3      => all_zeros,
        SEL         => mux_3,
        OUTPUT      => mux3_output
    );

    ADDER0: ADDER_GENERIC generic map(n) port map(
        A       => mux0_output, 
        B       => mux1_output,
        Cin     => Cin0,
        Cout    => Cout0,
        Y       => tmp_adder0_output
    );

    ADDER1: ADDER_GENERIC generic map(n) port map(
        A       => mux0_output, 
        B       => mux1_output,
        Cin     => Cin1,
        Cout    => ground,
        Y       => tmp_adder1_output
    );

    MOD_ONE_REG: gen_mod_reg generic map(n) port map(
        D       => tmp_adder0_output,
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

    MOD_TWO_REG: gen_mod_reg generic map(n) port map(
        D       => block0,
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
        D       => tmp_adder1_output,
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
   
    --status signal
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

