TITLE Arrays, Addressing, and Stack-Passed Parameters     (Proj5_diaztr.asm)

; Author: Troy Diaz
; Last Modified: 8/11/24
; OSU email address: diaztr@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 5                Due Date: 8/11/24
; Description: MASM program that produces random numbers in an pre-defined
; sized array. Bounds of random numbers are also set. This program then sorts
; this random array, prints the median number, and the frequency of numbers. 

INCLUDE Irvine32.inc

ARRAYSIZE = 200
LO = 15
HI = 50

.data

titleMsg		BYTE "Generating, Sorting, and Counting Random integers!",0
authorCred		BYTE "Programmed By Troy Diaz",0

listrandMsg		BYTE "This program generates 200 random integers between 15 and 50, inclusive.",0
displayMsg1		BYTE "It then displays the original list, sorts the list, displays the median value of the list, ",0
displayMsg2		BYTE "displays the list sorted ascending order, and finally displays the number of instances of each ",0
displayMsg3		BYTE "generated value, starting with the number of lowest.",0

unsortedMsg		BYTE "Your unsorted random numbers: ",0
sortedMsg		BYTE "Your sorted random numbers: ",0
medianMsg		BYTE "The median value of the array: ",0
countMsg		BYTE "Your list of instances of each generated number, starting with the smallest value: ",0
tabMsg			BYTE " ",0

randArray		DWORD ARRAYSIZE DUP(?)		; Create array with size of ARRAYSIZE
freqArray		DWORD (HI-LO) DUP(?)		; Array to hold all elements visited, size of all unqiue numbers in randArray
sizeofArray		DWORD ?						; Hold size of given array
uniqueNums      DWORD ?                     ; HI - LO
lineCount		DWORD ?						; Count of numbers per line

goodbyeMsg		BYTE "Goodbye, and thanks for using my program!",0

.code
main PROC

; Initialize variables
  mov           uniqueNums, 0
  mov           lineCount, 0
  mov			sizeofArray, 0

  push			LENGTHOF randArray
  push          OFFSET randArray
  call          initArray			; Call = 4 Bytes, 4*2=8 Bytes to return

  push			LENGTHOF freqArray
  push          OFFSET freqArray
  call          initArray           ; Call = 4 Bytes, 4*2=8 Bytes to return

; Introduction
  push			OFFSET titleMsg
  push			OFFSET authorCred
  push			OFFSET listrandMsg
  push			OFFSET displayMsg1
  push			OFFSET displayMsg2
  push			OFFSET displayMsg3
  call			introduction        ; Call = 4 Bytes, 4*6 = 24 Bytes to return

; Fill array with random numbers
  call			Randomize
  push			OFFSET randArray
  call			fillArray           ; Call = 4 Bytes, 4 Bytes to return

; Display unsorted array
  push			LENGTHOF randArray
  push			OFFSET unsortedMsg
  push			OFFSET randArray
  push			OFFSET tabMsg
  call			displayList         ; Call = 4 Bytes, 4*4 = 16 Bytes to return

; Sort array
  push			OFFSET randArray
  call			sortList            ; Call = 4 Bytes, 4 Bytes to return

; Display median of sorted array
  push			OFFSET randArray
  push			OFFSET medianMsg
  call			displayMedian		; Call = 4 Bytes, 4*2 = 8 Bytes to return

; Display sorted array
  push			LENGTHOF randArray
  push			OFFSET sortedMsg
  push			OFFSET randArray
  push			OFFSET tabMsg
  call			displayList			; Call = 4 Bytes, 4*4 = 16 Bytes to return

; Fill array frequency
  push          OFFSET uniqueNums
  push			OFFSET freqArray
  push			OFFSET randArray
  call			countList			; Call = 4 Bytes, 4*3 = 12 Bytes to return

; Display array counts
  push			LENGTHOF freqArray
  push			OFFSET countMsg 
  push			OFFSET freqArray 
  push			OFFSET tabMsg
  call			displayList			; Call = 4 Bytes, 4*4 = 16 Bytes to return

; Say goodbye to user
  push			OFFSET goodbyeMsg
  call			farewell			; Call = 4 Bytes, 4 Bytes to return

	Invoke ExitProcess,0			; exit to operating system
main ENDP

; ---------------------------------------------------------------------------------
; Name: Introduction
; 
; Introduces the program's functionality to the user. This program will print out
; random numbers of an array with a predefined size. This array will then be sorted 
; in ascending values and display the median and counts of the array. 
;
; Preconditions: Needs following variables that are string bytes.
; titleMsg	- Title of program
; authorCred - Author of program
; listrandMsg - Describes how many random integers are in this array.
; displayMsg1 - Following three describe how these integers will be displayed and sorted.
; displayMsg2
; displayMsg3
;
; Postconditions: none
;
; Receives: none
; 
; returns: Displays introductory message explaining functionality of the program
; to user.
; ---------------------------------------------------------------------------------

