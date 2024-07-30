TITLE Arrays, Addressing, and Stack-Passed Parameters     (Proj5_diaztr.asm)

; Author: Troy Diaz
; Last Modified: 8/11/24
; OSU email address: diaztr@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 5                Due Date: 8/11/24
; Description: This file is provided as a template from which you may work
;              when developing assembly projects in CS271.

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
displayMsg3		BYTE "gnerated value, starting with the number of lowest.",0

unsortedMsg		BYTE "Your unsorted random numbers: ",0
sortedMsg		BYTE "Your sorted random numbers: ",0
medianMsg		BYTE "The median value of the array: ",0
listofMsg		BYTE "Your list of instances of each generated number, starting with the smallest value: ",0

goodbyeMsg		BYTE "Goodbye, and thanks for using my program!",0

.code
main PROC

  call		introduction
  call		farewell

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; ---------------------------------------------------------------------------------
; Name: 
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

  mov			EDX, OFFSET titleMsg
  call			WriteString
  call			CrLf

  mov			EDX, OFFSET authorCred
  call			WriteString
  call			CrLf
  call			CrLf

  mov			EDX, OFFSET listrandMsg
  call			WriteString
  call			CrLf

  mov			EDX, OFFSET displayMsg1
  call			WriteString
  mov			EDX, OFFSET displayMsg2
  call			WriteString
  mov			EDX, OFFSET displayMsg3
  call			WriteString
  call			CrLf

  RET
introduction	ENDP

; ---------------------------------------------------------------------------------
; Name: 
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

fillArray	PROC
  RET
fillArray	ENDP

; ---------------------------------------------------------------------------------
; Name: 
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

sortList	PROC
  RET
sortList	ENDP

; ---------------------------------------------------------------------------------
; Name: 
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

exchangeElements	PROC
  RET
exchangeElements	ENDP

; ---------------------------------------------------------------------------------
; Name: 
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

displayMedian	PROC

  mov			EDX, OFFSET medianMsg
  call			WriteString
  call			CrLf

  RET
displayMedian	ENDP

; ---------------------------------------------------------------------------------
; Name: 
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

countList	PROC
  RET
countList	ENDP

; ---------------------------------------------------------------------------------
; Name: 
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

farewell	PROC

  call			CrLf
  mov			EDX, OFFSET goodbyeMsg
  call			WriteString
  call			CrLf

  RET
farewell	ENDP

END main
