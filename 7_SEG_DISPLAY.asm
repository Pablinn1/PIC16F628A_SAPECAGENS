; FUNCIONA

; ESTE CÓDIGO CONTROLA UM DISPLAY DE 7 SEGMENTOS DEPENDENDO DO ESTADO DE UM BOTÃO

#INCLUDE <P16F628A.INC>

#DEFINE BTT 2     ; Defino BTT como 2 só pra contrariar

ORG 0
GOTO MAIN
ORG 0X04
RETFIE

MAIN:

BANKSEL PORTA     ; Adentro ao banco dos REG. PORTA, PORTB, E CMCON

CLRF PORTA        ; Limpo os pinos pra não ocorrer ruídos
CLRF PORTB
MOVLW 0X07
MOVWF CMCON       ; Configuro o registrador CMCON para desligar os comparadores nativos dos PINOS A (podem gerar erros)

BANKSEL TRISA     ; Adentro no banco dos REG. TRISA E TRISB

MOVLW B'00000100'
MOVWF TRISA       ; Coloco apenas o pino R2A como INPUT
CLRF TRISB        ; Seto dos os pinos B com OUTPUT

BANKSEL PORTA     ; Volto ao Banco do PORTA para manipulações futuras

BTT:

BTFSS PORTA, BTT  ; Verifico o estado do botão e vou para GOTO UM caso o sinal seja positivo
GOTO ZERO
GOTO UM

ZERO:

MOVLW B'00111111' ; Desenho o zero no display
MOVWF PORTB

GOTO BTT          ; Volto para verificar o estado do botão

UM:

MOVLW B'00000110' ; Desenho o um no display
MOVWF PORTB

GOTO BTT

END