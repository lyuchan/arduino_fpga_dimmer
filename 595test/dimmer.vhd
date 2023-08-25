LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;
USE IEEE.std_logic_arith.ALL;

ENTITY dimmer IS

    PORT (
        clk : IN STD_LOGIC;--時鐘
        zero_in : IN STD_LOGIC; --過零檢測
        sw : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        led : BUFFER STD_LOGIC_VECTOR(7 DOWNTO 0);
        tout : BUFFER STD_LOGIC--晶體輸出

    );

END;

ARCHITECTURE a OF dimmer IS
    SIGNAL q : STD_LOGIC_VECTOR(22 DOWNTO 0);
    SIGNAL ck_1M : STD_LOGIC;
    SIGNAL dim : INTEGER RANGE 0 TO 6000 := 3000;
    SIGNAL dim2 : INTEGER RANGE 0 TO 6000 := 0;
    SIGNAL x : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL swzero : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
    ck_macker : PROCESS (clk)

        VARIABLE j : STD_LOGIC_VECTOR(9 DOWNTO 0);
        VARIABLE delay_1M : INTEGER RANGE 0 TO 100;

    BEGIN

        IF rising_edge(clk) THEN
            q <= q + 1;--ck maker

            IF delay_1M = 50 THEN
                delay_1M := 0;
                ck_1M <= NOT ck_1M;
            ELSE
                delay_1M := delay_1M + 1;
            END IF;

        END IF;

    END PROCESS;
    main : PROCESS (clk)
        VARIABLE timer : INTEGER RANGE 0 TO 6000;

    BEGIN
        IF rising_edge(zero_in) THEN
            swzero <= sw;
        END IF;
        IF rising_edge(ck_1M) THEN
            IF swzero <= "00000010"THEN
                tout <= '0';
                dim <= 0;
                dim2 <= 0;
            ELSIF swzero >= "11110000" THEN
                tout <= '1';

            ELSE
                CASE x IS
                    WHEN "00" =>
                        IF zero_in = '1' THEN
                            dim <= 4003 - ((conv_integer(swzero) - 8) * 15);
                            dim2 <= 5;
                            timer := 0;
                            x <= "01";
                        END IF;
                    WHEN "01" =>
                        timer := timer + 1;
                        IF timer >= dim THEN
                            timer := 0;
                            x <= "10";
                            tout <= '1';
                        END IF;
                    WHEN "10" =>
                        timer := timer + 1;
                        IF timer >= dim2 THEN
                            timer := 0;
                            x <= "11";
                            tout <= '0';
                        END IF;
                    WHEN OTHERS =>
                        IF zero_in = '0' THEN
                            timer := 0;
                            x <= "00";
                        END IF;
                END CASE;
            END IF;
        END IF;
    END PROCESS;
END;