introduction PROC
  push		 EBP
  mov		 EBP, ESP			; Preserve registers

  mov		 EDX, [EBP + 28]	; Addresses grow upward on stack, display messages by going down 4 Bytes (TYPE DWORD)
  call		 WriteString
  call		 CrLf

  mov		 EDX, [EBP + 24] 
  call		 WriteString
  call		 CrLf

  mov		 EDX, [EBP + 20] 
  call		 WriteString
  call		 CrLf

  mov		 EDX, [EBP + 16] 
  call		 WriteString
  call		 CrLf

  mov		 EDX, [EBP + 12] 
  call		 WriteString
  call		 CrLf

  mov		 EDX, [EBP + 8] 
  call		 WriteString
  call		 CrLf

  mov		 ESP, EBP			; Restore original registers
  pop		 EBP

  RET		 24					; 24 Bytes for pushing references onto stack
introduction ENDP

; ---------------------------------------------------------------------------------
; Name: initArray
; 
; Initializes a given array with zeros.
;
; Preconditions: Array needs to be defined with size ARRAYSIZE.
;
; Postconditions: Array is filled with zeros.
;
; Receives: Array of DWORDS
; 
; returns: Initialized array with zeros.
; ---------------------------------------------------------------------------------

initArray   PROC
  push		EBP
  mov		EBP, ESP			

  mov       ESI, [EBP + 8]
  mov       EAX, 0
  mov       ECX, [EBP + 12]		; Loop array size times

_initLoop:
  mov       [ESI], EAX
  loop      _initLoop
  
  mov		ESP, EBP			
  pop		EBP

  RET       8
initArray   ENDP

; ---------------------------------------------------------------------------------
; Name: fillArray
; 
; Fills array with random integers from LO to HI. Calls RandomRange to
; randomize integers.
;
; Preconditions: Given an array and ARRAYSIZE.
;
; Postconditions: Array is filled with random integers.
;
; Receives: Array of DWORDS.
; 
; returns: Array with random integers.
; ---------------------------------------------------------------------------------

fillArray	PROC
  push		EBP
  mov		EBP, ESP		

  mov       ESI, [EBP + 8]		; Address of array
  mov       ECX, ARRAYSIZE		; Size of array for loop

_fillLoop:
  mov       EAX, HI				; Set bounds of element
  inc       EAX
  sub       EAX, LO

  call      RandomRange			; Get random number
  add       EAX, LO				; Ensure number is greater than lo
  mov       [ESI], EAX			; Store element
  add       ESI, TYPE DWORD		; Move to next index
  loop      _fillLoop

  mov       ESP, EBP
  pop       EBP

  RET       4               
fillArray	ENDP

; ---------------------------------------------------------------------------------
; Name: displayList
; 
; Prints 20 integers in an array and moves to the next line after printing all
; integers in that array. 
;
; Preconditions: Given an array, space character, message to declare if it's
; a unsorted or sorted array.
;
; Postconditions: Displays an arrays contents, 20 integers per line.
;
; Receives: Array, space character, sorted/unsorted message.
; 
; returns: Displays an arrays integers.
; ---------------------------------------------------------------------------------

displayList	PROC
  push		EBP
  mov		EBP, ESP

  mov		ESI, [EBP + 12]		; Address of array
  mov		ECX, [EBP + 20]		; Loop LENGTHOF array
  
  call      CrLf
  mov       EDX, [EBP + 16]		; Declare if it's a unsorted/sorted/count array
  call      WriteString
  call      CrLf

  mov		EBX, 0				; Counter to hold how many ints are printed in a line

_displayLoop:
  mov       EAX, [ESI]			; Print current index
  call      WriteDec

  mov       EDX, [EBP + 8]		; Print space character
  call      WriteString

  inc		EBX					; Increment count of numbers in a line
  cmp		EBX, 20				; n = 20, print new line
  je		_newLine

_continueDisplay:				
  add       ESI, TYPE DWORD		; Move to next integer
  loop      _displayLoop
  jmp		_enddisplayListProc

_newLine:
  mov		EBX, 0				; Reset counter
  call		CrLf
  jmp		_continueDisplay
  
_enddisplayListProc:
  mov       ESP, EBP
  pop       EBP
  
  RET		16
displayList	ENDP

; ---------------------------------------------------------------------------------
; Name: sortList
; 
; Procedure to sort a given array in ascending order. Based on Bubble Sort.
;
; Preconditions: Array with DWORDS.
;
; Postconditions: Sorted array in ascending order, 1 < 2 < 3...
;
; Receives: Array
; 
; returns: Sorted array
; ---------------------------------------------------------------------------------

sortList	PROC
  push		EBP
  mov       EBP, ESP

_outerLoop:
  mov		ESI, [EBP + 8]			; Address of array	
  mov		ECX, ARRAYSIZE			; Loop ARRAYSIZE

  dec		ECX						; Pass through array of ARRAYSIZE - 1 times			

  mov		EDX, 0					; Flag to see if ints swapped

_innerLoop:
  mov		EAX, [ESI]				; Compare element and increment second elem
  cmp		EAX, [ESI + 4]			; If <=, don't swap since ascending order
  jle		_noSwap

  push		ESI
  call		exchangeElements		; Sub procedure to swap elems
  mov		EDX, 1					; Enable flag
