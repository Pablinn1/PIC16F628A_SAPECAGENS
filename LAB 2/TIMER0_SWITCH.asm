; FUNCIONA
; Pisca Pisca com TIMER 0

#INCLUDE <P16F628A.INC>

#DEFINE BTT 2

TEMPO EQU 0X20
CONTA EQU 0X21

ORG 0
GOTO MAIN

ORG 0X04
 
BCF INTCON, T0IF      ; Após a interrupção, limpo o "cache" responsável por travar o  programa
DECFSZ TEMPO , F      ; Decremento a variável tempo a fim de gastar tempo KKKKKKKKK (me ajuda)
RETFIE                ; Tempo > 0, fico em um loop de decremento   Tempo = 0, pulo uma instrução e começa a bagaceira

MOVLW D'5'
BTFSS PORTA, BTT
MOVLW D'31'

MOVWF TEMPO 
    
MOVLW B'10000000'
XORWF PORTB, F        ; Faço uma operação XOR entre o registardor W e o PORTB (olha a tabela verdade se tiver dúvidas)
RETFIE                ; OBS: O PORTB é B'00000000' por padrão

MAIN:

BANKSEL TRISB         ; Entro no banco do registrador TRISB (O MESMO DO reg. OPTION)
MOVLW B'00000000'     ; Configuro todas as portas como saída
MOVWF TRISB

BANKSEL TRISA
MOVLW B'00000100'
MOVWF TRISA

MOVLW B'10000111'     ; BITS NOTÁVEIS PARA A CONFIG DO TIMER 0
MOVWF OPTION_REG      ; Os 3 (0:2) primeiros bits são apra ajustar o pré-scale de 1:256
                      ; O bit 3 serve para atribuir o pré-scale ao TIMER 0
                      ; o bit 7 serve para desativar os resistores pull ups nativos dos pinos B

BANKSEL PORTB        ; Entro no banco do INTCON e de quebra adentro no do PORTB também

CLRF PORTA
CLRF PORTB
		      
MOVLW B'10100000'     ; BITS NOTÁVEIS PARA A INTERRUPÇAO DO TIMER 0
                      ; O bit 2 serve como um CACHE, se ele estiver 1, é por que houve uma interrupção e as ações serã congeladas
                      ; O bit 5 serve para habilitar as interrupções do TIMER 0
                      ; O bit 7 serve para habilitar as interrupções globais
MOVWF INTCON

MOVLW B'00000111'
MOVWF CMCON

MOVLW D'5'		      
BTFSS PORTA, BTT
MOVLW D'31'
		      
MOVWF TEMPO

FIM:

GOTO FIM

END

; Cálculo para achar a frequencia/tempo operante do TIMER0

; F = 4mhz/ ( 4 * pre-scale * (256 - 0) )

; F = 4mhz/ ( 4 * 256 * (256 - 0) )

; F = 15,256 hz >>> T = 0,0655s

; 0,0655s * 15 = 1 s

; É necessário fazer um laço de repetição onde a interrupção do timer ocorra 15 vezes
; Para que ai a rotina de mudança de estado do led seja executada

; O tempo do TIMER 0 é de 0,0655, com os 15 do loop ficará em 1 segundo
; Portante o LED ficará 1s aceso e 1 apagado, logo o período do LED é de 2s



;OUTRO MODO DE TRATAR A INTERRUPÇÃO E MUDAR A FREQ DOS LEDS

;ORG 0X04
 
;BCF INTCON, T0IF      
;DECFSZ TEMPO , F    
;RETFIE                

;BTFSC PORTA, BTT
;GOTO FREQ1
;GOTO FREQ2  

;FREQ1:
    
;MOVLW D'15'
;MOVWF TEMPO   

;GOTO PISCA
    
;FREQ2:
    
;MOVLW D'31'
;MOVWF TEMPO

;PISCA:

;MOVWF TEMPO 
    
;MOVLW B'10000000'
;XORWF PORTB, F       
;RETFIE               
