TITLE Program Template     (template.asm)

; Author: Troy Diaz
; Last Modified: 7/1/2024
; OSU email address: ONID_ID@oregonstate.edu
; Course number/section:   CS271 Section ???
; Project Number:                 Due Date:
; Description: This file is provided as a template from which you may work
;              when developing assembly projects in CS271.

INCLUDE Irvine32.inc

; (insert macro definitions here)

; (insert constant definitions here)

DOG_FACTOR = 7

.data

; (insert variable definitions here)

userName BYTE 33 DUP(0) ; this string is length 33 with 0s
userAge DWORD ? ; age by user
intro_1 BYTE "Hi, my name is Troy, and I'm here top tell you your age in dog years!",0
prompt_1 BYTE "What's your name? ",0
intro_2 BYTE "Nice to meet you, ",0
prompt_2 BYTE "What's your age? ",0
dogAge DWORD ? ; to be calculated
result_1 BYTE "Wow, that's ",0
result_2 BYTE " in dog years!",0
goodbye BYTE "So long and farewell, ",0

.code
main PROC

; Introduce Programmer

	mov		EDX, OFFSET intro_1
	call	WriteString
	call	CrLf

; Get user's name

	mov		EDX, OFFSET prompt_1
	call	WriteString
	; preconditions of readstring: 1) length max saved in ECX, 2) EDX holds pointer to string
	mov		EDX, OFFSET userName
	mov		ECX, 32 ;need space for null terminator
	call	ReadString

; Get user's age

	mov		EDX, OFFSET prompt_2
	call	WriteString
	;get unsigned value, preconditions of ReadDec:
	call	ReadDec
	; Postconditions of ReadDec: value is saved in EAX
	mov		userAge, EAX

; Calculate age in dog years

	mov		EAX, userAge ; best practice, preconditions are satisfied before doing calculations cuz someone can put stuff into userage
	mov		EBX, DOG_FACTOR ; move constant into another register
	mul		EBX
	mov		dogAge, EAX



; Report the result

	mov		EDX, OFFSET result_1
	call	WriteString
	mov		EAX, dogAge
	call	WriteDEC ;using this call instead of string bc it'll do +0 and -0
	mov		EDX, OFFSET result_2
	call	WriteString
	call	CrLf

; Say goodbye

	mov		EDX, OFFSET goodbye
	call	WriteString
	mov		EDX, OFFSET userName
	call	WriteString
	call	CrLf

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
