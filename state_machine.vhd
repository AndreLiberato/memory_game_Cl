ENTITY state_machine IS PORT (
	clock			:	IN	BIT;
	reset			:	IN	BIT;
	keyboard_register_full	:	IN	BIT;
	equals			:	IN	BIT;
	keyboard_register_enable:	OUT	BIT;
	comparator_enable	:	OUT	BIT);
END state_machine;

ARCHITECTURE behavioral OF state_machine IS
	TYPE state_type IS (expect, flip, verify, success);
	SIGNAL state	:	state_type	:=	expect;
BEGIN
	PROCESS(clock, reset)
	BEGIN
		IF reset = '0' THEN
			state <= expect;
			keyboard_register_enable <= '1';
			comparator_enable <= '0';
		ELSIF (clock'EVENT AND clock = '1') THEN
			CASE state IS
				WHEN expect =>
					IF (keyboard_register_full = '0') THEN
						keyboard_register_enable <= '1';
						comparator_enable <= '0';
					ELSE
						keyboard_register_enable <= '0';
						state <= flip;
					END IF;
				WHEN flip =>
					comparator_enable <= '1';
					state <= verify;
				WHEN verify =>
					IF (equals = '1') THEN
						state <= success;
					END IF;
				WHEN success =>
					state <= expect;
			END CASE;
		END IF;
	END PROCESS;
END behavioral;
