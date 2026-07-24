library ieee;
use ieee.std_logic_1164.all;

entity tb_fp_adder is
end tb_fp_adder;

architecture behavior of tb_fp_adder is
    signal sign1, sign2, sign_out : std_logic;
    signal exp1, exp2, exp_out : std_logic_vector(3 downto 0);
    signal frac1, frac2, frac_out : std_logic_vector(7 downto 0);
begin
    uut: entity work.fp_adder
        port map (
            sign1 => sign1, sign2 => sign2,
            exp1 => exp1, exp2 => exp2,
            frac1 => frac1, frac2 => frac2,
            sign_out => sign_out, exp_out => exp_out, frac_out => frac_out
        );

    process begin
        -- Teste 1: Soma simples gerando Carry Out (Testa deslocamento do 4º estágio)
        -- A = 0.75*2^8 = 192 ; B = 0.75*2^8 = 192 ; esperado = 384 (exp=9, frac=C0)
        sign1 <= '0'; exp1 <= "1000"; frac1 <= "11000000";
        sign2 <= '0'; exp2 <= "1000"; frac2 <= "11000000";
        wait for 20 ns;

        -- Teste 2: Subtração gerando zeros à esquerda (Testa contagem de zeros)
        -- A = 0.75*2^8 = 192 ; B = -0.6875*2^8 = -176 ; esperado = 16 (exp=5, frac=80)
        sign1 <= '0'; exp1 <= "1000"; frac1 <= "11000000";
        sign2 <= '1'; exp2 <= "1000"; frac2 <= "10110000";
        wait for 20 ns;

        -- Teste 3: Soma direta, sem deslocamento (leado="000", sem carry-out)
        -- A = 0.625*2^8 = 160 ; B = 0.5625*2^7 = 72 ; esperado = 232 (exp=8, frac=E8)
        sign1 <= '0'; exp1 <= "1000"; frac1 <= "10100000";
        sign2 <= '0'; exp2 <= "0111"; frac2 <= "10010000";
        wait for 20 ns;

        -- Teste 4: Cancelamento total -> resultado converte para zero (leado > expb)
        -- A = 0.75*2^3 = 6 ; B = -0.75*2^3 = -6 ; esperado = 0 (exp=0, frac=00)
        -- Observacao: como exp1&frac1 = exp2&frac2 (empate), o operando 2 (B) e
        -- roteado como "big" no 1o estagio, entao sign_out sai '1' mesmo o
        -- resultado sendo zero ("zero negativo" do algoritmo original).
        sign1 <= '0'; exp1 <= "0011"; frac1 <= "11000000";
        sign2 <= '1'; exp2 <= "0011"; frac2 <= "11000000";
        wait for 20 ns;

        wait;
    end process;
end behavior;
