; FUNCIONA
; Importante entender o código do PISCA_PISCA antes

#INCLUDE <P16F628A.INC>

#DEFINE LED PORTB, 0
#DEFINE BTT PORTB, 5

CBLOCK 0x20             ; Aloquei as variaveis nos endereços 0x20 á 0x23
VALOR
VALOR1
VALOR2
VALOR3
ENDC

ORG 0
GOTO INICIO
ORG 0X04
RETFIE

INICIO:

    BANKSEL TRISB
    MOVLW B'00100000'
    MOVWF TRISB         ; Seto apenas o PORT5 como pino de entrada
    BANKSEL PORTB
    CLRF PORTB          ; Dou um clear nos pinoB pra não dar b.o


BOTAO:

    BTFSS BTT           ; Verifico o botão e pulo a proxima intrução caso esteja ON
    GOTO TIME           ; Opção de 1HZ
    GOTO TIME2          ; Opção de 5 HZ

TIME:                   ; Sistema do pisca pisca de 1 HZ

    BCF LED
    CALL ATRASO1

    BSF LED
    CALL ATRASO1

    GOTO BOTAO          ; Volto para verificar o estado do botão

ATRASO1:

    MOVLW D'170'        ; Número de repetições que o loop externo terá + resets do loop interno
    MOVWF VALOR

LOOP1:

    MOVLW D'250'        ; Número de vezes que o loop interno terá
    MOVWF VALOR1

LOOP2:

    DECFSZ VALOR1, F    ; Pulo o loop2 caso for 0
    GOTO LOOP2
    DECFSZ VALOR, F     ; Pulo o loop1 caso for 0
    GOTO LOOP1

    RETURN              ; Retorno aonde o call foi chamado


                        ; -------- O resto do código segue a mesma lógica, porém o número de interações foi modificado com o intuito de fazer o led piscar a 5hz. ---------;


TIME2:

    BCF LED
    CALL ATRASO2

    BSF LED
    CALL ATRASO2
    GOTO BOTAO

ATRASO2:

    MOVLW D'32'
    MOVWF VALOR2

LOOP3:

    MOVLW D'255'
    MOVWF VALOR3

LOOP4:

    DECFSZ VALOR3, F
    GOTO LOOP4

    DECFSZ VALOR2, F
    GOTO LOOP3

    RETURN

    END
