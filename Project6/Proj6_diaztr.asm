TITLE Project 6 - String Primitives and Macros     (Proj6_diaztr.asm)

; Author: Troy Diaz
; Last Modified: 8/16/24
; OSU email address: diaztr@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 6                Due Date: 8/16/24
; Description: MASM program to take in signed decimal integers from a user and
; display the sum, average, and list of numbers entered. The numbers are first strings that
; converts to integers.

INCLUDE Irvine32.inc

; ---------------------------------------------------------------------------------
; Name: mGetString
;
; Displays a prompt for a user and gets user input. Takes in a string as user input.
;
; Preconditions: EDX and ECX is used for ReadString.
;
; Receives:
; prompt = string to enter a number
; buffer = user input
; inputLen = length of user input 
;
; returns: none.
; ---------------------------------------------------------------------------------
mGetString		MACRO prompt, buffer, inputLen
  pushad

  mov			EDX, prompt
  call			WriteString

  mov			EDX, buffer
  mov			ECX, inputLen
  call			ReadString

  popad
ENDM

; ---------------------------------------------------------------------------------
; Name: mDisplayString
;
; Prints a string, followed by a space character.
;
; Preconditions: EDX is used for WriteString.
;
; Receives:
; printString = string (signed integers)
; spaceChar = character ' '
;
; returns: printed string.
; ---------------------------------------------------------------------------------
mDisplayString	MACRO printString, spaceChar
  pushad

  mov			EDX, printString
  call			WriteString

  mov			EDX, spaceChar
  call			WriteString

  popad
ENDM

ARRAYSIZE = 10			; 10 signed integers
MAX_USER_INPUT = 11		; Maximum integer length for user input

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
tabMsg			BYTE "  ",0
userInput		BYTE  MAX_USER_INPUT DUP(?)

numsArray		SDWORD ARRAYSIZE DUP(?)
sumNum			SDWORD ?
avgNum			SDWORD ?
userInputLen	SDWORD ?
negSign			SDWORD ?
buffer			SDWORD ?

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
  push			OFFSET retryPrompt
  push			OFFSET errorMsg
  push			OFFSET signedPrompt
  push			OFFSET negSign
  push			OFFSET userInputLen
  push			OFFSET userInput
  push			OFFSET numsArray
  call			ReadVal					; 28 Bytes to return

; Display user's signed integers
  push			OFFSET displayNums
  push			OFFSET tabMsg
  push			OFFSET numsArray
  call			WriteVal				; 12 Bytes to return

; Display sum of numbers
  push			OFFSET buffer
  push			OFFSET tabMsg
  push			OFFSET numsArray
  push			OFFSET sumNum
  push			OFFSET sumMsg
  call			displaySum				; 20 Bytes to return

; Display avgerage of numbers
  push			OFFSET buffer
  push			OFFSET tabMsg
  push			OFFSET numsArray
  push			OFFSET avgNum
  push			OFFSET avgMsg
  call			displayAvg				; 20 Bytes to return

; Say goodbye to user
  push			OFFSET goodbyeMsg
  call			farewell				; 4 Bytes to return

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; ---------------------------------------------------------------------------------
; Name: ReadVal
; 
; Gets user input and stores it into an array. 
;
; Preconditions: none.
;
; Postconditions: Fills an array with SDWORDs.
;
; Receives: 
; [EBP + 32] = retryPrompt, rety message to indicate previous input was bad
; [EBP + 28] = errorMsg, handling bad user input
; [EBP + 24] = signedPrompt, message to get user input
; [EBP + 20] = userInputLen, length of user input
; [EBP + 16] = negSign, flag to set negative sign
; [EBP + 12] = userinput, stores user's number
; [EBP + 8] = numsArray, array to hold user numbers
; 
; returns: an array with ARRAYSIZE elements.
; ---------------------------------------------------------------------------------
ReadVal			 PROC
  push			 EBP
  mov			 EBP, ESP
  
  mov			 ECX, ARRAYSIZE			; Looping ARRAYSIZE many times
  mov			 ESI, [EBP + 8]			; Address of numsArray

_displayPrompt:
  mGetString	 [EBP + 24], [EBP + 12], MAX_USER_INPUT
  mov			 EAX, [EBP + 12]		
  mov			 [ESI], EAX				; Store string into array
  add			 ESI, TYPE SDWORD		; Move to next index
  loop			 _displayPrompt

  mov			 ESP, EBP
  pop			 EBP

  RET			 28
