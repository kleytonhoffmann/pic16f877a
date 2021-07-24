;------------------------------------------------------------------------------
;   CABEÇALHO PROGRAMA ASSEMBLY
;------------------------------------------------------------------------------
;   AUTOR:
;   DATA:
;   CONTROLE DE REVISÕES:
;------------------------------------------------------------------------------
#INCLUDE <P16F877A.INC>
;------------------------------------------------------------------------------
;   BITS DE CONFIGURAÇÃO
;------------------------------------------------------------------------------
;   CONFIG
; __config 0xFF79
 __CONFIG _FOSC_XT & _WDTE_OFF & _PWRTE_ON & _BOREN_ON & _LVP_OFF & _CPD_OFF & _WRT_OFF & _CP_OFF
; FOSC  - Seleção tipo oscilador.
; WDTE  - Watchdog timer.
; PWRTE - Power on timer (72ms após energização).
; BOREN - Brown-out enable, proteção contra baixa tensão.
; LVP   - Low voltage programming.
; CPD   - Code protect da EEPROM.
; WRT   - Write protection da memória flash.
; CP    - Code protect memória de programa.

__IDLOCS H'1234'
;------------------------------------------------------------------------------
;   PAGINAÇÃO DE MEMÓRIA (MACROS)
;------------------------------------------------------------------------------
BANK0   MACRO
            BCF     STATUS,RP0
            BCF     STATUS,RP1
        ENDM

BANK1   MACRO
            BSF     STATUS,RP0
            BCF     STATUS,RP1
        ENDM

BANK2   MACRO
            BCF     STATUS,RP0
            BSF     STATUS,RP1
        ENDM

BANK3   MACRO
            BSF     STATUS,RP0
            BSF     STATUS,RP1
        ENDM
;ESCRITA EEPROM
ORG H'2100'
DE  .0,.1,.2,.3,.4,.15,.6,.7,.8,.9,.11

;------------------------------------------------------------------------------
;   VARIÁVEIS
;------------------------------------------------------------------------------
    CBLOCK 0X20
        FLAG
        DEBOUNCE_BT1
        COUNT
        SERIAL
        TEMP
        COMP
        RESULTADO_ALTO
        RESULTADO_BAIXO
        NUM_A
        NUM_B
        COUNT_SUB
        COMP_2
        ACCaLO
        ACCaHI
        ACCbLO
        ACCbHI
        ACCcLO
        ACCcHI
        ACCdLO
        ACCdHI
        mulplr
        mulcnd
        H_byte
        L_byte
		DADO
		ENDERECO
		n1
		n2
		A
    ENDC
        STATUS_TEMP     EQU     0X70
        W_TEMP          EQU     0X71
        PCLATH_TEMP     EQU     0X72
;   OUTRA FORMA DE ALOCAR VARIÁVEIS NA MEMÓRIA
;        DEBOUNCE_BT1      EQU     0X20
;        COUNT             EQU     0X21
;        FLAGS             EQU     0X22
;------------------------------------------------------------------------------
;   CONSTANTES
;------------------------------------------------------------------------------
;   CONSTANTES UTILIZADAS PELO SISTEMA
        CONSTANTE_1   EQU .131
        CONSTANTE_2   EQU .125
        CONSTANTE_3   EQU .10
;------------------------------------------------------------------------------
;   ENTRADAS
;------------------------------------------------------------------------------
;   PINOS QUE SERÃO UTILIZADOS COMO ENTRADA
#DEFINE BOTAO1  PORTB,2
;------------------------------------------------------------------------------
;   SAÍDA
;------------------------------------------------------------------------------
;   PINOS QUE SERÃO UTILIZADOS COMO SAÍDA
#DEFINE LED1    PORTB,0
#DEFINE LED2    PORTB,1
;------------------------------------------------------------------------------
;   VETOR DE RESET
;------------------------------------------------------------------------------
    ORG 0x00    ;ENDEREÇO INICIAL DE PROCESSAMENTO
    GOTO INICIO
