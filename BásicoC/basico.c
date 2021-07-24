/*Ao clicar no BOTAO1, O LED1 ALTERNA DE ESTADO
*/

#include "xc.h"

#define _XTAL_FREQ 20000000 

#pragma config FOSC = HS, WDTE = OFF, PWRTE = OFF, BOREN = OFF, LVP = OFF
#pragma config CPD = OFF, WRT = OFF, CP = OFF
 
#define BOTAO1 	PORTBbits.RB2
#define BOTAO2 	PORTBbits.RB3
#define LED1 	PORTBbits.RB5
#define LED2	PORTBbits.RB4

int	VAR;
int a[10];
int i;

void main(void)
{
	TRISB = 0b00001100;		
	PORTB = 0x00;	

	INTCONbits.GIE = 0;


//	while(!LIGA);

	while(1) 
	{ 
		LED1 = BOTAO1;

		if(BOTAO2)
		{
			__delay_ms(30);
			if(BOTAO2)
			{
				while(BOTAO2);
				LED2 =~ LED2;
			}
		}

	}
}
