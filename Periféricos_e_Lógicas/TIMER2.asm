; Funciona
; Aprender a usar o TIMER 2

; Contém pre scale e um post scale

; Post scale configuro em qual momento vai ocorrer a interrupção, ou seja, quantas vezes o timer vai estourar até ocorrer uma interrupção.
; Ex: Post Scale = D'5', o timer vai se interrompido apenas no quinto estouro

; Registrador PR2 é utilizado para controlar o estouro do TMR2

; REGISTRADORES: PIE1(Habilitar interrupção), PIR1(Flag de interrupção), INTCON(INTERRUPÇÕES), T2CON (Controle do TIMER2), TMR2

; T = Ciclo de maquina * prescaler* postscaler* PR2

; Ciclo de maquina = 4/ Fosc


#INCLUDE <P16F628A.INC>

ORG 0
    GOTO MAIN

ORG 0X04

    BCF PIR1, TMR2IF    ; Limpa a flag de interrupção do TIMER2
    MOVLW B'10000000'
    XORWF PORTB, F
    RETFIE

MAIN:

BANKSEL TRISB           ; Adentro no banco dos registradores TRISB, PIE1, INTCON, PR2

    CLRF TRISB

    MOVLW B'00000010'   ; HABILITO A INTERRUPÇÃO DO TMR2 COM O PR2 (POST SCALE)
    MOVWF PIE1          ; Registrador responsável pela ativação da interrupção
    MOVLW B'11000000'   ; Bit 7 serve para ativar as interrupções globais e o bit 6 as interrupções perifericas
    MOVWF INTCON      
    MOVLW B'11111111'   ; Coloco 255 no PR2 a fim de ter um período desejavel do TIMER2
    MOVWF PR2

BANKSEL T2CON           ; Adentro no banco do registrador T2CON

    MOVLW B'01111111'   ; T2CON é responsável pelo controle do TIMER2
    MOVWF T2CON         ; O bit 7 é fodase / 6 : 3 são para o pos scale
                        ; O bit 2 é para o acionamento do TIMER2
                        ; Os bits 1:0 são para a seleção do pre scale

FIM:

    GOTO FIM

END



; T = 1x10^-6 * 16 * 16 * 255 = 0,065536