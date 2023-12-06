ENTITY main IS PORT (
	keyboard_input_data	:	IN	BIT_VECTOR(8 DOWNTO 0);
	clock			:	IN	BIT;
	reset			:	IN	BIT;
	decoder_output_data_1	:	OUT	BIT_VECTOR(6 DOWNTO 0);
	decoder_output_data_2	:	OUT	BIT_VECTOR(6 DOWNTO 0);
	decoder_output_data_3	:	OUT	BIT_VECTOR(6 DOWNTO 0);
	decoder_output_data_4	:	OUT	BIT_VECTOR(6 DOWNTO 0);
	decoder_output_data_5	:	OUT	BIT_VECTOR(6 DOWNTO 0);
	decoder_output_data_6	:	OUT	BIT_VECTOR(6 DOWNTO 0);
	decoder_output_data_7	:	OUT	BIT_VECTOR(6 DOWNTO 0);
	decoder_output_data_8	:	OUT	BIT_VECTOR(6 DOWNTO 0);
	decoder_output_data_9	:	OUT	BIT_VECTOR(6 DOWNTO 0));
END main;

ARCHITECTURE arch OF main IS
	 -- Declaração de sinais internos necessários
	SIGNAL keyboard_coder_output    : BIT_VECTOR(3 DOWNTO 0);
   	SIGNAL keyboard_register_output_a : BIT_VECTOR(3 DOWNTO 0);
    	SIGNAL keyboard_register_output_b : BIT_VECTOR(3 DOWNTO 0);
    	SIGNAL state_machine_keyboard_register_enable : BIT;
    	SIGNAL state_machine_comparator_enable : BIT;
    	SIGNAL state_machine_initialize_memory : BIT;
    	SIGNAL comparator_result : BIT;

    	SIGNAL display_decoder_input_1 : BIT_VECTOR(3 DOWNTO 0);
	SIGNAL display_decoder_input_2 : BIT_VECTOR(3 DOWNTO 0);
	SIGNAL display_decoder_input_3 : BIT_VECTOR(3 DOWNTO 0);
	SIGNAL display_decoder_input_4 : BIT_VECTOR(3 DOWNTO 0);
	SIGNAL display_decoder_input_5 : BIT_VECTOR(3 DOWNTO 0);
	SIGNAL display_decoder_input_6 : BIT_VECTOR(3 DOWNTO 0);
	SIGNAL display_decoder_input_7 : BIT_VECTOR(3 DOWNTO 0);
	SIGNAL display_decoder_input_8 : BIT_VECTOR(3 DOWNTO 0);
	SIGNAL display_decoder_input_9 : BIT_VECTOR(3 DOWNTO 0);

    	SIGNAL display_decoder_output_1 : BIT_VECTOR(6 DOWNTO 0);
   	SIGNAL display_decoder_output_2 : BIT_VECTOR(6 DOWNTO 0);
    	SIGNAL display_decoder_output_3 : BIT_VECTOR(6 DOWNTO 0);
    	SIGNAL display_decoder_output_4 : BIT_VECTOR(6 DOWNTO 0);
    	SIGNAL display_decoder_output_5 : BIT_VECTOR(6 DOWNTO 0);
    	SIGNAL display_decoder_output_6 : BIT_VECTOR(6 DOWNTO 0);
    	SIGNAL display_decoder_output_7 : BIT_VECTOR(6 DOWNTO 0);
    	SIGNAL display_decoder_output_8 : BIT_VECTOR(6 DOWNTO 0);
    	SIGNAL display_decoder_output_9 : BIT_VECTOR(6 DOWNTO 0);
    	SIGNAL game_memory_output : BIT_VECTOR(3 DOWNTO 0);
	
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
		register_full	:	OUT	BIT);
	END COMPONENT keyboard_register;
	
	-- Máquina de estados
	COMPONENT state_machine IS PORT (
		clock			:	IN	BIT;
		reset			:	IN	BIT;
		keyboard_register_full	:	IN	BIT;
		comparator_result	:	IN	BIT;
		keyboard_register_enable:	OUT	BIT;
		comparator_enable	:	OUT	BIT;
		initialize_memory	:	OUT	BIT);
	END COMPONENT state_machine;

	-- Comparador de valores
	COMPONENT comparator IS PORT (
		enable		:	IN	BIT;
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
		initialize	:	IN	BIT;
		address		:	IN 	BIT_VECTOR(3 DOWNTO 0);
		read_enable	:	IN 	BIT;
		write_enable	:	IN 	BIT;
		input_data	:	IN 	BIT_VECTOR(3 DOWNTO 0);
		output_data	:	OUT 	BIT_VECTOR(3 DOWNTO 0));
	END COMPONENT game_memory;

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
			register_full       => keyboard_register_read_enable
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

	keyboard_coder_inst : keyboard_coder
    	PORT MAP (
        	input_data  => keyboard_input_data,
        	output_data => keyboard_coder_output
    	);

    	keyboard_register_inst : keyboard_register
    	PORT MAP (
       		clock               => clock,
        	reset               => reset,
        	enable              => state_machine_keyboard_register_enable,
        	input_data          => keyboard_coder_output,
        	output_data_a       => keyboard_register_output_a,
        	output_data_b       => keyboard_register_output_b,
        	register_full       => state_machine_keyboard_register_full
    	);

    	state_machine_inst : state_machine
    	PORT MAP (
        	clock                      => clock,
        	reset                      => reset,
        	keyboard_register_full     => state_machine_keyboard_register_full,
        	comparator_result          => comparator_result,
        	keyboard_register_enable   => state_machine_keyboard_register_enable,
        	comparator_enable          => state_machine_comparator_enable,
        	initialize_memory          => state_machine_initialize_memory
    	);

    	comparator_inst : comparator
    	PORT MAP (
        	enable          => state_machine_comparator_enable,
        	input_data_a    => keyboard_register_output_a,
        	input_data_b    => keyboard_register_output_b,
        	result          => comparator_result
    	);

    	display_decoder_inst_1 : display_decoder
    	PORT MAP (
		input_data  => display_decoder_input_1,
       	 	output_data => display_decoder_output_1
    	);

	display_decoder_inst_2 : display_decoder
    	PORT MAP (
       		input_data  => display_decoder_input_2,
        	output_data => display_decoder_output_2
    	);

	display_decoder_inst_3 : display_decoder
    	PORT MAP (
        	input_data  => display_decoder_input_3,
        	output_data => display_decoder_output_3
    	);

	display_decoder_inst_4 : display_decoder
    	PORT MAP (
        	input_data  => display_decoder_input_4,
        	output_data => display_decoder_output_4
    	);

	display_decoder_inst_5 : display_decoder
    	PORT MAP (
        	input_data  => display_decoder_input_5,
        	output_data => display_decoder_output_5
   	 );

	display_decoder_inst_6 : display_decoder
   	PORT MAP (
        	input_data  => display_decoder_input_6,
        	output_data => display_decoder_output_6
    	);

	display_decoder_inst_7 : display_decoder
    	PORT MAP (
        	input_data  => display_decoder_input_7,
        	output_data => display_decoder_output_7
   	);

	display_decoder_inst_8 : display_decoder
   	PORT MAP (
        	input_data  => display_decoder_input_8,
        	output_data => display_decoder_output_8
    	);

	display_decoder_inst_9 : display_decoder
    	PORT MAP (
       	 	input_data  => display_decoder_input_9,
        	output_data => display_decoder_output_9
    	);

    game_memory_inst : game_memory
    PORT MAP (
        initialize  => state_machine_initialize_memory,
        address     => state_machine_memory_address,
        read_enable => state_machine_memory_read_enable,
        write_enable=> state_machine_memory_write_enable,
        input_data  => keyboard_register_output_a,
        output_data => game_memory_output
    );

    -- Conectando os sinais dos decoders aos sinais de saída da entidade
    decoder_output_data_1 <= display_decoder_output_1;
    decoder_output_data_2 <= display_decoder_output_2;
    decoder_output_data_3 <= display_decoder_output_3;
    decoder_output_data_4 <= display_decoder_output_4;
    decoder_output_data_5 <= display_decoder_output_5;
    decoder_output_data_6 <= display_decoder_output_6;
    decoder_output_data_7 <= display_decoder_output_7;
    decoder_output_data_8 <= display_decoder_output_8;
    decoder_output_data_9 <= display_decoder_output_9;
END arch;