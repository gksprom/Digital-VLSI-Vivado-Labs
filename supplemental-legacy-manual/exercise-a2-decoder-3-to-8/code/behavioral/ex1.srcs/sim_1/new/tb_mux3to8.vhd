library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity tb_mux3to8 is
end entity;

architecture tb of tb_mux3to8 is 

-----COMPONENT

component mux_3_to_8_behavioral is
    port (
        enc : in std_logic_vector(3-1 downto 0);
        dec : out std_logic_vector(8-1 downto 0)
    );
end component;


---SIGNALS
signal enc      : std_logic_vector(3-1 downto 0) := (others => '0');
signal dec      : std_logic_vector(8-1 downto 0);


constant DELAY : time :=10ns;

begin 

    DUT : mux_3_to_8_behavioral
        port map (
            enc =>enc,
            dec=> dec
        );
    STIIMULUS : process 
    begin 
    ---INITIALIZE SIGNALS
    
    enc<=(others=>'0');
    wait for(1*DELAY);
    
    --EXAMPLES 
    
            enc<= "000";
            wait for(1*DELAY);
                
            enc<= "001";
            wait for(1*DELAY);
              
            enc<= "010";
            wait for(1*DELAY);
             
            enc<= "011";
            wait for(1*DELAY);
             
            enc<= "100";
            wait for(1*DELAY);
             
            enc<= "101";
            wait for(1*DELAY);
               
            enc<= "110";
            wait for(1*DELAY);
            
            enc<= "111";
            wait for(1*DELAY);

-- EXAMPLE INPUTS 2
        for i in 0 to 7 loop
            enc <= std_logic_vector(to_unsigned(i, 3)); 
            wait for (1 * DELAY);
         end loop;
       

        enc <= (others => '0');
        wait for (1 * DELAY);
        
        wait;
    end process;
    end architecture;