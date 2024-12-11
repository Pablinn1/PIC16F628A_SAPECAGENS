; Aprender a usar o PWM

; Registradores:  TMR2, PR2

; CCPRxL: registardor onde ser guardado o DUTY CICLE

; Período PWM = [(PR2)+1] * 4 * Tosc * Pre scale TMR2

; Pre scale TMR2: 1 / 4 / 16

; Frequência PWM = 1/ PWM period

; PR2 = [Fosc/ (Fpwm * 4 * pre scale timer2)] - 1

; PR2 > 255, tento mudar o pre scale do Timer2

; Resolução do meu : PWM duty cicle = (CCPR1L:CCP1COM<5:4>) * Tosc * (TMR2 prescale)

; (CCPR1L:CCP1COM<5:4>) os valores nesses registradores vai variar de 0 á 255

; PWM Resolution = log(Fosc/Fpwm * TMR2 Prescaler)/log(2) bits :: Achar a quantidade de bits para serem alocados nos regs CCPR1L:CCP1COM<5:4>



; Configurar o PWM para uma frequencia de 20KHZ, D = 25%

#INCLUDE <P16F6228A.INC>

ORG 0
GOTO MAIN
ORG 0X04
RETFIE

MAIN: 

BANKSEL TRISB
BCF TRISB, 3
MOVLW D'49'
MOVWF PR2

BANKSEL CCP1CON
MOVLW B'00101111'
MOVWF CCP1CON
MOVLW B'00000100'
MOVWF T2CON

MOVLW B'00001100'
MOVWF CCPR1L

FIM

GOTO FIM

END