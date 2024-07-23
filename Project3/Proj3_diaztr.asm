TITLE Project 3 - Data Validation, Looping, and Constants     (Proj3_diaztr.asm)

; Author: Troy Diaz
; Last Modified: 7/22/2024
; OSU email address: diaztr@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 3               Due Date: 7/21/2024
; Description: A MASM program that returns the maximum, minimum, average, and
; sum of valid numbers between [-200,-100] or [-50,-1] (inclusive). 

INCLUDE Irvine32.inc

LOWBOUND_1 = -200		; Upper and lower bounds
UPBOUND_2 = -100

LOWBOUND_3 = -50
UPBOUND_4 = -1

.data

intro_1		BYTE "Welcome to the Integer Accumulator by Troy Diaz",0
intro_2		BYTE "We will be accumulating user-input negative integers between the specified bounds, then displaying",0
intro_3		BYTE " statistics of the input values including minimum, maximum, and average values values, total sum, and",0
intro_4		BYTE " total number of valid inputs.",0

greetings_1 BYTE "Hello there, ",0
prompt_1	BYTE "What is your name? ",0
prompt_2	BYTE "Please enter numbers in [-200, -100] or [-50, -1].",0
prompt_3	BYTE "Enter a non-negative number when you are finished to see results.",0
prompt_4	BYTE "Enter number: ",0

userName	BYTE 17 DUP(0)
inputValue	SDWORD ?		; User entered number

max			DWORD ?			; Calculated values
min			DWORD ?
sum			DWORD ?
avg			DWORD ?
count		DWORD ?	
remainder	DWORD ?		

maxNum		BYTE "The maximum valid number is ",0	
minNum		BYTE "The minimum valid number is ",0
sumNum		BYTE "The sum of your valid number is ",0
avgNum		BYTE "The rounded average is ",0

errorMsg	BYTE "Number Invalid!",0
validMsg	BYTE "You entered ",0
validMsg_2  BYTE " valid numbers.",0
noNumMsg	BYTE "You need at least one number entered before submitting!",0

goodbye BYTE "We have to stop meeting like this. Farewell, ",0

.code
main PROC

; -----------------------------
; Initialize variables

; -----------------------------

  mov		inputValue, -1				; Negative for while loop
  mov		sum, 0
  mov		avg, 0
  mov		count, 0
  mov		remainder, 0

; -----------------------------
; Introduces the user to the program and gets their name.
; Greets them using their name.

; -----------------------------

  mov		EDX, OFFSET intro_1			; Introduce user to the program
  call		WriteString
  call		CrLf

  mov		EDX, OFFSET intro_2
  call		WriteString
  mov		EDX, OFFSET intro_3
  call		WriteString
  mov		EDX, OFFSET intro_4
  call		WriteString
  call		CrLf

  mov		EDX, OFFSET prompt_1		; Get user's name
  call		WriteString
  mov		EDX, OFFSET userName
  mov		ECX, 16
  call		ReadString

  mov		EDX, OFFSET greetings_1		; Welcome user
  call		WriteString
  mov		EDX, OFFSET userName
  call		WriteString
  call		CrLf
  call		CrLf

; -----------------------------
; State the bounds and limits of user input. 
; Get user's numbers and check if they are valid.
; Invalid will loop until a valid number is given.
; Entering a non-negative number proceeds to results.

; -----------------------------

  mov		EDX, OFFSET prompt_2
  call		WriteString
  call		CrLf

  mov		EDX, OFFSET prompt_3
  call		WriteString
  call		CrLf

  mov		EAX, inputValue

  mov		EDX, OFFSET prompt_4	; If first num is the max value, store first
  call		WriteString				; and enter while loop
  call		ReadInt
  mov		inputValue, EAX
  mov		max, EAX
  jmp		_initialStart

_whileNumIsNeg:						; While (inputValue < 0)
  mov		EDX, OFFSET prompt_4
  call		WriteString
  call		ReadInt
  mov		inputValue, EAX
 
_initialStart:
  mov		EAX, inputValue
  cmp		EAX, 0					; Exit condition
  jge		_endWhile

  mov		EAX, inputValue			; First condition, inputValue < -200, then error
  cmp		EAX, LOWBOUND_1
  jl		_error

  mov		EAX, inputValue			; Second condition, inputValue <= -100, update values
  cmp		EAX, UPBOUND_2
  jle		_updateData		
  
  mov		EAX, inputValue			; Third condition, inputValue > -100, validate data
  cmp		EAX, UPBOUND_2
  jg		_validateData

_validateData:
  mov		EAX, inputValue			; Fourth condition, if inputValue is > -100 AND
  cmp		EAX, LOWBOUND_3			; < -50, send error
  jl		_error

  mov		EAX, inputValue			; Fifth and last condition, if inputValue is > -50,
  cmp		EAX, LOWBOUND_3			; update values
  jg		_updateData

_updateData:
  inc		count					; For avg calc and two valid numbers

  mov		EAX, inputValue			; Update sum of valid numbers
  add		sum, EAX

  mov		EAX, inputValue			; Update maximum number
  cmp		EAX, min
  jg		_updateMax

  mov		EAX, inputValue			; Update minimum number
  cmp		EAX, min
  jl		_updateMin

_updateMin:
  mov		min, EAX
  jmp		_whileNumIsNeg

_updateMax:
  mov		max, EAX
  jmp		_whileNumIsNeg

_error:
  mov		EDX, OFFSET errorMsg	
  call		WriteString
  call		CrLf
  jmp		_whileNumIsNeg

_zeroNumbers:
  mov		EDX, OFFSET noNumMsg	; Need at least one valid number
  call		WriteString
  call		CrLf
  jmp		_whileNumIsNeg

_endWhile:
  cmp		count, 0
  je		_zeroNumbers

  mov		EAX, sum				; Calculate average
  cdq
  mov		EBX, count
  idiv		EBX						; Signed division
  mov		avg, EAX				; Update average

; -----------------------------
; Display maximum, minimum, sum, and average of valid numbers.

; -----------------------------

_displayResults:
  mov		EDX, OFFSET validMsg	; Display Results
  call		WriteString
  mov		EAX, count
  call		WriteDec
  mov		EDX, OFFSET validMsg_2
  call		WriteString
  call		CrLf

  mov		EDX, OFFSET maxNum		; Max number
  call		WriteString
  mov		EAX, max
  call		WriteInt
  call		CrLf

  mov		EDX, OFFSET minNum		; Min number
  call		WriteString
  mov		EAX, min
  call		WriteInt
  call		CrLf

  mov		EDX, OFFSET sumNum		; Sum of valid numbers
  call		WriteString
  mov		EAX, sum
  call		WriteInt
  call		CrLf

  mov		EDX, OFFSET avgNum		; Average of numbers
  call		WriteString
  mov		EAX, avg
  call		WriteInt
  call		CrLf

  jmp		_goodbye

; -----------------------------
; Say goodbye to the user when the program ends.

; -----------------------------

_goodbye:
  mov		EDX, OFFSET goodbye
  call		WriteString
  mov		EDX, OFFSET userName
  call		WriteString

	Invoke ExitProcess,0			; exit to operating system
main ENDP

END main
