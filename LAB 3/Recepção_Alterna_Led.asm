
#INCLUDE <P16F628A.INC>


 __CONFIG _FOSC_EXTRCCLK & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _BOREN_ON & _LVP_ON & _CPD_OFF & _CP_OFF

VALOR EQU 0X20

 
 ORG 0
 GOTO INIT
 
ORG 4
    BANKSEL RCREG
    MOVF RCREG, W      ; Lê o valor recebido no UART (RCREG)
    MOVWF VALOR        ; Armazena o valor em VALOR
    
    BANKSEL VALOR
    BTFSC VALOR, 0     ; Testa se o bit 1 de VALOR está setado (1)
    GOTO A_OR_S     ; Se estiver, pula para SET_PORTB 
    GOTO X_OR_Z
    RETFIE
    
A_OR_S:
    
    BANKSEL VALOR      ; Seleciona o banco de PORTB
    BTFSC VALOR, 1 
    GOTO SET_LED_7
    GOTO SET_LED_6
    RETFIE             ; Retorna da interrupção

X_OR_Z:
    
    BANKSEL VALOR
    BTFSC VALOR, 1
    GOTO SET_LED_6
    GOTO SET_LED_7
    RETFIE
    
SET_LED_7:
    BANKSEL PORTB
    BCF PORTB ,6
    BSF PORTB, 7
    RETFIE

SET_LED_6: 
    
    BANKSEL PORTB
    BCF PORTB, 7
    BSF PORTB, 6
    RETFIE 
   
INIT
    
    BANKSEL PORTB
    CLRF PORTB
    
    BANKSEL TRISB
    MOVLW B'00000110'
    MOVWF TRISB
    MOVLW B'00100110'
    MOVWF TXSTA
    MOVLW D'25'
    MOVWF SPBRG
    CLRF PIE1
    BSF PIE1,RCIE
    
    BANKSEL RCSTA
    MOVLW B'10010000'
    MOVWF RCSTA
    CLRF PIR1
    MOVLW B'11000000'
    MOVWF INTCON
    
    FIM
	GOTO FIM
	
END
    

; A flag RCIF só será limpa automaticamente ao ler o registrador RCREG, logo não é necessário ter que limpar ela na rotina de interrupção