; NÃO FUNCIONA
; PISCA PSICA COM TIMER1


#INCLUDE <P16F628A.INC>

TEMPO EQU 0X20
CONTA EQU 0X21


ORG 0
    GOTO MAIN

ORG 0X04

    BCF PIR1 ,TMR1IF           ; LIMPO O BIT DE "CACHE", responsável por congelar o programa
    DECFSZ TEMPO, F
    RETFIE                     ; Semelhante ao TIMER0, esta lógica controla o perído do LED
    MOVF CONTA, W
    MOVWF TEMPO

    MOVLW 0XDC
    MOVWF TMR1L                ; Reabasteço os registradores responsáveis pela contagem do TIMER1
    MOVLW 0X0B
    MOVWF TMR1H
    MOVLW B'10000000'          ; Faço uma operação XOR entre o registardor W e o PORTB (olha a tabela verdade se tiver dúvidas)
                               ; OBS: O PORTB é B'00000000' por padrão
    XORWF PORTB, F
    RETFIE                     ; Volto ao loop do fim

MAIN:

BANKSEL TRISB                  ; Adentro no banco dos registardores TRISB , INTCON E PIE1
    
    CLRF TRISB                 ; Coloco todas as entradas do PINOB como OUTPUT

    MOVLW B'11000000'          ; BITS NOTÁVEIS PARA A INTERRUPÇÃO DO TIMER1
    MOVWF INTCON               ; O bit 7 é responsável pela ativação das interrupções globais
                               ; O bit 6 é responsável pela ativação das interrupções periféricas
    CLRF PIE1
    MOVLW B'00000001'          ; BITS NOTÁVEIS PARA A INTERRUPÇÃO DO TIMER1
    MOVWF PIE1                 ; Em relação ao TIMER1, esta merda de registrador serve apenas para ativar a interrupção por overflow
                               ; O bit 0 serve para ativar a porra da interrupção por overflow KKKKKKKKKKKKKKK

    BANKSEL PIR1               ; Adentro no banco dos registradores PIR1, PORTB, T1CON, TMR1L E TMR1H :)
    CLRF PIR1
    CLRF PORTB
    MOVLW B'00110101'          ; BITS NOTÁVEIS PARA A CONFIGURAÇÃO DO TIMER1
    MOVWF T1CON                ; O bit 0 é responsável por habilitar o TIMER1
                               ; O bit 1 habilita o clock interno (Fosc/4) (0)
                               ; O bit 2 não sincroniza a entrada do clock externo (boas práticas) kkkkkk mentira...
                               ; O bit 3 desabilita o oscilador do TIMER1
                               ; O bit 4:5 configuram o pre-scale (1:8) do TIMER1

    MOVLW 0XDC
    MOVWF TMR1L
    MOVLW 0X0B
    MOVWF TMR1H

    MOVLW D'2'                 ; Variável que controla diretamente a frequencia do LED através de LOOPS
    MOVWF CONTA
    MOVWF TEMPO

FIM:

    GOTO FIM                   ; O programa ficará em loop aqui enquanto o decorrer da contagem do timer

END


; --------------------------------------------------------------------------------------------------------------;

; Cálculo para a FREQ do TIMER

; Freq = Clock/(prescale) * (65536 - (TMR1L:TMR1H)) Fórmula para calcular a frequência e achar o "enchimento" dos TMR1'FDS'
; 2 HZ = 4MHZ/4 / [ 8 * (65536 - (TMR1L:TMR1H)) ]
; 2 HZ = 1 MHZ / [ 8 * (65536 - (TMR1L:TMR1H)) ]
; 2 HZ = 125000 / (65536 - (TMR1L:TMR1H))
; (65536 - (TMR1L:TMR1H)) = 125000 / 2
; (TMR1L:TMR1H) = 65536 - 62500
; (TMR1L:TMR1H) = 3036 = 0xBDC em hexa

; DIVIDO 0xBCD EM DOIS BYTES, PARA NÃO TER OVERFLOW NOS REGISTARDORES TMR1"FDS"
; 0x0B = 11 VAI PARA O TMR1H
; 0XDC = 220 VAI PARA O TMR1L

; Com essa repartição cada registrador não ultrapassa o 1 byte de memória

; O número em HEXA é necessário para preencher os registradores a fim de controlar o tempo que o TIMER vai estourar
; O perído do TIMER1 é de 0,5s, logo o led terá um perído de 1 segundo, pois será o momento ligado e o desligado

; Se o tempo do timer era 0,5, com a acrescimo  de um loop de 2 interações, o tempo ficará 0,5 * D'2' = 1s
; O led ficará 1s aceso e 1s desligado, contendo um período de 2s.





; SINAL VERDE = D'4'
; SINAL AMARELO = D'2'
; SINAL VERMELHO = D'6'





; VERDE:
; MOVLW 10000000
; XORWF PORTB, F

; AMARELO
; MOVLW 01000000
; XORWF PORTB, F

; VERMELHO
; MOVLW 00100000
; XORWF PORTB, F