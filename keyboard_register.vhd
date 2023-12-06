ENTITY keyboard_register IS PORT(
	clock		:	IN 	BIT;
	reset		:	IN 	BIT;
	enable		:	IN 	BIT;
	input_data	:	IN 	BIT_VECTOR(3 DOWNTO 0);
	output_data_a	:	OUT 	BIT_VECTOR(3 DOWNTO 0);
	output_data_b	:	OUT 	BIT_VECTOR(3 DOWNTO 0);
	register_full	:	OUT	BIT);
END keyboard_register;

ARCHITECTURE behavioral OF keyboard_register IS
	TYPE	register_state IS (write_a, write_b, done);
	SIGNAL	state	:	register_state		:= write_a;
	SIGNAL	data_a	:	BIT_VECTOR(3 DOWNTO 0)	:= "0000";
	SIGNAL	data_b	:	BIT_VECTOR(3 DOWNTO 0)	:= "0000";
BEGIN 
	PROCESS(clock, reset, enable, input_data) 
	BEGIN
		IF (reset = '0') THEN
			data_a <= "0000";
			data_b <= "0000";
			state <= write_a;
			register_full <= '0';
		ELSIF (clock'EVENT AND clock = '1') THEN
			IF (enable = '1' AND input_data /= "0000") THEN
				CASE state IS
					WHEN write_a =>
						data_a <= input_data;
						state <= write_b;
					WHEN write_b =>
						data_b <= input_data;
						state <= done;
					WHEN done =>
						output_data_a <= data_a;
						output_data_b <= data_b;
						register_full <= '1';
						state <= write_a;
				END CASE;
			END IF;
		END IF;
	END PROCESS;
END behavioral;