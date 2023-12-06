ENTITY game_memory IS PORT(
	address		:	IN 	BIT_VECTOR(3 DOWNTO 0);
	read_enable	:	IN 	BIT;
	write_enable	:	IN 	BIT;
	input_data	:	IN 	BIT_VECTOR(3 DOWNTO 0);
	output_data	:	OUT 	BIT_VECTOR(3 DOWNTO 0));
END game_memory;

ARCHITECTURE behavioral OF game_memory IS
	TYPE	memory_array IS ARRAY(0 TO 8) OF BIT_VECTOR(3 DOWNTO 0);
	SIGNAL	memory	:	memory_array	:= (OTHERS => (OTHERS => '0'));
BEGIN
	PROCESS(address, read_enable, write_enable, input_data)
	BEGIN
		IF (read_enable'EVENT AND read_enable = '1') THEN
			CASE address IS
           			WHEN "0000" => output_data <= memory(0);
            			WHEN "0001" => output_data <= memory(1);
            			WHEN "0010" => output_data <= memory(2);
            			WHEN "0011" => output_data <= memory(3);
            			WHEN "0100" => output_data <= memory(4);
            			WHEN "0101" => output_data <= memory(5);
            			WHEN "0110" => output_data <= memory(6);
            			WHEN "0111" => output_data <= memory(7);
				WHEN "1000" => output_data <= memory(8);
				WHEN OTHERS => NULL;
        		END CASE;
		ELSIF (write_enable'EVENT AND write_enable = '1') THEN
			CASE address IS
				WHEN "0000" => memory(0) <= input_data;
				WHEN "0001" => memory(1) <= input_data;
				WHEN "0010" => memory(2) <= input_data;
				WHEN "0011" => memory(3) <= input_data;
				WHEN "0100" => memory(4) <= input_data;
				WHEN "0101" => memory(5) <= input_data;
				WHEN "0110" => memory(6) <= input_data;
				WHEN "0111" => memory(7) <= input_data;
				WHEN "1000" => memory(8) <= input_data;
				WHEN OTHERS => NULL;
			END CASE;
		END IF;
	END PROCESS;
END behavioral;