;------------------------------------------------------------------------------
;   INTERRUPÇÃO
;------------------------------------------------------------------------------
; AS INTERRUPÇÕES NÃO SERÃO UTILIZADAS
    ORG 0X04    ;ENDEREÇO INICIAL DA INTERRUPÇÃO
; SALVAR O CONTEUDO DOS REGISTRADORES WORK E STATUS
    BCF     INTCON,GIE
SALVA_REGS
    MOVWF W_TEMP            ;COPIA W PARA W_TEMP
    SWAPF STATUS,W          ;SWAP STATUS PARA SER SALVO EM STATUS_TEMP
    BANK0
    MOVWF STATUS_TEMP       ;SALVA O STATUS, PARA STATUS TEMPO NO BANK0
    MOVF PCLATH, W          ;SOMENTE REQUERIDO SE ESTIVER UTILIZANDO BANCO 1,2 E/OU 3
    MOVWF PCLATH_TEMP       ;SALVA PCLATH_TEMP
    CLRF PCLATH             ;PÁGINA 0, INDEPENDENTE DA PÁGINA ATUAL
;-------------------------------------------------------------------------------
; TRATAMENTO DAS INTERRUPÇÕES
    BTFSC   PIR1,TMR1IF     ;INTERRUPÇÃO DE ESTOURO DE TMR1?
    GOTO    TRATA_TMR1      ;SIM, DESVIA
    BTFSC   PIR1,EEIF       ;NÃO, INTERRUPÇÃO DE FIM DE ESCRITA NA EEPROM?
    GOTO    TRATA_EEPROM
    GOTO    RESGATA_REGS
;-------------------------------------------------------------------------------
; ROTINA TRATAMENTO DE INTERRUPÇÃO POR ESTOURO TMR1   
TRATA_TMR1
    BCF     PIR1,TMR1IF     ;APAGA FLAG DE SINALIZAÇÃO DE ESTOURO DO TMR1
    MOVLW   H'DC'
    MOVWF   TMR1L
    MOVLW   H'0B'
    MOVWF   TMR1H
    BSF     FLAG,1

    GOTO    RESGATA_REGS   ;RESGATA REGISTRADORES E RETORNA

    RETFIE      ;RETORNA DA INTERRUPÇÃO
;-------------------------------------------------------------------------------
; ROTINA TRATAMENTO DE INTERRUPÇÃO FIM DE ESCRITA NA EEPROM
    BCF     PIR1,EEIF       ;APAGA FLAG DE SINALIZAÇÃO FIM DE ESCRITA NA EEPROM
TRATA_EEPROM
    ;ROTINA

    GOTO    RESGATA_REGS   ;REGASTA REGISTRADORES E RETORNA
;-------------------------------------------------------------------------------
; RESGATA CONTEUDO DOS REGISTRADORES WORK E STATUS
RESGATA_REGS
    MOVF PCLATH_TEMP, W     ;RESTAURA PCLATH
    MOVWF PCLATH            ;MOVE W PARA PCLATH
    SWAPF STATUS_TEMP,W     ;SWAP STATUS_TEMP E GUARDA NO W
    MOVWF STATUS            ;MOVE W PARA O STATUS
    SWAPF W_TEMP,F          ;SWAP W_TEMP
    SWAPF W_TEMP,W          ;SWAP W_TEMP E RETORNA SEU VALOR PARA W
    BSF   INTCON,GIE
    RETFIE                  ;RETORNA DA INTERRUPÇÃO
;-----------------------------------------------------------------------------
; INÍCIO
;-----------------------------------------------------------------------------
INICIO
    BANK1
    MOVLW   0b00000010
    MOVWF   TRISA

    MOVLW   B'00000100'
    MOVWF   TRISB

    MOVLW   B'00000000'
    MOVWF   TRISC

    MOVLW   B'00000000'
    MOVWF   TRISD

    MOVLW   B'10000100'
    MOVWF   OPTION_REG

    MOVLW   B'00000000'
    MOVWF   INTCON

    MOVLW   B'00000001'
    MOVWF   PIE1
    BANK0
    MOVLW   B'00000111'
    MOVWF   CMCON

    MOVLW   B'00110001'
    MOVWF   T1CON

