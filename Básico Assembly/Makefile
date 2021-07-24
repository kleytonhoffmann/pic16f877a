# MPLAB IDE generated this makefile for use with GNU make.
# Project: basico.mcp
# Date: Thu Aug 02 20:02:23 2018

AS = MPASMWIN.exe
CC = 
LD = mplink.exe
AR = mplib.exe
RM = rm

basico.cof : basico.o
	$(CC) /p16F877A "basico.o" /u_DEBUG /z__MPLAB_BUILD=1 /z__MPLAB_DEBUG=1 /o"basico.cof" /M"basico.map" /W

basico.o : basico.asm ../../../../../../../../Program\ Files\ (x86)/Microchip/MPASM\ Suite/P16F877A.INC
	$(AS) /q /p16F877A "basico.asm" /l"basico.lst" /e"basico.err" /o"basico.o" /d__DEBUG=1

clean : 
	$(CC) "basico.o" "basico.err" "basico.lst" "basico.cof" "basico.hex"

