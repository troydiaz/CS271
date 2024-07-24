 TITLE Simple Comparator     (Comparator.asm)

; Author: Troy Diaz
; Last Modified: 7/15/2024
; OSU email address: diaztr@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: none                 Due Date: none
; Description: This program gets two unsigned values from the user,
;	and determines which is greater (or if they are equal), then
;	notifies the user of the conclusion.

;	This program will also verify if the integers are nonzero and positive.

;	Note:
;	ReadDec
;	receives: None
;	returns; EAX - unsigned integer
;	CF = 1 if value is zero or invalid, else 0
;	This is data breaking

INCLUDE Irvine32.inc

.data
a           SDWORD   ?
b           SDWORD   ?
rules1      BYTE     "Enter two unsigned values, a and b. I will tell you which is greater.",13,10,0
prompt1     BYTE     "Enter value for a: ",0
prompt2     BYTE     "Enter value for b: ",0
error		BYTE	 "Please enter an unsigned value! ",0
isGreater   BYTE     " is greater than ",0
isEqual     BYTE     "The two values you entered are equal",0
seeya       BYTE     ". Thanks for playing!",13,10,0

.code
main PROC

  mov    EDX, OFFSET rules1
  call   WriteString

  ; Get value a
_getA:
  mov    EDX, OFFSET prompt1
  call   WriteString
  call   ReadInt
  cmp	 EAX, 0
  jl	 _errorA

  mov    a, EAX		; Value is acceptable
  jmp	 _getB

_errorA:
  mov	EDX, OFFSET error
  call  WriteString
  jmp   _getA
  
_getB:
  ; Get value b
  mov    EDX, OFFSET prompt2
  call   WriteString
  call   ReadInt
  cmp	 EAX, 0
  jl	 _errorB

  mov    b, EAX		; Value is acceptable
  jmp	 _bothDataValidated

_errorB:
  mov	EDX, OFFSET error
  call  WriteString
  jmp   _getA

_bothDataValidated:
  ; Print which is greater
  mov    EAX, a
  cmp    EAX, b
  ja     _aGreater
  jb     _bGreater
  mov    EDX, OFFSET isEqual  ; They are equal
  call   WriteString
  jmp    _goodbye

_aGreater:     ; a is greater than b
  mov    EAX, a
  call   WriteDec
  mov    EDX, OFFSET isGreater
  call   WriteString
  mov    EAX, b
  call   WriteDec
  jmp    _goodbye

_bGreater:     ; b is greater than a
  mov    EAX, b
  call   WriteDec
  mov    EDX, OFFSET isGreater
  call   WriteString
  mov    EAX, a
  call   WriteDec

_goodbye:
  mov    EDX, OFFSET seeya
  call   WriteString

  Invoke ExitProcess,0	; exit to operating system
main ENDP


END main
