ENTITY game_render IS PORT (
	render_enable	:	IN	BIT;
	input_data	:	IN	BIT_VECTOR(3 DOWNTO 0);
	address		:	OUT	BIT_VECTOR(3 DOWNTO 0);
	read_enable	:	OUT 	BIT;
	output_data_1	:	OUT	BIT_VECTOR(3 DOWNTO 0);
	output_data_2	:	OUT	BIT_VECTOR(3 DOWNTO 0);
	output_data_3	:	OUT	BIT_VECTOR(3 DOWNTO 0);
	output_data_4	:	OUT	BIT_VECTOR(3 DOWNTO 0);
	output_data_5	:	OUT	BIT_VECTOR(3 DOWNTO 0);
	output_data_6	:	OUT	BIT_VECTOR(3 DOWNTO 0);
	output_data_7	:	OUT	BIT_VECTOR(3 DOWNTO 0);
	output_data_8	:	OUT	BIT_VECTOR(3 DOWNTO 0);
	output_data_9	:	OUT	BIT_VECTOR(3 DOWNTO 0));
END game_render;

ARCHITECTURE behavioral OF game_render IS
	TYPE	data IS ARRAY(0 TO 8) OF BIT_VECTOR(3 DOWNTO 0);
	SIGNAL	address_internal	:	BIT_VECTOR(3 DOWNTO 0) := "0000";
	SIGNAL	data_internal		:	data	:= (OTHERS => (OTHERS => '0'));
BEGIN
	PROCESS (render_enable)
	BEGIN
		IF render_enable = '1' THEN
			read_enable <= '1';

			FOR i IN 0 TO 8 LOOP
				address_internal <= address_internal(2 DOWNTO 0) & '0';
				address <= address_internal;
				data_internal(i) <= input_data;
			END LOOP;

			output_data_1 <= data_internal(0);
			output_data_2 <= data_internal(1);
			output_data_3 <= data_internal(2);
			output_data_4 <= data_internal(3);
			output_data_5 <= data_internal(4);
			output_data_6 <= data_internal(5);
			output_data_7 <= data_internal(6);
			output_data_8 <= data_internal(7);
			output_data_9 <= data_internal(8);
		ELSE
			read_enable <= '0';
			address_internal <= "0000";
		END IF;
	END PROCESS;
END behavioral;
