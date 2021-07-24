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
 __CONFIG _FOSC_HS & _WDTE_OFF & _PWRTE_ON & _BOREN_ON & _LVP_OFF & _CPD_OFF & _WRT_OFF & _CP_OFF
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
DE  .1,.1,.1,.1,.1,.3,.6,.7,.8,.9,.11
;------------------------------------------------------------------------------
;   VARIÁVEIS
;------------------------------------------------------------------------------
    CBLOCK 0X20
		TEMPO1	
		TEMPO2
		X
    ENDC
;   OUTRA FORMA DE ALOCAR VARIÁVEIS NA MEMÓRIA
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
;   PINOS QUE SERÃO UTILIZADOS COMO ENTRADA
#DEFINE BOTAO1  PORTB,2
;------------------------------------------------------------------------------
;   SAÍDA
;------------------------------------------------------------------------------
;   PINOS QUE SERÃO UTILIZADOS COMO SAÍDA
#DEFINE LED1    PORTB,0
#DEFINE BOTAO  	PORTB,7
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
	RETFIE
;-----------------------------------------------------------------------------
; INÍCIO
;-----------------------------------------------------------------------------
   INICIO
   BANK1
   MOVLW   B'10000100'
   MOVWF   TRISB
   BANK0
;-----------------------------------------------------------------------------
; INICIALIZAÇÃO DE VARIÁVEIS
;-----------------------------------------------------------------------------
    CLRF    PORTB
;------------------------------------------------------------------------------
; ROTINA PRINCIPAL
;------------------------------------------------------------------------------
MAIN

GOTO    MAIN
;---------------------------------

END