_noSwap:
  add		ESI, TYPE DWORD			; Increment index
  loop		_innerLoop

  cmp		EDX, 1
  je		_outerLoop

_endsortListProc:
  
  mov		ESP, EBP
  pop		EBP

  RET		8
sortList	ENDP

; ---------------------------------------------------------------------------------
; Name: exchangeElements
; 
; Swaps two elements.
;
; Preconditions: Pushed ESI register contianing address of current element
;
; Postconditions: Two elements are swapped, ESI and ESI + 4
;
; Receives: Address of currenet element, ESI 
; 
; returns: none
; ---------------------------------------------------------------------------------

exchangeElements	PROC
  push				EBP
  mov				EBP, ESP

  pushad							; Preserve all registers

  mov				ESI, [EBP + 8]	; Restore address of current element
  mov				EBX, [ESI]		; Get address of first and second element
  mov				EAX, [ESI + 4]
  mov				[ESI + 4], EBX	; Store first into second's index
  mov				[ESI], EAX		; Store second into first's index

  popad								; Restore all registers

  pop				EBP

  RET				4
exchangeElements	ENDP

; ---------------------------------------------------------------------------------
; Name: displayMedian
; 
; Procedure to print the median of a sorted array.
;
; Preconditions: Array is sorted.
;
; Postconditions: Median value printed.
;
; Receives: Address of array and message to print.
; 
; returns: none.
; ---------------------------------------------------------------------------------

displayMedian	PROC
  push			EBP
  mov			EBP, ESP

  mov			ESI, [EBP + 12]			; Address of array
  mov			EAX, ARRAYSIZE
  mov			EBX, 2
  xor			EDX, EDX
  div			EBX						; Divide array size by 2, hold remainer in EDX

  mov			EBX, EAX				; Store size in array

  cmp			EDX, 0					; Checking if size is odd
  jne			_oddSize

  mov			EAX, [ESI + EBX * 4]	; For even sized arrays
  mov			ECX, EBX
  inc			ECX
  mov			EDX, [ESI + ECX * 4]	
  add			EAX, EDX				; Calculate average of two middle elements
  mov			EBX, 2
  xor			EDX, EDX
  div			EBX
  jmp			_printMedian

_oddSize:
  mov			EAX, [ESI + EBX * 4]	; Get middle elemnt of array
  
_printMedian:
  call			CrLf
  mov			EDX, [EBP + 8]
  call			WriteString
  call			WriteDec				; Print median value
  call			CrLf

  mov			ESP, EBP
  pop			EBP

  RET			8
displayMedian	ENDP

; ---------------------------------------------------------------------------------
; Name: countList
; 
; Procedure to print the frequency or count of each unique number in a set. LO - HI
; number of unique numbers. For example, [1,1,1,2], 1: 3, 2: 1.
;
; Preconditions: randArray is sorted and freqArray is initialized.
;
; Postconditions: freqArray contains the frequency of all unique numbers of a given array/
;
; Receives: Array that is sorted and another array that is empty.
; 
; returns: Frequency in array.
; ---------------------------------------------------------------------------------

countList	PROC
  push		EBP
  mov		EBP, ESP

  mov		EAX, HI							; Set up unique numbers, HI - LO	
  mov		[EBP + 16], EAX
  mov		EAX, LO
  sub		[EBP + 16], EAX
  xor		EAX, EAX            

  mov		ESI, [EBP + 8]					; Address of randArray
  mov		EDI, [EBP + 12]					; Address of freqArray
  xor		EBX, EBX				

  mov		ECX, [EBP + 16]					; Move unique numbers for counter
_initFreq:
  mov		DWORD PTR [EDI + EBX * 4], 0	; Set freqArray to be 0 for all indices
  inc		EBX
  loop		_initFreq

  xor		EBX, EBX						; Clear EBX counter

_countLoop:
  mov		EAX, [ESI + EBX * 4]			; Loading randArray[EBX] into EAX
  sub		EAX, LO							; Adjusting index to start 0 at LO
  mov		EDX, [EDI + EAX * 4]			; Loading freqArray[EAX] into EDX
  inc		EDX								; Increment EDX and update value thats in freqArray[EAX]
  mov		[EDI + EAX*4], EDX
  inc		EBX								; Next index at randArray
  cmp		EBX, ARRAYSIZE
  jl		_countLoop						; Loop ARRAYSIZE times

  mov		ESP, EBP
  pop		EBP
  
  RET		12                   
countList	ENDP

; ---------------------------------------------------------------------------------
; Name: farewell
; 
; Prints a goodbye message to user, indicating the program has ended.
;
; Preconditions: BYTE message 
;
; Postconditions: Goodbye message is displayed.
;
; Receives: none
; 
; returns: none
; ---------------------------------------------------------------------------------

farewell	PROC
  push		EBP
  mov		EBP, ESP

  call		CrLf
  mov		EDX, [EBP + 8]
  call		WriteString
  call		CrLf

  mov		ESP, EBP
  pop		EBP

  RET		8
farewell	ENDP

END main