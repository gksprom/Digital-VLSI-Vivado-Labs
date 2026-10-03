----------------------------------------------------------------------------------
--DEMUX 3 TO 8
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity mux_3_to_8_behavioral is
    port (
        enc : in std_logic_vector(3-1 downto 0);
        dec : out std_logic_vector(8-1 downto 0)
    );
    
end entity;

architecture behavioral_arch of mux_3_to_8_behavioral is

begin
    
    DEMUX_MODULE : process(enc)
    begin
        case enc is
            when "000"=>
                dec<="00000001";
             when "001"=>
                dec<="00000010";
             when "010"=>
                dec<="00000100";
             when "011"=>
                dec<="00001000";
             when "100"=>
                dec<="00010000";
             when "101"=>
                dec<="00100000";
             when "110"=>
                dec<="01000000";
             when "111"=>
                dec<="10000000";
             when others=>
                dec<="00000000";
       end case;
   end process;

end behavioral_arch;
