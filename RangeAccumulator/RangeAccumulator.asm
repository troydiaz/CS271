TITLE Range Accumulator     (RangeAccumulator.asm)

; Author: Redfield
; Last Modified:
; OSU email address: ONID_ID@oregonstate.edu
; Course number/section:   CS271 Section ???
; Project Number:                 Due Date:
; Description: This program gets two integers from the user,
;	and calculates the summation of the integers from the
;	first to the second.  For example, if the user enters
;	1 and 10, the program calculates 1+2+3+4+5+6+7+8+9+10.

;	Note: This program does not perform any data validation.
;   If the user gives invalid input, the output will be
;   meaningless.

;  Implementation notes:
;	This program is implemented using procedures.
;	All variables are global ... no parameter passing

INCLUDE Irvine32.INC

.data
a        SDWORD   ?
b        SDWORD   ?
sum      SDWORD   ?
rules1   BYTE     "Enter a lower limit and an upper limit, and I'll show",13,10
         BYTE     "the summation of integers from lower to upper.",13,10,13,10,0
prompt1  BYTE     "Lower limit: ",0
prompt2  BYTE     "Upper limit: ",0
out1     BYTE     13,10,"The summation of integers from ",0
out2     BYTE     " to ",0
out3     BYTE     " is: ",0

.code
main PROC

   CALL  introduction
   CALL  getData        ; Add data validation
   CALL  calculate
   CALL  showResults

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; -- introduction --
; Procedure to introduce the program.
; preconditions: rules1 and rules2 are strings that describe the program and rules.
; postconditions: EDX changed
; receives: ???
; returns: ???
introduction PROC
  MOV    EDX, OFFSET rules1
  CALL   WriteString
  RET
introduction ENDP

; -- getData --
; Gets two values from the user (a and b). Hopefully a is less than b.
; preconditions: prompt1 and prompt2 are strings, a and b exist
; postconditions: EAX, EDX changed
; receives: none
; returns: user input values for global variables a and b
getData PROC
  MOV    EDX, OFFSET prompt1
  CALL   WriteString    ;"Lower limit: "
  CALL   ReadInt        ; Lower limit into EAX
  MOV    a, EAX         ; Lower limit into a
  
  MOV    EDX, OFFSET prompt2
  CALL   WriteString    ;"Upper limit: "
  CALL   ReadInt        ; Upper limit into EAX
  MOV    b, EAX         ; Upper limit into b

  RET
getData ENDP

; -- calculate --
; Calculate the summation of integers from a to b
; preconditions: a <= b
; postconditions: EAX, EBX changed
; receives: a and b are global variables
; returns: global variable (sum) = a + (a+1) + ... + b
calculate PROC
  ; Initialize registers
  MOV    EAX, 0
  MOV    EBX, a

_sumLoop:
    ADD   EAX, EBX    ;sum = sum + new a
    INC   EBX         ; a = a + 1
    CMP   EBX, b
  JLE   _sumLoop    ; if new value is > b, stop accumulating

  MOV   sum, EAX
  RET
calculate ENDP

; -- showResults --
; Display results of summation (a + ... + b = sum)
; preconditions: sum has been calculated
; postconditions: EAX and EDX
; receives: a and b and sum are global variables
; returns: none
showResults PROC
  ; Identify the output
  MOV    EDX, OFFSET out1
  CALL   WriteString          ;"The summation of integers from "
  MOV    EAX, a
  CALL   WriteInt             ; display a
  MOV    EDX, OFFSET out2  
  CALL   WriteString          ; " to "
  MOV    EAX, b
  CALL   WriteInt             ; display b
  MOV    EDX, OFFSET out3
  CALL   WriteString          ; " is:"
  MOV    EAX, sum
  CALL   WriteInt             ; display sum
  CALL   CrLf
  RET
showResults ENDP

END main
