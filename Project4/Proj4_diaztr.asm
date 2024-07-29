TITLE Nested Loops and Procedures     (Proj4_diaztr.asm)

; Author: Troy Diaz
; Last Modified: 7/28/24
; OSU email address: diaztr@oregonstate.edu
; Course number/section:  CS271 Section 400
; Project Number: 04                Due Date: 7/28/24
; Description: MASM program that calculates prime numbers. Given the amount of prime
; n numbers, this program will print out n prime numbers. The range of this program is [1,200]
; inclusive. 

INCLUDE Irvine32.inc

LOWERBOUND = 1				; Constraints of user input, 1 <= n <= 200
UPPERBOUND = 200

.data

intro			BYTE "Prime Numbers Programmed by Troy Diaz",0

enterNum		BYTE "Enter the number of prime numbers you would like to see.",0
resultant   	BYTE "I'll accept orders for up to 200 primes.",0

prompt			BYTE "Enter the number of primes to display [1 ... 200]: ",0

userNum			DWORD ?		; User entered number
quotient		DWORD ?		; Quotient used for loop
currNum			DWORD ?		; For current number to be printed
count			DWORD ?		; Keep track of how many primes printed in a line
flag			DWORD ?		; True or False


tabMsg			BYTE "   ",0
errorMsg		BYTE "No primes for you! Number out of range. Try again.",0

goodbye			BYTE "Results certified by Troy Diaz. Goodbye.",0

.code
main PROC

; -----------------------------
; Initialize variable

; -----------------------------

  mov		userNum, 0
  mov		currNum, 0
  mov		quotient, 0
  mov		count, 0
  mov		flag, 0

  call		introduction

  call		getUserData

  call		showPrimes	

  call		farewell

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; ---------------------------------------------------------------------------------
; Name: introduction
; 
; Introduces user to the program and explains what it'll output given a number that's 
; within the given range.
;
; Preconditions: none
;
; Postconditions: Displays introduction and instruction messages to user.
;
; Receives: none
; 
; returns: none
; ---------------------------------------------------------------------------------

introduction	PROC

  mov			EDX, OFFSET intro
  call			WriteString
  call			CrLf
  call			CrLf

  mov			EDX, OFFSET enterNum		; Explain what user input should be 
  call			WriteString
  call			CrLf

  mov			EDX, OFFSET resultant		; Explain what program will print out
  call			WriteString
  call			CrLf
  call			CrLf
  
  RET
introduction	ENDP

; ---------------------------------------------------------------------------------
; Name: getUserData
;
; Prompts user for a valid number that is within [1,200] inclusive. Calls the validate
; procedure to ensure number is within those bounds. Stores the valid input into userNum.
; 
; Preconditions: none
;
; Postconditions: Stores user input into userNum.
;
; Receives: none
; 
; returns: none
; ---------------------------------------------------------------------------------

getUserData		PROC

_whileNumIsInvalid:
  mov			EDX, OFFSET prompt
  call			WriteString
  call			ReadInt
  mov			userNum, EAX
  mov			EAX, userNum

  call			validate			; Ensure input is within bounds (1 <= n <= 200)
  mov			EAX, flag
  cmp			EAX, 1
  jne			_whileNumIsInvalid

  RET
GetUserData		ENDP

; ---------------------------------------------------------------------------------
; Name: validate
;
; Sub procedure that ensures a given number is within the lower and upper bounds of
; the program which is 1-200 inclusive. If number is invalid, set flag to be 0 and end procedure.
; If number is valid, store input into userNum and end procedure. Flag is already set to true at start.
; 
; Preconditions: EAX contains a numeric value
;
; Postconditions: Sets flag either to be true or false, contingent on if the number is valid. Stores number if 
; it is valid.
;
; Receives: none
; 
; returns: none
; ---------------------------------------------------------------------------------

validate	 PROC
  
_firstCheck:
  mov		 flag, 1			; Setting flag to true if all test cases are passed
  cmp		 EAX, LOWERBOUND	; First condition, n >= 1
  jge		 _secondCheck
  jmp		 _continue

_secondCheck:
  cmp		 EAX, UPPERBOUND	; Second condition, n <= 200
  jle		 _endValidation

_continue:					
  mov		 EDX, OFFSET errorMsg	
  call		 WriteString
  call		 CrLf
  mov		 flag, 0			; If number is not within bounds, reset flag and prompt again
  
_endValidation:
  mov		 userNum, EAX		; Store user input

  RET
