; Recepção de algum conteúdo através da liberação de um botão 
    
    __CONFIG _FOSC_EXTRCCLK & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _CP_OFF

    #INCLUDE <P16F628A.INC>

    VALOR EQU 0X20 
   
   ORG 0
   GOTO MAIN
   ORG 0X04
   
   BANKSEL RCREG
   
   BCF INTCON, INTF
   
   MOVF RCREG, W
   MOVWF VALOR
   
   RETFIE 
    
    
    MAIN: 
    
    BANKSEL TRISB 
    MOVLW B'00000011'
    MOVWF TRISB
    MOVLW 0XFF
    MOVWF TRISA
    
    MOVLW B'00100110'
    MOVWF TXSTA
    
    MOVLW D'25'
    MOVWF SPBRG
    
     
   MOVLW B'10010000'
   MOVWF INTCON
    
   BSF OPTION_REG, 6
   
  
   BANKSEL RCSTA      ; RCSTA: Responsável pelas configurações dos status de controle e recepção
   MOVLW B'10010000'  ; BIT 7: (Configura os pinos RB1/RX/DT e RB2/TX/CK como pinos de porta serial quando os bits TRISB<2:1> estão ativados)
   MOVWF RCSTA        ; BIT 6: Seleção da recepção de 8/9 bits /BIT 5: Habilita a recepção contínua.


   MOVLW B'00000111'
   MOVWF CMCON
  
   
   FIM:
   
   GOTO FIM
   
   END