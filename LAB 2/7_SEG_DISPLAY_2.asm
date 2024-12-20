; Leitura dos binários 00 á 11 e visualização no Display

#INCLUDE <P16F628A.INC>

#DEFINE BTT 2         ; Definindo os BTT pra facilitar a vizualisação
#DEFINE BTT2 3

ORG 0
    GOTO MAIN
ORG 0X04
    RETFIE

MAIN:

BANKSEL TRISA         ; Direcionamento para o banco dos reg. TRISA e TRISB

    MOVLW B'00001100' ; Coloco apenas as portas A R2A E R3A como INPUT
    MOVWF TRISA

    MOVLW B'00000000' ; Coloco todas as portas B como OUTPUT
    MOVWF TRISB

BANKSEL PORTA         ; Me direciono ao banco do PORTA, PORTB E CMCON

    CLRF PORTA
    CLRF PORTB        ; Limpo os bits de estado do PORTA E PORTB para não ocorrer erros com programações passadas

    MOVLW B'00000111' ; Desligo os comparadores dos pinos do PORTA
    MOVWF CMCON


BOTAO:

    BTFSS PORTA, BTT  ; Verifico se o bit mais significativo está 1, caso estiver, ele pulará para a intrução GOTO DOIS_TRES
    GOTO  ZERO_UM     ; 0 = 00 , 1 = 01 ; BIT MSB = 0
    GOTO  DOIS_TRES   ; 2 = 10 , 3 = 11 ; BIT MSB = 1



ZERO_UM:

    BTFSS PORTA, BTT2 ; Verifico qual o estado do meu bit menos significativo e pulo uma instrução caso seja  = 1

    GOTO ZERO  ; 0 = 00  BIT LSB = 0
    GOTO UM    ; 1 = 01  BIT LSB = 1


DOIS_TRES:

    BTFSS PORTA, BTT2 ; Verifico qual o estado do meu bit menos significativo e pulo uma instrução caso seja  = 1

    GOTO DOIS ; 2 = 10  BIT LSB = 0
    GOTO TRES ; 3 = 11  BIT LSB = 1


;------------ O resto do código segue uma rotina de verificar o estado do botão e "ativar/desativar" os pinos do PORTB ligados ao display ------------;

ZERO:

    MOVLW B'00111111'   
    MOVWF PORTB

    GOTO BOTAO  ; Retorno a função BOTAO para verificar estado dos botões

UM:

    MOVLW B'00000110'
    MOVWF PORTB

    GOTO BOTAO

DOIS:

    MOVLW B'01011011'
    MOVWF PORTB

    GOTO BOTAO

TRES:

    MOVLW B'01001111'
    MOVWF PORTB

    GOTO BOTAO

END