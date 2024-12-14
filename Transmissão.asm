   ; ESSA PORRA FUNCIONA

    __CONFIG _FOSC_EXTRCCLK & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _CP_OFF

      
#INCLUDE <P16F628A.INC>

ORG 0
    GOTO MAIN
ORG 0X04

    BCF INTCON, INTF  ; (BIT 1): Limpo a flag de interrupção RB0
    MOVLW 0X42        ; Guardo a palavra "B" no registrador de trabalho e envio para o serial
    MOVWF TXREG       ; Movo para o registrador de transmissão

    RETFIE

MAIN:

BANKSEL CMCON
    MOVLW B'00000111' ; Desabilito os comparadores dos Pinos A
    MOVWF CMCON

BANKSEL TXSTA    ; Adentro no banco dos registradores TXSTA, SPBRG, INTCON, OPTION_REG

    MOVLW B'00100110' ; TXSTA: Responsável pelas configurações de transmissão
                  ; BIT 7: ResponsáveL por selecionar o modo mestre/escravo (indiferente no modo assincrono)
    MOVWF TXSTA   ; BIT 6: Selecionar a trasnmissão de 8 bits/ BIT 5: Habilita a transmissão/ BIT 4: Seleçao do modo assincrono/sincrono
                  ; BIT 3: FODA-SE OS EUA/ BIT 2: Seleção de velocidade de transmissão ALTA//BAIXA                   
		  ; BIT 1: Status do registrador de deslocamento da trasnmissão (1 = vazio)/ BIT 0 : 9 bits de transmissão ou bit de paridade
		  
    MOVLW D'25'       ; Seleção de bound rate = 9600 bps
    MOVWF SPBRG 

    MOVLW B'00010000' ; Ativação da interrupção pelo buffer de transmissão
    MOVWF PIE1
    MOVLW B'10010000' ; BIT 7: Ativação das interrupções globais/ BIT 4:Habilitação da interrupção pelo pino RB0 
    MOVWF INTCON

    BSF OPTION_REG, 6 ; Seleção de interrupção na borda ALTA em relaçao ao pino RB0

BANKSEL TRISA    
    MOVLW 0xFF        ; Coloco todas as portas como entrada (serve para outro código)
    MOVWF TRISA

    MOVLW B'01111011'
    MOVWF TRISB

BANKSEL RCSTA          ; RCSTA: Responsável pelas configurações dos status de controle e recepção
    MOVLW B'10000000'  ; BIT 7: (Configura os pinos RB1/RX/DT e RB2/TX/CK como pinos de porta serial quando os bits TRISB<2:1> estão ativados)
    MOVWF RCSTA                  ; BIT 6: Seleção da recepção de 8/9 bits
FIM
    GOTO FIM

END