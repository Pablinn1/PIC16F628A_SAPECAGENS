; Aprender a mexer no Conversor AD

#INCLUDE <P16F877.INC>

    
ORG 0
    GOTO START
ORG 0X04
    RETFIE
START:
    
    BANKSEL TRISC
    MOVLW 0X00
    MOVWF TRISC ; Colocar todas as portas do pinoC como saída
    CLRF ADCON1 ; Limpar o registrador ADCON 

    ; O REGITRADOR ADCON1 é responsável pela configuração do conversor
    ; BIT 7: Configura o formato da conversão A/D, sendo 0 (Left justied) e 1 (Right justified)
    ; BIT 4:0 : Configuração das portas do A/D (seleciono entre Analogico, digital e Vref+ or vref-)
    
    BANKSEL ADCON0
    MOVLW B'01000001'  
    MOVWF ADCON0

    ; Registrador responsável por configurar o conversor
    ; BIT 7:6 : Configuro o clock de conversão | Fosc/x | x = 2 (00) , 8 (01) , 32 (10) e RC (11)
    ; BIT 5:3 : Escolho a porta de entrada analógica (RA = 000) 
    ; BIT 2: Flag que indica se o A/D está operando ou não. 1 = operando; 0 = não operando
    ; BIT 1: Responsável por ligar o A/D

MAIN:
    
    CALL AD_PORTC ; Crio um LOOP de chamada que vai ser responsável por ligar o AD sempre que estiver inoperante
    GOTO MAIN

 AD_PORTC:
    
    BSF ADCON0, GO ; Ativo a operação do A/D  GO é referente ao BIT 2 do ADCON0
   
    
ESPERA:  ; Função que esepra a conversão terminar para ai "imprimir" o resultado na barra de LED
    
    BTFSC ADCON0, GO ; Testo pra ver se o A/D parou de operar
    GOTO ESPERA      ; Caso não tenha, permaneço em um loop de espera
    MOVF ADRESH, W   ; Caso tenha eu jogo o resultado da conversão no meu registrador de trabalho
    MOVWF PORTC      ; E movo para os pinos C
    
 RETURN   ; Retorno ao MAIN, fazendo assim um loop infinito.
    
    END