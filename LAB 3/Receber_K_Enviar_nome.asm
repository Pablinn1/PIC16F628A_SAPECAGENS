#INCLUDE <P16F628A.INC>

__CONFIG _FOSC_EXTRCCLK & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _BOREN_ON & _LVP_ON & _CPD_OFF & _CP_OFF

VALOR EQU 0x20

ORG 0
    GOTO INIT

ORG 4
    ; Rotina de interrupção
    BANKSEL RCREG
    MOVF RCREG, W       ; Lê o valor recebido no UART
    MOVWF VALOR         ; Armazena o valor em VALOR
    
    MOVLW 0x4B          ; Valor ASCII da letra "K"
    XORWF VALOR, W      ; Compara VALOR com "K"
    BTFSS STATUS, Z     ; Se forem iguais, pula a próxima instrução
    RETFIE              ; Se diferente, retorna da interrupção

    ; Envia "YAN" se a letra for "K"
    CALL ENVIAR_NOME    
    RETFIE

ENVIAR_NOME:
    MOVLW B'00100000'   ; Envia espaço
    CALL ESPERA_TX
    MOVWF TXREG

    MOVLW 0x59          ; Envia 'Y'
    CALL ESPERA_TX
    MOVWF TXREG

    MOVLW 0x41          ; Envia 'A'
    CALL ESPERA_TX
    MOVWF TXREG

    MOVLW 0x4E          ; Envia 'N'
    CALL ESPERA_TX
    MOVWF TXREG

    MOVLW B'00100000'   ; Envia espaço
    CALL ESPERA_TX
    MOVWF TXREG
    
    RETURN

ESPERA_TX:
    BANKSEL PIR1
    BTFSS PIR1, TXIF    ; Espera até TXIF estar setado
    GOTO ESPERA_TX
    RETURN

INIT:
    ; Configuração inicial
    BANKSEL TRISB
    MOVLW B'00000110'   ; Configura RB1 e RB2 como entrada (TX/RX)
    MOVWF TRISB
    MOVLW B'00100110'   ; Configura TXSTA (transmissão habilitada, alta velocidade)
    MOVWF TXSTA
    MOVLW D'25'         ; Configura SPBRG (baud rate)
    MOVWF SPBRG
    CLRF PIE1
    BSF PIE1, RCIE      ; Habilita interrupção de recepção UART
    
    BANKSEL RCSTA
    MOVLW B'10010000'   ; Habilita UART (Serial Enable e Reception Enable)
    MOVWF RCSTA
    CLRF PIR1           ; Limpa flags de interrupção
    MOVLW B'11000000'   ; Habilita interrupções globais e periféricas
    MOVWF INTCON

FIM:
    GOTO FIM

END
