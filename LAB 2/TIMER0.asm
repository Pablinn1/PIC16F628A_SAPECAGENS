;FUNCIONA
; Pisca Pisca com TIMER 0

#INCLUDE <P16F628A.INC>

TEMPO EQU 0X20
CONTA EQU 0X21

ORG 0
GOTO MAIN

ORG 0X04
BCF INTCON, T0IF      ; Após a interrupção, limpo o "cache" responsável por travar o  programa
DECFSZ TEMPO , F      ; Decremento a variável tempo a fim de gastar tempo KKKKKKKKK (me ajuda)
RETFIE                ; Tempo > 0, fico em um loop de decremento   Tempo = 0, pulo uma instrução e começa a bagaceira
MOVF CONTA, W
MOVWF TEMPO           ; Reabasteço a variável para as futuras interrupções

MOVLW B'10000000'
XORWF PORTB, F        ; Faço uma operação XOR entre o registardor W e o PORTB (olha a tabela verdade se tiver dúvidas)
RETFIE                ; OBS: O PORTB é B'00000000' por padrão

MAIN:

BANKSEL TRISB         ; Entro no banco do registrador TRISB (O MESMO DO reg. OPTION)
MOVLW B'00000000'     ; Configuro todas as portas como saída
MOVWF TRISB

MOVLW B'10000111'     ; BITS NOTÁVEIS PARA A CONFIG DO TIMER 0
MOVWF OPTION_REG      ; Os 3 (0:2) primeiros bits são apra ajustar o pré-scale de 1:256
                      ; O bit 3 serve para atribuir o pré-scale ao TIMER 0
                      ; o bit 7 serve para desativar os resistores pull ups nativos dos pinos B

BANKSEL INTCON        ; Entro no banco do INTCON e de quebra adentro no do PORTB também

MOVLW B'10100000'     ; BITS NOTÁVEIS PARA A INTERRUPÇAO DO TIMER 0
                      ; O bit 2 serve como um CACHE, se ele estiver 1, é por que houve uma interrupção e as ações serã congeladas
                      ; O bit 5 serve para habilitar as interrupções do TIMER 0
                      ; O bit 7 serve para habilitar as interrupções globais
MOVWF INTCON

MOVLW D'15'           ; Variável para controlar o tempo do TIMER
MOVWF TEMPO
MOVWF CONTA

FIM:

GOTO FIM

END

; Cálculo para achar a frequencia/tempo operante do TIMER0

; F = 4mhz/ ( 4 * pre-scale * (256 - 0) )

; F = 4mhz/ ( 4 * 256 * (256 - 0) )

; F = 15,256 hz >>> T = 0,0655s

; 0,0655s * 15 = 1 s

; É necessário fazer um laço de repetição onde a interrupção do timer ocorra 15 vezes
; Para que ai a rotina de mudança de estado do led seja executada

; O tempo do TIMER 0 é de 0,0655, com os 15 do loop ficará em 1 segundo
; Portante o LED ficará 1s aceso e 1 apagado, logo o período do LED é de 2s