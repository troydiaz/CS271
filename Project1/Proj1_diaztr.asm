TITLE Project 1 - Basic Logic and Arithmetic Program     (Proj1_diaztr.asm)

; Author: Troy Diaz
; Last Modified: 7/7/2024
; OSU email address: diaztr@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 1                Due Date: 7/7/2024
; Description: Elementary MASM programming and integer arithmetic operations.

INCLUDE Irvine32.inc

.data

title_1 BYTE "Elementary Arithmetic	by Troy Diaz",0

firstNum DWORD ?		; User entered numbers
secondNum DWORD ?
thirdNum DWORD ?

result_1 DWORD ?		; A + B
result_2 DWORD ?		; A - B
result_3 DWORD ?		; A + C
result_4 DWORD ?		; A - C
result_5 DWORD ?		; B + C
result_6 DWORD ?		; B - C
result_7 DWORD ?		; A + B + C

addition BYTE " + ",0
subtraction BYTE " - ",0
equalsign BYTE " = ",0

intro_1 BYTE "Enter 3 numbers A > B > C, and I'll show you the sums and differences.",0
prompt_1 BYTE "First number: ",0
prompt_2 BYTE "Second number: ",0
prompt_3 BYTE "Third number: ",0

goodbye BYTE "Thanks for using Elementary Arithmetic! Goodbye!",0

.code
main PROC

; Introduction

	mov		EDX, OFFSET title_1
	call	WriteString
	call	CrLf

	mov		EDX, OFFSET intro_1
	call	WriteString
	call	CrLf

; Get user's numbers (data)

	mov		EDX, OFFSET prompt_1
	call	WriteString
	call	ReadDec
	mov		firstNum, EAX

	mov		EDX, OFFSET prompt_2
	call	WriteString
	call	ReadDec
	mov		secondNum, EAX

	mov		EDX, OFFSET prompt_3
	call	WriteString
	call	ReadDec
	mov		thirdNum, EAX
	call	CrLf

; Calculate addition and subtraction of three numbers
	
	mov		EAX, firstNum		; A + B
	mov		EBX, secondNUM
	add		EAX, EBX
	mov		result_1, EAX

	mov		EAX, firstNum		; A - B
	mov		EBX, secondNUM
	sub		EAX, EBX
	mov		result_2, EAX

	mov		EAX, firstNum		; A + C
	mov		EBX, thirdNum
	add		EAX, EBX
	mov		result_3, EAX

	mov		EAX, firstNum		; A - C
	mov		EBX, thirdNum
	sub		EAX, EBX
	mov		result_4, EAX

	mov		EAX, secondNum		; B + C
	mov		EBX, thirdNum
	add		EAX, EBX
	mov		result_5, EAX

	mov		EAX, secondNum		; B - C
	mov		EBX, thirdNum
	sub		EAX, EBX
	mov		result_6, EAX

	mov		EAX, firstNum		; A + B + C
	mov		EBX, secondNum
	add		EAX, EBX
	mov		EBX, thirdNum
	add		EAX, EBX
	mov		result_7, EAX

; Dispplay the results
	
	mov		EAX, firstNum		; A + B = sum
	call	WriteDEC
	mov		EDX, OFFSET addition
	call	WriteString
	mov		EAX, secondNum
	call	WriteDec
	mov		EDX, OFFSET equalsign
	call	WriteString
	mov		EAX, result_1
	call	WriteDEC
	call	CrLf

	mov		EAX, firstNum		; A - B = difference
	call	WriteDEC
	mov		EDX, OFFSET subtraction
	call	WriteString
	mov		EAX, secondNum
	call	WriteDec
	mov		EDX, OFFSET equalsign
	call	WriteString
	mov		EAX, result_2
	call	WriteDEC
	call	CrLf

	mov		EAX, firstNum		; A + C = sum
	call	WriteDEC
	mov		EDX, OFFSET addition
	call	WriteString
	mov		EAX, thirdNum
	call	WriteDec
	mov		EDX, OFFSET equalsign
	call	WriteString
	mov		EAX, result_3
	call	WriteDEC
	call	CrLf

	mov		EAX, firstNum		; A - C = difference
	call	WriteDEC
	mov		EDX, OFFSET subtraction
	call	WriteString
	mov		EAX, thirdNum
	call	WriteDec
	mov		EDX, OFFSET equalsign
	call	WriteString
	mov		EAX, result_4
	call	WriteDEC
	call	CrLf

	mov		EAX, secondNum		; B + C = sum
	call	WriteDEC
	mov		EDX, OFFSET addition
	call	WriteString
	mov		EAX, thirdNum
	call	WriteDec
	mov		EDX, OFFSET equalsign
	call	WriteString
	mov		EAX, result_5
	call	WriteDEC
	call	CrLf

	mov		EAX, secondNum		; B - C = difference
	call	WriteDEC
	mov		EDX, OFFSET subtraction
	call	WriteString
	mov		EAX, thirdNum
	call	WriteDec
	mov		EDX, OFFSET equalsign
	call	WriteString
	mov		EAX, result_6
	call	WriteDEC
	call	CrLf

	mov		EAX, firstNum		; A + B + C = sum
	call	WriteDec
	mov		EDX, OFFSET addition
	call	WriteString
	mov		EAX, secondNum
	call	WriteDec
	mov		EDX, OFFSET addition
	call	WriteString
	mov		EAX, thirdNum
	call	WriteDEC
	mov		EDX, OFFSET equalsign
	call	WriteString
	mov		EAX, result_7
	call	WriteDEC
	call	CrLf
	
; Say goodbye
	
	call	CrLf
	mov		EDX, OFFSET goodbye
	call	WriteString
	call	CrLf

	Invoke ExitProcess,0	; exit to operating system
main ENDP

END main