ReadVal			 ENDP

; ---------------------------------------------------------------------------------
; Name: WriteVal
; 
; Prints the values inside a given array.
;
; Preconditions: numsArray is not empty.
;
; Postconditions: every element in numsArray is printed.
;
; Receives: 
;
; [EBP + 16] = displayNums, message to user that numbers from array is printed
; [EBP + 12] = tabMsg, space character
; [EBP + 8] = numsArray, array that holds user numbers
; 
; returns: elements printed from numsArray.
; ---------------------------------------------------------------------------------

WriteVal			PROC
  push				EBP
  mov				EBP, ESP

  mov				ESI, [EBP + 8]		; Address of numsArray
  mov				ECX, ARRAYSIZE

  call				CrLf
  mov				EDX, [EBP + 16]	
  call				WriteString
  call				CrLf

_displayLoop:
  mDisplayString	[ESI], [EBP + 12]	; Print string
  add				ESI, TYPE SDWORD	; Move through array
  loop				_displayLoop

  call				CrLf

  mov				ESP, EBP
  pop				EBP

  RET				12
WriteVal			ENDP

; ---------------------------------------------------------------------------------
; Name: displaySum
; 
; Procedure to print the sum of numbers in an array.
;
; Preconditions: numsArray is not empty.
;
; Postconditions: sum is printed.
;
; Receives: 
; 
; [EBP + 24] = buffer, reading from digit to next (convert Str to Int)
; [EBP + 20] = tabMsg, space character
; [EBP + 16] = numsArray, array that holds user numbers
; [EBP + 12] = sumNum, number to hold accumulated sum
; [EBP + 8] = sumMsg, message to indicate sum is printed
; 
; returns: sum of numbers.
; ---------------------------------------------------------------------------------

displaySum		PROC
  push			EBP
  mov			EBP, ESP

  mov			EDX, [EBP + 8]
  call			WriteString
  call			CrLf

  mov			ESI, [EBP + 16]		; Address of numsArray
  mov			ECX, ARRAYSIZE
_calculateSum:
  add			EAX, [ESI]			; Accumulate sum
  add			ESI, TYPE SDWORD	; Move through array
  loop			_calculateSum
 
  mov			ESP, EBP
  pop			EBP

  RET			20
displaySum		ENDP

; ---------------------------------------------------------------------------------
; Name: displayAvg
; 
; Displays the average of numbers in an array.
;
; Preconditions: numsArray is not empty.
;
; Postconditions: average of numbers is printed.
;
; Receives: 
; 
; [EBP + 24] = buffer, reading from digit to next (convert Str to Int)
; [EBP + 20] = tabMsg, space character
; [EBP + 16] = numsArray, array that holds user numbers
; [EBP + 12] = avgNum, number to hold average
; [EBP + 8] = avgMsg, message to indicate average is printed
; 
; returns: average of numbers is displayed.
; ---------------------------------------------------------------------------------

displayAvg		PROC
  push			EBP
  mov			EBP, ESP

  mdisplayString	[EBP + 8], [EBP + 20]
  call			CrLf

  mov			ESP, EBP
  pop			EBP

  RET			4
displayAvg		ENDP

; ---------------------------------------------------------------------------------
; Name: introduction
; 
; Introduces user to the program.
;
; Preconditions: none.
;
; Postconditions: Introduction and instructions is printed to user.
;
; Receives: 
;
; [EBP + 28] = titleMsg, title of program
; [EBP + 24] = authorMsg, author of program
; [EBP + 20] = instructionMsg, instruction to user to provide 10 signed ints
; [EBP + 16] = descMsg_1, conditions of user input and what the program will do with the ints
; [EBP + 12] = descMsg_2
; [EBP + 8] = descMsg_3
; 
; returns: printed introduction to user.
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
; Displays a goodbye message to user.
;
; Preconditions: none.
;
; Postconditions: Goodbye message is printed.
;
; Receives: 
;
; [EBP + 8] = goodbyeMsg, farewell to user
; 
; returns: Farewell message to indicate program has ended.
; ---------------------------------------------------------------------------------

farewell		PROC
  push			EBP
  mov			EBP, ESP

  call			CrLf
  mov			EDX, [ESP + 8]
  call			WriteString
  call			CrLf

  mov			ESP, EBP
  pop			EBP

  RET			4
farewell		ENDP

END main
