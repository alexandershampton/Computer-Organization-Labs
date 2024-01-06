;	Main program to test the subroutine GETSP
;	This program simply prompts for two strings and
;	displays them back using PUTSP
; -------------------------------------------------------------------------

	.ORIG	x3000

;	Set up the user stack:
	LD	R6, STKBASE
	
;	Prompt for the first string:
	LEA	R0, PRMPT1
	PUTS

;	Call GETS to get first string:
      LD R0, STRING1STORAGE; LOADS x3100 into R0
	ADD	R6, R6, #-1	; Push the address to store the string at
	STR	R0, R6, #0
	JSR	GETSP		; Call GETSP
	ADD	R6, R6, #2	; Clean up (pop parameter & return value)

;	Prompt for second string:
	LEA	R0, PRMPT2
	PUTS

;	Call GETS to get second string:
	LEA R0, STRNG2
	ADD	R6, R6, #-1	; Push the second address
	STR	R0, R6, #0
	JSR	GETSP		; Call GETSP
	ADD	R6, R6, #2	; Clean up

;	Output both strings:
	LEA	R0, OUT1	; First string...
	PUTS
	LD R0, STRING1STORAGE
	PUTSP
	LD	R0, LF		; Print a linefeed
	OUT
	LEA	R0, OUT2	; Second string.
	PUTS
	LEA R0, STRNG2
	PUTSP

	HALT

;	GLOBAL VARIABLES
;	----------------
STRING1STORAGE .FILL x3100; HOLDS ADDRESS WHERE THE 1st STRING STARTS AT (x3100) (ACOORDING TO RUBRIC)
STKBASE	.FILL		xFDFF		; The bottom of the stack will be xFDFF
LF	.FILL		x0A		; A linefeed character. 
PRMPT1	.STRINGZ	"Please enter the first string: "
PRMPT2	.STRINGZ	"Please enter the second string: "
OUT1	.STRINGZ	"The first string was: "
OUT2	.STRINGZ	"The second string was: "
CLU     .FILL x00FF			; Clear upper byte of a value in a register
CLL     .FILL xFF00			; Clear lower byte of a value in a register
STRNG1	.BLKW		#80		; Room for 79 characters (unpacked) + NULL
STRNG2	.BLKW		#80		; Room for 79 characters (unpacked) + NULL (STARTS AT x30DF)
;=====================================================================================
; Place your GETSP subroutine here:
;=====================================================================================
; Subroutine GETSP
;  Paramters:  Address - the address to store the string at
;
;  Returns:    Nothing
;
;  Local variables
;   Offset	Description
;	 0	Callee-saved register R0
;	-1	Callee-saved register R1
;       etc...
;-------------------------------------------------------------------------------------

GETSP ADD R6, R6, #-1 ;(xFDFD)
ADD R6, R6, #-1;(xFDFC) 	
STR R7, R6, #0;(xFDFC = x3007) HOLDS RETURN ADDRESS
ADD R6, R6, #-1;(xFDFB) PUSHES FRAME POINTER ON ADDRESS	
STR R5, R6, #0;(xFDFB = FRAME POINTER)
ADD R5, R6, #-1; (R5 = xFDFA)
STR R6, R5, #0; (R5 = xFDFA)
ADD R6, R6, #-5; (R6 = xFDF8)
;STORES REGISTERS ON STACK
STR R0, R5, #0; (R0 @ xFDFA)
STR R1, R5, #-1; (R1 @ xFDF9)
STR R2, R5, #-2; (R2 @ xFDF8)
STR R3, R5, #-3; (R3 @ xFDF7)
STR R4, R5, #-4; (R4 @ xFDF6)
LDR R2, R5, #4; (R2 @ xFDFE) R2 will now have the address where the string is stored at

LOOP GETC
OUT
AND R1, R1, #0
ADD R1, R1, #-10; SETS R1 = TO THE ENTER CHARACTER
ADD R1, R1, R0; CHECKS IF R0 IS = TO ASCII CHARACTER ENTER, IF SO ENDS LOOP AND BRANCHES TO DONE
BRnp L2C
STR R1, R2, #0; STORES THE CHARACTER ONTO THE ADDRESS AT R2
ADD R2, R2, #1; INCREASES THE ADDRESS BY 1
BRnzp DONE

L2C ADD R4, R0, #0; SETS R4 = THE CHARACTER IN R0
LD R1, CLU; SETS R1 = x00FF
AND R4, R1, R4; LOWER BYTE IS PRESERVED OF R4
GETC; GETS NEW CHARACTER FROM INPUT
OUT; OUTPUTS CHARACTER
AND R1, R1, #0
ADD R1, R1, #-10; SETS R1 = ASCII ENTER CHARACTER
ADD R1, R1, R0; CHECKS IF THE CHARACTER ENTERED IS ENTER, IF NOT BRANCHES TO LPC
BRnp LPC
STR R4, R2, #0; STORES THE CHARACTER AT R2 ADDRESS
BRnzp DONE

LPC ADD R3, R0, #0
LD R1, CLU; LOADS x00FF
AND R3, R1, R3; LOWER BYTE IS PRESERVED
AND R0, R0, #0
ADD R0, R0, #8; SETS R0 AS LOOP COUNTER
ADD R1, R3, #0; SETS R1 TO CHARACTER

LS ADD R1, R1, R1; ADDS R1 UNTIL ITS ON UPPER BYTE
ADD R0, R0, #-1; LOOP COUNTER
BRp LS
ADD R3, R1, #0; SETS R3 TO THE UPDATED CHARACTER IN UPPER BYTE
LD R1, CLL
AND R3, R1, R3; UPPER BYTE IS PRESERVED
ADD R4, R3, R4; ADDS TWO CHARACTERS TOGETHER IN ONE BYTE
STR R4, R2, #0; STORES THE CHARACTERS AT THE R2 ADDRESS
ADD R2, R2, #1; ADDS 1 TO THE ADDRESSS
BRnzp LOOP

DONE LDR R0, R5, #0; (R5 = XFDFA)
;LOADS THE REGISTERS BACK IN
LDR R1, R5, #-1; (R5 = xFDF9)
LDR R2, R5, #-2; (R5 = xFDF8)
LDR R3, R5, #-3; (R5 = xFDF7)
LDR R4, R5, #-4; (R5 = xFDF6)
ADD R6, R5, #1; SETS R6 = xFDFB
ADD R5, R6, #0; (R5 = xFDFB)
ADD R6, R6, #1; (R6 = xFDFC)
LDR R7, R6, #0; (LOADS RETURN VALUE INTO R7)
ADD R6, R6, #1; (R6 = XFDFD)
RET

.END