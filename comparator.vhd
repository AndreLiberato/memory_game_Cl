ENTITY comparator IS PORT (
	enable		:	IN	BIT;
	input_data_a	:	IN	BIT_VECTOR(3 DOWNTO 0);
	input_data_b	:	IN	BIT_VECTOR(3 DOWNTO 0);
	result		:	OUT	BIT);
END comparator;

ARCHITECTURE behavioral OF comparator IS
BEGIN
    PROCESS(input_data_a, input_data_b)
    BEGIN
	IF (enable = '1') THEN
		IF input_data_a = input_data_b THEN 
			result <= '1'; 
		ELSE
			result <= '0'; 
		END IF;
	END IF;
    END PROCESS;
END behavioral;
