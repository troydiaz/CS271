TITLE Data_Definitions         (Data_Definitions.asm)

; Author: Stephen Redfield
; Course number/section:   CS271 Section ???
; Description: Prompt 1: Write a program that contains a definition of
;	each of the intrinsic data types listed in the Defining Data Exploration.
;	Initialize each variable to a value that is consistent with its data type.

INCLUDE Irvine32.inc

.data
  var1 	BYTE 	100
  var2 	SBYTE 	-5
  var3 	WORD 	7A20h
  var4 	SWORD 	+2000
  var5 	DWORD 	12345678h
  var6 	SDWORD 	-138823
  var7 	FWORD 	0
  var8 	QWORD 	123456789ABCDEF1h
  var9	SQWORD 	0B87972A3CFF00000h
  var10 TBYTE 	554435AAF221CCD510h
  var11	OWORD 	12345678123456781234567812345678h
  var12 REAL4 	-2.5
  var13 REAL8 	2.4E+100
  var14	REAL10 	-2.2233424E-2343

.code
main PROC

	Invoke ExitProcess,0	; exit to operating system
main ENDP

END main