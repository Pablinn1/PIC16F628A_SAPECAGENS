; Receber uma letra maiúscula e enviar uma minuscula

#INCLUDE <P16F628A.INC>


 __CONFIG _FOSC_EXTRCCLK & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _BOREN_ON & _LVP_ON & _CPD_OFF & _CP_OFF

 ORG 0
 GOTO INIT
 
 ORG 4
    BANKSEL RCREG
    MOVF RCREG,W
    MOVWF 0x20
    MOVLW D'32'
    SUBWF 0x20,W
    MOVWF TXREG
    RETFIE
    
INIT
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