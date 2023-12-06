ENTITY main IS PORT (
	keyboard_input_data	:	IN	BIT_VECTOR(8 DOWNTO 0);
	clock			:	IN	BIT;
	reset			:	IN	BIT;
	display_output_data_1	:	OUT	BIT_VECTOR(6 DOWNTO 0);
	display_output_data_2	:	OUT	BIT_VECTOR(6 DOWNTO 0);
	display_output_data_3	:	OUT	BIT_VECTOR(6 DOWNTO 0);
	display_output_data_4	:	OUT	BIT_VECTOR(6 DOWNTO 0);
	display_output_data_5	:	OUT	BIT_VECTOR(6 DOWNTO 0);
	display_output_data_6	:	OUT	BIT_VECTOR(6 DOWNTO 0);
	display_output_data_7	:	OUT	BIT_VECTOR(6 DOWNTO 0);
	display_output_data_8	:	OUT	BIT_VECTOR(6 DOWNTO 0);
	display_output_data_9	:	OUT	BIT_VECTOR(6 DOWNTO 0));
END main;

ARCHITECTURE arch OF main IS
	
	-- Codificador do teclado
	COMPONENT keyboard_coder IS PORT (
		input_data	:	IN	BIT_VECTOR(8 DOWNTO 0);
		output_data	:	OUT	BIT_VECTOR(3 DOWNTO 0));
	END COMPONENT keyboard_coder;

	-- Registrador do teclado
	COMPONENT keyboard_register IS PORT(
		clock		:	IN 	BIT;
		reset		:	IN 	BIT;
		enable		:	IN 	BIT;
		input_data	:	IN 	BIT_VECTOR(3 DOWNTO 0);
		output_data_a	:	OUT 	BIT_VECTOR(3 DOWNTO 0);
		output_data_b	:	OUT 	BIT_VECTOR(3 DOWNTO 0);
		read_enable	:	OUT	BIT);
	END COMPONENT keyboard_register;
	
	-- Máquina de estados
	COMPONENT state_machine IS PORT (
		clock			:	IN	BIT;
		reset			:	IN	BIT;
		keyboard_register_full	:	IN	BIT;
		equals			:	IN	BIT;
		keyboard_register_enable:	OUT	BIT;
		comparator_enable	:	OUT	BIT);
	END COMPONENT state_machine;

	-- Comparador de valores
	COMPONENT comparator IS PORT (
		input_data_a	:	IN	BIT_VECTOR(3 DOWNTO 0);
		input_data_b	:	IN	BIT_VECTOR(3 DOWNTO 0);
		result		:	OUT	BIT);
	END COMPONENT comparator;

	-- Decodificador do display
	COMPONENT display_decoder IS PORT (
		input_data	:	IN	BIT_VECTOR(3 DOWNTO 0);
		output_data	:	OUT	BIT_VECTOR(6 DOWNTO 0));
	END COMPONENT display_decoder;

	-- Memória do jogo
	COMPONENT game_memory IS PORT(
		address		:	IN 	BIT_VECTOR(3 DOWNTO 0);
		read_enable	:	IN 	BIT;
		write_enable	:	IN 	BIT;
		input_data	:	IN 	BIT_VECTOR(3 DOWNTO 0);
		output_data	:	OUT 	BIT_VECTOR(3 DOWNTO 0));
	END COMPONENT game_memory;
	
	-- Definição dos sinais
	SIGNAL keyboard_coder_output : BIT_VECTOR(3 DOWNTO 0);
	SIGNAL keyboard_register_output_a : BIT_VECTOR(3 DOWNTO 0);
	SIGNAL keyboard_register_output_b : BIT_VECTOR(3 DOWNTO 0);
	SIGNAL keyboard_register_read_enable : BIT;
	SIGNAL state_machine_keyboard_register_full : BIT;
	SIGNAL state_machine_equals : BIT;
	SIGNAL state_machine_keyboard_register_enable : BIT;
	SIGNAL state_machine_comparator_enable : BIT;
	SIGNAL comparator_result : BIT;
	SIGNAL display_decoder_input : BIT_VECTOR(3 DOWNTO 0);
	SIGNAL game_memory_address : BIT_VECTOR(3 DOWNTO 0);
	SIGNAL game_memory_read_enable : BIT;
	SIGNAL game_memory_write_enable : BIT;
	SIGNAL game_memory_input_data : BIT_VECTOR(3 DOWNTO 0);
	SIGNAL game_memory_output_data : BIT_VECTOR(3 DOWNTO 0);

BEGIN
	-- Conexões dos componentes
	keyboard_coder_instance: keyboard_coder
		PORT MAP (
			input_data  => keyboard_input_data,
			output_data => keyboard_coder_output
		);

	keyboard_register_instance: keyboard_register
		PORT MAP (
			clock             => clock,
			reset             => reset,
			enable            => state_machine_keyboard_register_enable,
			input_data        => keyboard_coder_output,
			output_data_a     => keyboard_register_output_a,
			output_data_b     => keyboard_register_output_b,
			read_enable       => keyboard_register_read_enable
		);

	state_machine_instance: state_machine
		PORT MAP (
			clock                   => clock,
			reset                   => reset,
			keyboard_register_full => keyboard_register_read_enable,
			equals                 => comparator_result,
			keyboard_register_enable=> state_machine_keyboard_register_enable,
			comparator_enable      => state_machine_comparator_enable
		);

	comparator_instance: comparator
		PORT MAP (
			input_data_a => keyboard_register_output_a,
			input_data_b => keyboard_register_output_b,
			result       => comparator_result
		);

	display_decoder_instance: display_decoder
		PORT MAP (
			input_data  => display_decoder_input,
			output_data => display_output_data_1 -- Substitua pelo número de display correspondente
		);

	game_memory_instance: game_memory
		PORT MAP (
			address     => game_memory_address,
			read_enable => game_memory_read_enable,
			write_enable=> game_memory_write_enable,
			input_data  => game_memory_input_data,
			output_data => game_memory_output_data
		);

	-- Lógica principal do jogo aqui...
END arch;