TITLE Project 6 - String Primitives and Macros     (Proj6_diaztr.asm)

; Author: Troy Diaz
; Last Modified: 8/16/24
; OSU email address: diaztr@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 6                Due Date: 8/16/24
; Description: 

INCLUDE Irvine32.inc

; (insert macro definitions here)

ARRAYSIZE = 10		; 10 signed integers
HI = 2147483647		; The integer limit for a 32 bit signed integer
LO = -2147483648

.data

titleMsg		BYTE "PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedure",0
authorMsg		BYTE "Written by: Troy Diaz",0

instructionMsg	BYTE "Please provide 10 signed decimal integers.",0
descMsg_1		BYTE "Each number needs to be small enough to fit inside a 32 bit register. ",0
descMsg_2		BYTE "After you have finished inputting the raw numbers I will display a list of the integers, ",0
descMsg_3		BYTE "their sum, and their average value.",0

signedPrompt	BYTE "Please enter a asigned number: ",0
errorMsg		BYTE "ERROR: You did not enter a signed number or your number was too big.",0
retryPrompt		BYTE "Please try again: ",0

sumMsg			BYTE "The sum of these numbers is: ",0
avgMsg			BYTE "The truncated average is: ",0
displayNums		BYTE "You entered the following numbers: ",0

numsArray		DWORD ARRAYSIZE DUP(?)

goodbyeMsg		BYTE "Thanks for playing!",0

.code
main PROC

; Introduction
  push			OFFSET titleMsg
  push			OFFSET authorMsg
  push			OFFSET instructionMsg
  push			OFFSET descMsg_1
  push			OFFSET descMsg_2
  push			OFFSET descMsg_3
  call			introduction			; 24 Bytes to return

; Get user's signed integers

  call			ReadVal

; Display user's signed integers

  call			WriteVal

; Say goodbye to user
  push			OFFSET goodbyeMsg
  call			farewell				; 4 Bytes to return

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; ---------------------------------------------------------------------------------
; Name: ReadVal
; 
; 
;
; Preconditions: 
;
; Postconditions:
;
; Receives: 
; 
; returns: 
; ---------------------------------------------------------------------------------

ReadVal			PROC
  push			EBP
  mov			EBP, ESP

  mov			ESP, EBP
  pop			EBP

  RET			4
ReadVal			ENDP

; ---------------------------------------------------------------------------------
; Name: WriteVal
; 
; 
;
; Preconditions: 
;
; Postconditions:
;
; Receives: 
; 
; returns: 
; ---------------------------------------------------------------------------------

WriteVal		PROC
  push			EBP
  mov			EBP, ESP

  mov			ESP, EBP
  pop			EBP

  RET			4
WriteVal		ENDP

; ---------------------------------------------------------------------------------
; Name: introduction
; 
; 
;
; Preconditions: 
;
; Postconditions:
;
; Receives: 
; 
; returns: 
; ---------------------------------------------------------------------------------

introduction	PROC
  push			EBP
  mov			EBP, ESP

  mov			EDX, [ESP + 28]
  call			WriteString
  call			CrLf

  mov			EDX, [ESP + 24]
  call			WriteString
  call			CrLf
  call			CrLf

  mov			EDX, [ESP + 20]
  call			WriteString
  call			CrLf

  mov			EDX, [ESP + 16]
  call			WriteString
  call			CrLf

  mov			EDX, [ESP + 12]
  call			WriteString
  call			CrLf

  mov			EDX, [ESP + 8]
  call			WriteString
  call			CrLf
  call			CrLf

  mov			ESP, EBP
  pop			EBP

  RET			24
introduction	ENDP

; ---------------------------------------------------------------------------------
; Name: farewell
; 
; 
;
; Preconditions: 
;
; Postconditions:
;
; Receives: 
; 
; returns: 
; ---------------------------------------------------------------------------------

farewell		PROC
  push			EBP
  mov			EBP, ESP

  mov			EDX, [ESP + 8]
  call			WriteString
  call			CrLf

  mov			ESP, EBP
  pop			EBP

  RET			4
farewell		ENDP

END main