;-----------------------------------------------------------------------------
; INICIALIZAÇÃO DE VARIÁVEIS
;-----------------------------------------------------------------------------
    CLRF    PORTA
    CLRF    PORTB
    MOVLW   b'10010010'
    MOVWF   SERIAL
    MOVLW   .10
    MOVWF   COMP
    MOVLW   b'10001001'
    MOVWF   NUM_A
    MOVLW   b'00001001'
    MOVWF   NUM_B
    MOVLW   .15
    MOVWF   COUNT_SUB
    MOVLW   .10
    MOVWF   COMP_2
    MOVLW   B'00000000'
    MOVWF   FLAG
;------------------------------------------------------------------------------
; ROTINA PRINCIPAL
;------------------------------------------------------------------------------
MAIN

;	BTFSC	PORTB,2
;	GOTO	$-1

;	CALL    DELAY_TMR1

;	BCF		LED1

;	CALL    DELAY_TMR1

;	BSF    	LED1
	
;	MOVLW	0X05		;DA O ENDEREÇO
;	CALL	LE_EEPROM

;	NOP

;	MOVLW	0X05
;	MOVWF	ENDERECO
;	MOVLW	0XAA
;	MOVWF	DADO
	
;	CALL	ESCREVE_EEPROM
;	MOVLW 	.10
;	MOVWF	n2
;	MOVLW	.5
;	MOVWF	n1
;	MOVF	n2,w
;	SUBWF	n1,w
;	BTFSC	STATUS,Z
;	GOTO	n1IGUALn2
;	BTFSC	STATUS,C
;	GOTO	n1MAIORn2
;	GOTO	n1MENORn2

;	n1MAIORn2
;	n1IGUALn2
;	n1MENORn2
	
	MOVLW .12
	MOVWF A
	MOVLW .10
	SUBWF A,W
	BTFSS STATUS,C
	GOTO IGUAL_1
	BTFSS STATUS,Z
	GOTO MAIOR_1
	GOTO MENOR_1



	MAIOR_1
	GOTO    MAIN

	MENOR_1
	GOTO    MAIN

	IGUAL_1
	GOTO    MAIN


;	GOTO    MAIN
;------------------------------------------------------------------------------
; SUBROTINAS
;------------------------------------------------------------------------------
SUB_COMP_2  ;COUNT_SUB - 35
    COMF    COUNT_SUB,F
    INCF    COUNT_SUB,F
    MOVLW   .35
    ADDWF   COUNT_SUB,F
    BTFSC   STATUS,C
    GOTO    RESULT_ZERO
RESULT_POSITIVO
    COMF    COUNT_SUB,F
    INCF    COUNT,F
    RETLW   .1
RESULT_ZERO
    MOVF    COUNT_SUB,W
    BTFSS   STATUS,Z
    GOTO    RESULT_NEGATIVO
    RETLW   .0
RESULT_NEGATIVO
    RETLW   .2
;------------------------------------------------------------------------------
SOMA_2_BYTES
    CLRF    RESULTADO_ALTO
    MOVF    NUM_A,W
    ADDWF   NUM_B,2
    MOVWF   RESULTADO_BAIXO
    BTFSC   STATUS,C
    GOTO    RESULT_9BITS
    RETURN
RESULT_9BITS
    INCF    RESULTADO_ALTO
    RETURN
;------------------------------------------------------------------------------
GERA_PARIDADE_PAR
    MOVLW   .8
    MOVWF   COUNT
    MOVF    SERIAL,W
    MOVWF   TEMP
    CLRW
LOOP
    BCF     STATUS,C
    RRF     TEMP,F
    BTFSC   STATUS,C
    GOTO    TESTA_W
    DECFSZ  COUNT,F
    GOTO    LOOP
    RETURN
