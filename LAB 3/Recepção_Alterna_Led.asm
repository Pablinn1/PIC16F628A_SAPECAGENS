; Ligar um determinado Led dependendo do conteúdo recebido 
    
    __CONFIG _FOSC_EXTRCCLK & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _CP_OFF

    #INCLUDE <P16F628A.INC>

    ORG 0
    GOTO MAIN
    ORG 0X04
    RETFIE 