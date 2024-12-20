
; NÃO FUNCIONA

__CONFIG _FOSC_EXTRCCLK & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _BOREN_OFFs & _LVP_ON & _CPD_OFF & _CP_OFF
    
    #INCLUDE <P16F628A.INC>

ORG 0
    GOTO MAIN

ORG 0X04

    BTFSC PIR1, TXIF   ; Bit 4: Sinalização de Interrupção da Transmissão no USART   (0 = buffer de transmissão cheio)
    GOTO TRATA_TX      ; Caso NÃO acontecer uma interrupçao na transmissão no USART , irei para goto TRATA_TX
    
    ; Se meu buffer do transmissor estiver cheio, irei tentar ir para o TRAT_INT para começar de fato a transmissão                  
    
    BTFSC INTCON, INTF ; BIT 1: Verifico se houve uma interrupçao por parte do RB0 (1 = teve sim papai)
    GOTO Trata_INT     ; Caso tenha ocorrido a interrupção, vou pra 
    
    RETFIE

Trata_INT
    BCF INTCON, INTF  ; Limpo o bit da interrupção do RB0
    MOVF PORTA, 0     ; Movo o conteúdo dos pinos A pro registrador TXREG
    MOVWF TXREG       
    BCF INTCON, INTE  ; Desabilito a interrupção externa pra não dá merda
    RETFIE

TRATA_TX

    BCF PIR1, TXIF     ; Clenar a flag de interrupção
    BSF INTCON, INTE   ; Habilitar a interrupção externa
    RETFIE

MAIN

BANKSEL CMCON  
    MOVLW B'00000111'  ; Desligo os comparadores dos pinoA
    MOVWF CMCON

BANKSEL TXSTA          ; TXSTA: Responsável pelas configurações dos status de controle e transmissão 
    MOVLW B'00100110'  ; BIT 7: Responsável por selecionar o modo mestre/escravo (indiferente caso esteja no modo assincrono)
    MOVWF TXSTA        ; BIT 6: Selecinar a transmissão de 8 bits/ BIT 5: Habilita a transmissão/ BIT 4: Seleção do modo sincrono ou assincrono
                       ; BIT 3: FODA-SE/ BIT 2: Seleção de velocidade alta/baixa (indiferente caso seja sincrono)/ BIT 1: Status do registrador de deslocamento da trasnmissão (1 = vazio) 
                       ; BIT 0: Bit 9 da transmissão ou bit de paridade
    
    MOVLW D'25'        ; SPBRG: Gerador de taxa de transmissão (BOUND RATE)
    MOVWF SPBRG 
    MOVLW B'00010000'  ; PIE1: Habilita a interrupção de transmissão do USART
    MOVWF PIE1         
    MOVLW B'11010000'  ; INTCON: BIT 7: Ativa as interrupções globais/ BIT 6: Ativa as interrupções periféricas/ BIT 4: Habilita a interrupção externa através do RB0
    MOVWF INTCON

    BSF OPTION_REG, 6  ; Coloco a borda de interrupção no modo alto

BANKSEL TRISA      
    MOVLW 0xFF         ; Coloco todas os Pinos A como entrada
    MOVWF TRISA

BANKSEL RCSTA           ; RCSTA: Responsável pelas configurações dos status de controle e recepção
    MOVLW B'10000000'   ; BIT 7: (Configura os pinos RB1/RX/DT e RB2/TX/CK como pinos de porta serial quando os bits TRISB<2:1> estão ativados)
    MOVWF RCSTA	        ; BIT 6: Seleção da recepção de 8/9 bits

FIM
   
    GOTO FIM
    
END