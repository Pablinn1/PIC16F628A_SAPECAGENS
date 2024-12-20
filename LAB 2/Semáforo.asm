#INCLUDE <P16F628A.INC>
    
    __CONFIG _FOSC_INTOSCIO & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _CP_OFF

    VALOR EQU 0x20  
 
    ORG 0x00
    GOTO MAIN

    ORG 0x04	   
    BCF PIR1, TMR1IF ;Limpo a flag de interrupção do timer 1
    MOVLW 0xDC
    ADDWF TMR1L
    MOVLW 0x0B
    ADDWF TMR1H	   ; Reabasteço os registradores TMR1L E TMR1H
    
    ; Já que o timer1 tem um tempo de 0,5 segundos...
    
    INCF  VALOR  
    MOVLW D'12'     ; Incrementar 12 interrupções fará com que eu gaste 6 segundos.
    XORWF VALOR, W  ; Comparo o VALOR com o conteúdo do registrador de trabalho
    BTFSS STATUS, Z ; Caso Xor = 0 (VALOR = W), Z = 1 , pulo para o CLRF valor e reinicio a contagem 
    GOTO TEMPO
    CLRF VALOR
    GOTO VERMELHO

TEMPO                   ; LOOP de controle, onde comparo VALOR com STATUS
    MOVLW 0x00
    XORWF VALOR, W
    BTFSS STATUS, Z
    GOTO TEMPO1
    GOTO VERMELHO
TEMPO1
    MOVLW 0x01
    XORWF VALOR, W
    BTFSS STATUS, Z
    GOTO TEMPO2
    GOTO VERMELHO
TEMPO2
    MOVLW 0x02
    XORWF VALOR, W
    BTFSS STATUS, Z
    GOTO TEMPO3
    GOTO VERMELHO
TEMPO3
    MOVLW 0x03
    XORWF VALOR, W
    BTFSS STATUS, Z
    GOTO TEMPO4
    GOTO VERMELHO
TEMPO4
    MOVLW 0x04
    XORWF VALOR, W
    BTFSS STATUS, Z
    GOTO TEMPO5
    GOTO VERMELHO
TEMPO5
    MOVLW 0x05
    XORWF VALOR, W
    BTFSS STATUS, Z
    GOTO TEMPO6
    GOTO VERMELHO
TEMPO6    
    MOVLW 0x06
    XORWF VALOR, W
    BTFSS STATUS, Z
    GOTO TEMPO7
    GOTO AMARELO
TEMPO7
    MOVLW 0x07
    XORWF VALOR, W
    BTFSS STATUS, Z
    GOTO TEMPO8
    GOTO AMARELO
TEMPO8
    MOVLW 0x08
    XORWF VALOR, W
    BTFSS STATUS, Z
    GOTO TEMPO9
    GOTO VERDE
TEMPO9    
    MOVLW 0x09
    XORWF VALOR, W
    BTFSS STATUS, Z
    GOTO TEMPO10
    GOTO VERDE
TEMPO10
    MOVLW 0x0A
    XORWF VALOR , W
    BTFSS STATUS, Z
    GOTO TEMPO11
    GOTO VERDE
TEMPO11
    MOVLW 0x0B
    XORWF VALOR, W
    BTFSS STATUS, Z
    GOTO FIM
    GOTO VERDE

; ------------LIGAR/DESLIGAR OS LEDS------------ ;

VERMELHO            
    CLRF PORTB
    BSF PORTB, RB0 
    RETFIE
    
AMARELO
    CLRF PORTB
    BSF PORTB, RB1
    RETFIE
    
VERDE
    CLRF PORTB
    BSF PORTB, RB2
    RETFIE

       
MAIN
    BANKSEL T1CON
    MOVLW B'00110101'
    MOVWF T1CON
    
    MOVLW 0xDC
    MOVWF TMR1L
    MOVLW 0x0B
    MOVWF TMR1H       ;Configurando TMR1 Overflow period (500ms), 1MHz, prescaler 8
   
    BANKSEL INTCON    ; Ativando a configuração global e periférica
    MOVLW B'11000000'
    MOVWF INTCON
    
    BANKSEL PIE1
    BSF PIE1, TMR1IE ;Permitindo interrupções por overflow de TMR1

    BANKSEL TRISB ; Colocando PORTB tudo como saída
    MOVLW 0x00
    MOVWF TRISB	     

    BANKSEL PORTB
    CLRF PORTB
    BSF PORTB, RB0  ; Ligando o sinal vermelho

FIM
   
    GOTO FIM
    
    END
