;	Main program to test the subroutine GETS
;	This program simply prompts for two strings and
;	displays them back using PUTS
; -------------------------------------------------------------------------

	.ORIG	x3000

;	Set up the user stack:
	LD	R6, STKBASE
	
;	Prompt for the first string:
	LEA	R0, PRMPT1
	PUTS

;	Call GETS to get first string:
	LD	R0, STRING1STORAGE; LOADS x3100 INTO R0
	ADD	R6, R6, #-1	; Push the address to store the string at
	STR	R0, R6, #0
	JSR	GETS		; Call GETS
	ADD	R6, R6, #2	; Clean up (pop parameter & return value)

;	Prompt for second string:
	LEA	R0, PRMPT2
	PUTS

;	Call GETS to get second string:
	LEA	R0, STRNG2
	ADD	R6, R6, #-1	; Push the second address
	STR	R0, R6, #0
	JSR	GETS		; Call GETS
	ADD	R6, R6, #2	; Clean up

;	Output both strings:
	LEA	R0, OUT1	; First string...
	PUTS
	LD	R0, STRING1STORAGE
	PUTS
	LD	R0, LF		; Print a linefeed
	OUT
	LEA	R0, OUT2	; Second string.
	PUTS
	LEA	R0, STRNG2
	PUTS

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
STRNG1	.BLKW		#80		; Room for 79 characters (unpacked) + NULL
STRNG2	.BLKW		#80		; Room for 79 characters (unpacked) + NULL (STARTS AT x30DF)

;=====================================================================================
; Place your GETS subroutine here:
;=====================================================================================
; Subroutine GETS
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

GETS ADD R6, R6, #-1 ;(xFDFD)
ADD R6, R6, #-1;(xFDFC) 	
STR R7, R6, #0;(xFDFC = x3007) HOLDS RETURN ADDRESS
ADD R6, R6, #-1;(xFDFB) PUSHES FRAME POINTER ON ADDRESS	
STR R5, R6, #0;(STORES FRAME POINTER)
ADD R5, R6, #-1; (R5 = xFDFA)
STR R6, R5, #0; 
ADD R6, R6, #-3; (R6 = xFDF8)
; STORES REGISTERS INTO STACK
STR R0, R5, #0; (R5 @ xFDFA)
STR R1, R5, #-1; (R5 @ xFDF9)
STR R2, R5, #-2; (R5 @ xFDF8)
LDR R2, R5, #4; (R5 @ xFDFE); LOADS THE ADDRESS WHERE THE STRING IS STORED INTO R2

LOOP GETC
OUT
AND R1, R1, #0
ADD R1, R1, #-10
ADD R1, R1, R0; CHECKS IF R0 IS = TO ASCII CHARACTER ENTER, IF SO ENDS LOOP AND BRANCHES TO DONE
BRz DONE
STR R0, R2, #0; STORES CHARACTER AT ADDRESS IN R2
ADD R2, R2, #1; INCREASES ADDRESS BY 1
BRnzp LOOP

DONE AND R1, R1, #0
STR R1, R2, #0
;LOADS REGISTERS BACK
LDR R0, R5, #0; (R5 @ XFDFA)
LDR R1, R5, #-1; (R5 @ xFDF9)
LDR R2, R5, #-2; (R5 @ xFDF8)
ADD R6, R5, #1; (R6 = xFDFB)
ADD R5, R6, #0; (R5 = xFDFB)
ADD R6, R6, #1; (R6 = xFDFC)
LDR R7, R6, #0; (LOADS RETURN VALUE INTO R7)
ADD R6, R6, #1; (R6 = XFDFD)
RET

.END
