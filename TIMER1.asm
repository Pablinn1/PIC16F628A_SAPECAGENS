#INCLUDE <P16F628A.INC>

TEMPO EQU 0X20
CONTA EQU 0X21


ORG 0
GOTO MAIN

ORG 0X04
BCF PIR1,TMR1IF          ; LIMPO O BIT DE "CACHE", responsável por congelar o programa
MOVLW 0XDC
MOVWF TMR1L              ; Reabasteço os registradores responsáveis pela contagem do TIMER1
MOVLW 0X0B
MOVWF TMR1H
MOVLW B'10000000'        ; Faço uma operação XOR entre o registardor W e o PORTB (olha a tabela verdade se tiver dúvidas)
                         ; OBS: O PORTB é B'00000000' por padrão
XORWF PORTB, F
RETFIE                   ; Volto ao loop do fim

MAIN:

BANKSEL TRISB            ; Adentro no banco dos registardores TRISB , INTCON E PIE1
MOVLW B'00000000'        ; Coloco todas as entradas do PINOB como OUTPUT
MOVWF TRISB

MOVLW B'10100000'        ; BITS NOTÁVEIS PARA A INTERRUPÇÃO DO TIMER1
MOVWF INTCON             ; O bit 7 é responsável pela ativação das interrupções globais
                         ; O bit 6 é responsável pela ativação das interrupções periféricas

MOVLW B'00000001'        ; BITS NOTÁVEIS PARA A INTERRUPÇÃO DO TIMER1
MOVLW PIE1               ; Em relação ao TIMER1, esta merda de registrador serve apenas para ativar a interrupção por overflow
                         ; O bit 0 serve para ativar a porra da interrupção por overflow KKKKKKKKKKKKKKK

BANKSEL PIR1             ; Adentro no banco dos registradores PIR1, T1CON, TMR1L E TMR1H :)

MOVLW B'00110101'        ; BITS NOTÁVEIS PARA A CONFIGURAÇÃO DO TIMER1
MOVWF T1CON              ; O bit 0 é responsável por habilitar o TIMER1
                         ; O bit 1 habilita o clock interno (Fosc/4)
                         ; O bit 2 não sincroniza a entrada do clock externo (boas práticas) kkkkkk mentira...
                         ; O bit 3 desabilita o oscilador do TIMER1 
                         ; O bit 4:5 configuram o pre-scale (1:8 )do TIMER1 
                     
MOVLW 0XDC
MOVWF TMR1L
MOVLW 0X0B
MOVWF TMR1H

FIM:

GOTO FIM                 ; O programa ficará em loop aqui enquanto com o decorrer da contagem do timer

END


; Cálculo para a FREQ do LED

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

; Com essa repatição cada registrador não ultrapassa o 1 byte de memória