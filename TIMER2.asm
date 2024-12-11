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

    BCF PIR1, TMR2IF
    MOVLW B'10000000'
    XORWF PORTB, F 
    RETFIE

MAIN:

BANKSEL TRISB
    CLRF TRISB
    
    MOVLW B'00000010' ; HABILITO A INTERRUPÇÃO DO TMR2 COM O PR2 (POST SCALE)
    MOVWF PIE1
    MOVLW B'11000000'
    MOVWF INTCON
    MOVLW B'11111111'
    MOVWF PR2

BANKSEL T2CON
    
    MOVLW B'01111111'
    MOVWF T2CON

FIM: 

    GOTO FIM

END

; T = 1x10^-6 * 16 * 16 * 255 = 0,065536