TESTA_W
    XORLW   .1
    DECFSZ  COUNT,F
    GOTO    LOOP
    RETURN
;-------------------------------------------------------------------------------
COMPARA_VALOR_150
    MOVF    COMP,W
    ADDLW   .106
    BTFSS   STATUS,C
    GOTO    MENOR
    BTFSS   STATUS,Z
    GOTO    MAIOR
    GOTO    IGUAL
MENOR
    RETURN
MAIOR
    RETURN
IGUAL
    RETURN
;-------------------------------------------------------------------------------
COMPARA_VALOR_10
    MOVLW   .10
    SUBWF   COMP_2,W
    BTFSS   STATUS,C
    RETLW   .1
    BTFSS   STATUS,Z
    RETLW   .2
    RETLW   .0
;-------------------------------------------------------------------------------
CONV_DISP
ADDWF   PCL,F
RETLW   B'00111111' ;0
RETLW   B'00000110' ;1
RETLW   B'01011011' ;2
RETLW   B'01001111' ;3
RETLW   B'01100110' ;4
RETLW   B'01101101' ;5
RETLW   B'01111101' ;6
RETLW   B'00000111' ;7
RETLW   B'01111111' ;8
RETLW   B'01100111' ;9
RETLW   B'01110111' ;A
RETLW   B'01111100' ;B
RETLW   B'00111001' ;C
RETLW   B'01011110' ;D
RETLW   B'01111001' ;E
RETLW   B'01110001' ;F
;-------------------------------------------------------------------------------
CONV_DISP_BCD
    ADDWF   PCL,F
RETLW   B'00000000' ;0
RETLW   B'00000001' ;1
RETLW   B'00000010' ;2
RETLW   B'00000011' ;3
RETLW   B'00000100' ;4
RETLW   B'00000101' ;5
RETLW   B'00000110' ;6
RETLW   B'00000111' ;7
RETLW   B'00001000' ;8
RETLW   B'00001001' ;9
;-------------------------------------------------------------------------------
DELAY
    BANK0
    MOVLW   .20
    MOVWF   COUNT
    MOVLW   .131
    MOVWF   TMR0
DELAY_1
    BTFSS   INTCON,T0IF
    GOTO    $-1
    BCF     INTCON,T0IF
    MOVLW   .131
    MOVWF   TMR0
    DECFSZ  COUNT,F
    GOTO    DELAY_1
    RETURN
;-------------------------------------------------------------------------------
DELAY_TMR1
    BANK0
    MOVLW   H'DC'
    MOVWF   TMR1L
    MOVLW   H'0B'
    MOVWF   TMR1H
    MOVLW   .1
    MOVWF   COUNT
DELAY_T
    BTFSS   FLAG,1
    GOTO    $-1
    BCF     FLAG,1
    DECFSZ  COUNT,F
    GOTO    DELAY_T
    RETURN

;-------------------------------------------------------------------------------
;   ROTINA DE DIVISÃO
;-------------------------------------------------------------------------------
; DOUBLE PRECISION DIVISION
;-------------------------------------------------------------------------------

; DIVISION: ACCb(16 bits)/ACCa(16 bits) -> ACCb(16bits) with
; Remainder in ACCc(16bits)
;   (a) Load the Denominator in location ACCaHi & ACCaLO (16 bits)
;   (b) Load the Numerator in location ACCbHI & ACCBLO (16 bits)
;   (c) CALL D_dif
;   (d) The 16 bit result is in location ACCbHI & ACCbLO
;   (e) The 16 bit Remainder is in locations ACCcHI & ACCcLO
; VARIÁVEIS USADAS:
;   ACCaLO
;   ACCaHI
;   ACCbLO
;   ACCbHI
;   ACCcLO
;   ACCcHI
;   ACCdLO
;   ACCdHI
;   TEMP
;-------------------------------------------------------------------------------
D_divF
    MOVLW   .16
    MOVWF   TEMP    ;CARREGA CONTADOR PARA DIVISÃO

    MOVF    ACCbHI,W
    MOVWF   ACCdHI
    MOVF    ACCbLO,W
    MOVWF   ACCdLO  ;SALVA ACCb EM ACCd

    CLRF    ACCbHI
    CLRF    ACCbLO  ;LIMPA ACCb

    CLRF    ACCcHI
    CLRF    ACCcLO  ;LIMPA ACCc