validate	 ENDP

; ---------------------------------------------------------------------------------
; Name: showPrimes
;
; Displays prime numbers given the number of n primes, where n is userNum. Calls sub procedure
; isPrime to check if a number is prime or not. If a number is prime, the prime loop will continue
; until it has reached n primes to be displayed.
; 
; Preconditions: userNum contains a valid number.
;
; Postconditions: Displays n prime numbers up until userNum.
;
; Receives: none
; 
; returns: none
; ---------------------------------------------------------------------------------

showPrimes	 PROC

  call		 CrLf

  cmp		 userNum, 1
  je		 _printOnePrime
  jmp		 _setUpLoop

_printOnePrime:					; First case, user wants 1 prime number
  mov		 EAX, 2
  call		 WriteDec
  call		 CrLf
  jmp		 _endshowPrimesProc

_setUpLoop:						
  mov		 EBX, 2				; Second case, user wants 2 or more prime numbers
  dec		 userNum			; Decrement user input for number of primes since first prime is printed
  mov		 ECX, userNum		; Store into counter register

  mov		 EAX, 2				
  call		 WriteDec
  mov		 EDX, OFFSET tabMsg
  call		 WriteString
  inc		 count				; Increment count for number of primes in a line

_primeLoop:
  mov		 currNum, EBX		; Store current iteration 
  push		 ECX				; Store registers
  push		 EBX
  call		 isPrime			; Check if current iteration is a prime
  cmp		 flag, 0			; If not, increment iteration and check again
  je		 _incrementCurrNum
  jmp		 _printPrime		; If it is, print and continue loop

_printPrime:
  mov		 EAX, currNum		
  call		 WriteDec
  mov		 EDX, OFFSET tabMsg
  call		 WriteString
  inc		 count
  cmp		 count, 10			; If there are more than 10 primes in a line, reset and move to next line
  je		 _resetCount

_continue:
  pop		 EBX				; Restore counters
  inc		 EBX				; Increment iteration
  pop		 ECX
  loop		 _primeLoop			; Decrement ECX and loop again
  jmp		 _endshowPrimesProc

_incrementCurrNum:
  pop		 EBX
  inc		 EBX
  pop		 ECX
  jmp		 _primeLoop
 
 _resetCount:
  call		 CrLf
  mov		 count, 0
  jmp		 _continue

_endshowPrimesProc:
  call		 CrLf
  call		 CrLf

  RET
showPrimes	 ENDP

; ---------------------------------------------------------------------------------
; Name: isPrime
;
; Sub procedure that checks if a number is prime or not. If a number is divisible any number
; between N to N/2, then it is not prime. Checks to see if the remainder is equal to 0.
; Sets a flag that indicates whether a number is prime, either true or false.
; 
; Preconditions: currNum contains a valud greater than 2. 
;
; Postconditions: Sets a flag to be true or false contingent on if the given number is prime or not.
;
; Receives: none
; 
; returns: none
; ---------------------------------------------------------------------------------

isPrime	 PROC

  mov	 flag, 1			; Set flag to be true 
  
  mov	 EAX, currNum		
  mov	 ECX, 2				
  xor	 EDX, EDX			; Clear registers for division
  div	 ECX				; currNum / 2 = N/2
  mov	 quotient, EAX		; Store quotient

  mov	 EBX, 2				; Upper and lower bounds
  mov	 ECX, quotient

_validatePrime:				; Check to see if any number between 2 to N/2 can divide userNum

  mov	 EAX, currNum
  xor	 EDX, EDX
  div	 EBX				; currNum / EBX
  cmp	 EDX, 0				; Check remainder, if it is 0, not prime
  je	 _notPrimeNum
  
  inc	 EBX				; Increment EBX and loop again
  loop	 _validatePrime

_endisPrimeProc:			; If we have reached here, currNum is prime
  RET

_notPrimeNum:
  mov	 flag, 0
  jmp	 _endisPrimeProc

isPrime	 ENDP
 
; ---------------------------------------------------------------------------------
; Name: farewell
;
; Goodbye message to indicate who wrote the program and to tell the user that the program
; has ended.
; 
; Preconditions: none
;
; Postconditions: Displays farewell message to user.
;
; Receives: none
; 
; returns: none
; ---------------------------------------------------------------------------------

farewell	 PROC

  mov		 EDX, OFFSET goodbye
  call		 WriteString
  call		 CrLf
  RET

farewell	 ENDP

END main
