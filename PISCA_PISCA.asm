; FUNCIONA
; Pisca Pisca de um LED controlando a frequência com ciclos de máquina

#INCLUDE <P16F628A.INC>

#DEFINE LED PORTB, 0

VALOR EQU 0X20
VALOR1 EQU 0X21


ORG 0 
GOTO MAIN
ORG 0X04
RETFIE

MAIN:

BANKSEL TRISB     ; Adentro ao banco do registrador TRISB
MOVLW B'00000000' ; Coloco todos os PINOSB em modo de OUTPUT
MOVWF TRISB
BANKSEL PORTB     ; Adentro no banco do reg. PORTB e limpo todos os bits para não ocorrer ruídos
CLRF PORTB        ; Uma maneira de setar todos os bits de um reg. como 0

FREQ:             ; Função responsável pelo pisca pisca do LED

BCF LED           ; Coloco o Led (Portab 0) em off
CALL ATRASO

BSF LED           ; Coloco o Led (Portab 0) em on
CALL ATRASO

GOTO FREQ         ; Faz com que não tenha perigo de eu pular a instrução do piscas-pisca

ATRASO:          ; Função responsável por gastar tempo no ciclo de interações

MOVLW D'170'
MOVWF VALOR

LOOP:

MOVLW D'250'
MOVWF VALOR1

LOOP2: ; Lógica de enlaçamentos, onde o LOOP1 vai fazer que o LOOP2 se repita VALOR vezes

DECFSZ VALOR1 ; Decremento o VALOR1 e pulo GOTO LOOP2 caso VALOR1 = 0 /// (GASTOS: 251 ciclos)
GOTO LOOP2    ; Retorno ao inicio do LOOP2 /// (GASTOS: 498 ciclos)

DECFSZ VALOR ; Decremento o VALOR e pulo GOTO LOOP casp VALOR = 0 /// (GASTOS:  171 ciclos)
GOTO LOOP    ; GOTO responsável por renovar o conteúdo do VALOR1 enquanto VALOR for diferente de  0 /// (GASTOS: 336 ciclos)
           
RETURN       ; Retorno ao CALL ATRASO, com o tempo gasto necessário  para fazer o LED piscar em uma determinada freq

END


; O "DECFSZ VALOR" E "GOTO LOOP1" vão ser repetidos no caso, 170 vezes. Utilzizando-se da contagem de ciclo de maquina que cada instrução consome, consigo configurar a freq do LED. 

; Cálculo da Freq

;(749 * 170) + 507 = 127.837 ciclos   
; 127.837 * Tempo do ciclo de máquina
; 127.837 * 4us = 0.51136s              (Tempo que o led ficará ligado ou desligado, configurando em um período de 1s), LOGO...
; Aproximadamente a frequência é de 1 HZ


; OBS: Neste caso a frequência do oscilador do processador é 1 MHZ