DIV
    BCF     STATUS,C
    RLF     ACCdLO,F
    RLF     ACCdHI,F
    RLF     ACCcLO,F
    RLF     ACCcHI,F

    MOVF    ACCaHI,W
    SUBWF   ACCcHI,W    ;VE SE A>C
    BTFSS   STATUS,Z
    GOTO    NOCHK
    MOVF    ACCaLO,W
    SUBWF   ACCcLO,W    ;SE MSB IGUAL ENTÃO CHECA LSB
 NOCHK
    BTFSS   STATUS,C    ;CARRY = 1 SE C>A
    GOTO    NOGO
    MOVF    ACCaLO,W    ;C-A = C
    SUBWF   ACCcLO,F
    BTFSS   STATUS,C
    DECF    ACCcHI,F
    MOVF    ACCaHI,W
    BSF     STATUS,C
NOGO
    RLF     ACCbLO,F
    RLF     ACCbHI,F

    DECFSZ  TEMP,F      ;FIM DA DIVISÃO?
    GOTO    DIV         ;NÃO - VOLTA P/ DIV
                        ;SIM
    RETURN              ;RETORNA
;-------------------------------------------------------------------------------
;   ROTINA DE MULTIPLICAÇÃO
;-------------------------------------------------------------------------------
; 8X8 SOFTWARE MULTIPLIER
; (FAST VERSION: STRAIGHT LINE CODE)
;-------------------------------------------------------------------------------
;
; The 16 bit result is stored in 2 bytes
; Before calling the subroutine "mpy", the multiplier should
; be loaded in location "mulplr", and the multiplicand in
; "mulcnd". The 16 bit result is stored in locations
; H_byte & L_byte.
;   VARIÁVEIS USADAS:
;   mulplr
;   mulcnd
;   H_byte
;   L_byte

; Performance:
; Program memory: 37 locations
; # of cycles: 38
; Scratch RAM: 0 locations
;-------------------------------------------------------------------------------
; Define a macro for adding & right shifting
;-------------------------------------------------------------------------------

mult    MACRO   bit ;Begin macro
    BTFSC   mulplr,bit
    ADDWF   H_byte,F
    RRF     H_byte,F
    RRF     L_byte,F
ENDM                ;End of macro

; Begin Multiplier Routine
mpy_F
    CLRF    H_byte
    CLRF    L_byte
    MOVF    mulcnd,W    ; Move o multiplicando para W
    BCF     STATUS,C    ; Limpa o bit carry

    mult    0
    mult    1
    mult    2
    mult    3
    mult    4
    mult    5
    mult    6
    mult    7

RETURN

LE_EEPROM
BANK2
MOVWF	EEADR
BANK3
BCF		EECON1,EEPGD
BSF		EECON1,RD
BANK2
MOVF	EEDATA,W
RETURN

ESCREVE_EEPROM
BANK3
BTFSC 	EECON1,WR
GOTO	$-1
BANK2
MOVF	ENDERECO,W
MOVWF	EEADR
MOVF	DADO,W
MOVWF	EEDATA
BANK3
BCF		EECON1,EEPGD
BSF		EECON1,WREN
;BCF		INTCON,GIE
MOVLW	0X55
MOVWF	EECON2
MOVLW	0XAA
MOVWF	EECON2
BSF		EECON1,WR
;BCF		INTCON,GIE
BCF		EECON1,WREN

;BTFSC 	EECON1,WR
;GOTO	$-1
RETURN

END
;-------------------------------------------------------------------------------

