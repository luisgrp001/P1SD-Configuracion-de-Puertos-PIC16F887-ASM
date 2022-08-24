
;**********************************************************************
;                                                                     *
;    Filename:	    ejercicio1.asm                                           *
;    Date:             22/02/2021                                               *
;    File Version:                                                    *
;                                                                     *
;    Author:   LUIS GUSTAVO ROJAS PAREDES                                                       *
;    Company:                                                         *
;                                                                     *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Files Required: P16F887.INC                                      *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Notes:                                                           *
;                                                                     *
;**********************************************************************



list		p=16f887	; list directive to define processor
#include	<p16f887.inc>	; processor specific variable definitions
RESULTADO	EQU 021	;variable que almacena resultado

CBLOCK 0X50
	CounterA,CounterB,CounterC
ENDC

__CONFIG    _CONFIG1, _LVP_OFF & _FCMEN_ON & _IESO_OFF & _BOR_OFF & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT
__CONFIG    _CONFIG2, _WRT_OFF & _BOR21V



;***** VARIABLE DEFINITIONS



;**********************************************************************
	ORG     0x000             ; processor reset vector

	nop
  	goto    CONFIGURA_PTOS              ; go to beginning of program



CONFIGURA_PTOS
	BSF		STATUS,RP0		;Cambio al Bank_1

	MOVLW	0XFF			;Configuro el PORTA como entrada
	MOVWF	TRISA

	MOVLW	0X00			;Configuro el PORTB como salida
	MOVWF	TRISB

	MOVLW	0XFF			;Configuro el PORTC como entrada
	MOVWF	TRISC

	MOVLW	B'01111111'		;Configuro el bit 7 como salida
	MOVWF	TRISD

	BSF		STATUS,RP1		;Cambio al Bank_3
	
	MOVLW	0X00			;Configura PORTA como digital
	MOVWF	ANSEL			

	CLRF	ANSELH			;Configura PORTB como digital

	BCF		STATUS,RP0		;Cambio al Bank_0
	BCF		STATUS,RP1

	CLRF	PORTA			;limpia PORTA
	CLRF	PORTB			;limpia PORTB
	CLRF	PORTC			;limpia PORTC
	CLRF	PORTD			;limpia PORTD

INICIO
	MOVF	PORTA,W			;copia entrada de PORTA en W
	MOVWF	RESULTADO		;copia valor de W en la variable RESULTADO
	MOVF	PORTC,W			;copia entrada de PORTC en W
	ADDWF	RESULTADO		;suma valor de W a RESULTADO  y lo almacena en RESULTADO
	MOVF	RESULTADO,W		;copia valor de RESULTADO en W
	MOVWF	PORTB			;copia valor de W en PORTB
	BTFSS	STATUS,C		;probar bandera C
	;GOTO	RETARDO_400ms
	GOTO	SIN_ACARREO		;si la bandera C está en 0, dirige a SIN_ACARREO
	BSF		PORTD,7			;si la bandera C está en 1, inserta un 1 en el bit 7 del PORTD
	GOTO 	INICIO			;retorno a INICIO
	
SIN_ACARREO
	BCF		PORTD,7			;limpia el bit 7 del PORTD
	GOTO	INICIO			;retorno a INICIO


;RETARDO_400ms
	;PIC Time Delay = 0.40000100 s with Osc = 4000000 Hz
;		movlw	D'3'
;		movwf	CounterC
;		movlw	D'8'
;		movwf	CounterB
;		movlw	D'118'
;		movwf	CounterA
;loop	decfsz	CounterA,1
;		goto	loop
;		decfsz	CounterB,1
;		goto	loop
;		decfsz	CounterC,1
;		goto	loop
;		retlw	0
;		RETURN

END                       ; directive 'end of program'

