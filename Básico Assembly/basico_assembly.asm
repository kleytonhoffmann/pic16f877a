;------------------------------------------------------------------------------
;   CABE�ALHO PROGRAMA ASSEMBLY
;------------------------------------------------------------------------------
;   AUTOR:
;   DATA:
;   CONTROLE DE REVIS�ES:
;------------------------------------------------------------------------------
#INCLUDE <P16F877A.INC>
;------------------------------------------------------------------------------
;   BITS DE CONFIGURA��O
;------------------------------------------------------------------------------
;   CONFIG
; __config 0xFF79
 __CONFIG _FOSC_HS & _WDTE_OFF & _PWRTE_ON & _BOREN_ON & _LVP_OFF & _CPD_OFF & _WRT_OFF & _CP_OFF
; FOSC  - Sele��o tipo oscilador.
; WDTE  - Watchdog timer.
; PWRTE - Power on timer (72ms ap�s energiza��o).
; BOREN - Brown-out enable, prote��o contra baixa tens�o.
; LVP   - Low voltage programming.
; CPD   - Code protect da EEPROM.
; WRT   - Write protection da mem�ria flash.
; CP    - Code protect mem�ria de programa.
__IDLOCS H'1234'
;------------------------------------------------------------------------------
;   PAGINA��O DE MEM�RIA (MACROS)
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
DE  .1,.1,.1,.1,.1,.3,.6,.7,.8,.9,.11
;------------------------------------------------------------------------------
;   VARI�VEIS
;------------------------------------------------------------------------------
    CBLOCK 0X20
		TEMPO1	
		TEMPO2
		X
    ENDC
;   OUTRA FORMA DE ALOCAR VARI�VEIS NA MEM�RIA
        DEBOUNCE_BT1      RES	1
        COUNT             EQU     0X24
        FLAGS             EQU     0X25
;------------------------------------------------------------------------------
;   CONSTANTES
;------------------------------------------------------------------------------
;   CONSTANTES UTILIZADAS PELO SISTEMA
        CONSTANTE_1   EQU .131
;------------------------------------------------------------------------------
;   ENTRADAS
;------------------------------------------------------------------------------
;   PINOS QUE SER�O UTILIZADOS COMO ENTRADA
#DEFINE BOTAO1  PORTB,2
;------------------------------------------------------------------------------
;   SA�DA
;------------------------------------------------------------------------------
;   PINOS QUE SER�O UTILIZADOS COMO SA�DA
#DEFINE LED1    PORTB,0
#DEFINE BOTAO  	PORTB,7
;------------------------------------------------------------------------------
;   VETOR DE RESET
;------------------------------------------------------------------------------
    ORG 0x00    ;ENDERE�O INICIAL DE PROCESSAMENTO
    GOTO INICIO
;------------------------------------------------------------------------------
;   INTERRUP��O
;------------------------------------------------------------------------------
; AS INTERRUP��ES N�O SER�O UTILIZADAS
    ORG 0X04    ;ENDERE�O INICIAL DA INTERRUP��O
	RETFIE
;-----------------------------------------------------------------------------
; IN�CIO
;-----------------------------------------------------------------------------
   INICIO
   BANK1
   MOVLW   B'10000100'
   MOVWF   TRISB
   BANK0
;-----------------------------------------------------------------------------
; INICIALIZA��O DE VARI�VEIS
;-----------------------------------------------------------------------------
    CLRF    PORTB
;------------------------------------------------------------------------------
; ROTINA PRINCIPAL
;------------------------------------------------------------------------------
MAIN

GOTO    MAIN
;---------------------------------

END