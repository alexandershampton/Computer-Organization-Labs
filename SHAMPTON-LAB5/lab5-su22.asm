.ORIG x3000
;	Your main() function starts here
LD R6, STACK_PTR			;	LOAD the pointer to the bottom of the stack in R6	(R6 = x5013)
ADD R6, R6, #-1				;	Allocate room for your return value 				(R6 = x5012)
ADD R5, R6, #0				;	MAKE your frame pointer R5 point to local variables	(R5 = x5012)
LEA R4, GLOBAL_VARS			;	MAKE your global var pointer R4 point to globals	(R4 = ADDRESS(GLOBAL_VARS))

LEA R0, ARRAY_POINTER		;	LOAD the address of your array pointer
STR R0, R5, #0				;	STORE pointer to array in stack						(R5 = x5012)
ADD R6, R6, #-2				;	MAKE stack pointer go back two addresses			(R6 = x5010)

STR R0, R6, #0				;	STORE pointer to array (input to sumOfSquares)		(R6 = x5010)
ADD R6, R6, #-1				;	MAKE stack pointer go back one address				(R6 = x500F)

LDR R0, R4, #0				;	LOAD MAX_ARRAY_SIZE value into R0
STR R0, R6, #0				;	STORE MAX_ARRAY_SIZE value into stack				(R6 = x500F)

ADD R6, R6, #-1				;	MAKE stack pointer go back one address				(R6 = x500E)
JSR sumOfSquares			;	CALL sumOfSquares() function
LDR R0, R5, #-4				;	LOAD return value of sumOfSquares() into R0			(R5 = x5012)

ADD R6, R6, #1				;	POP input to sumOfSquares off the stack				(R6 = x5010)

STR R0, R5, #-1				;	STORE int total into stack							(R5 = x5012)
STR R0, R5, #1				;	STORE main() return value into stack				(R5 = x5012)

ADD R6, R6, #4				;	POP stack											(R6 = x5014)
HALT

GLOBAL_VARS					;	Your global variables start here
MAX_ARRAY_SIZE	.FILL x0005	;	MAX_ARRAY_SIZE is a global variable and predefined
ARRAY_POINTER	.FILL x0002	;	ARRAY_POINTER points to the top of your array (5 elements)
				.FILL x0003
				.FILL x0005
				.FILL x0000
				.FILL x0001
STACK_PTR		.FILL x5013	;	STACK_PTR is a pointer to the bottom of the stack	(x5013)

sumOfSquares
;	Your sumOfSquares() function starts here
ADD R6, R6, #-1; (R6 = X500D) MAKES ROOM FOR RETURN VALUE
STR R7, R6, #0; STORES RETURN ADDRESS TO MAIN
ADD R6, R6, #-1; (R6 = X500C)
STR R5, R6, #0; STORES FRAME POINTER IN STACK
ADD R6, R6, #-1; (R6 = X500B)
STR R3, R6, #0; STORES R3 ON STACK
ADD R6, R6, #-1; (R6 = X500A)
STR R2, R6, #0; STORES R2 ON STACK
ADD R6, R6, #-1; (R6 = X5009)
STR R1, R6, #0; STORES R1 ON STACK
ADD R6, R6, #-1; (R6 = X5008)
STR R0, R6, #0; STORES R0 ON STACK
ADD R6, R6, #-1; (R6 = X5007)
ADD R5, R6, #0; (R5 = X5007)
ADD R6, R6, #-2; (R6 = X5005)

LDR R2, R5, #8; (R5 @ X500F) LOADS MAXARRAYSIZE INTO R2
AND R3, R3, #0; COUNTER
STR R3, R5, #0; STORES THE COUNTER R3
STR R3, R5, #-1; STORES THE SUM AS 0
NOT R2, R2
ADD R2, R2, #1

WHILE_LOOP
ADD R0, R2, R3
BRz DONE
LDR R0, R5, #9; (R5 @ X5010) LOADS ARRAY INTO R0
ADD R0, R3, R0; 
LDR R0, R0, #0; LOADS VALUE OF ARRAY INTO R0
STR R0, R5, #-2; (R5 @ X5005)
ADD R6, R6, #-1; (R6 = X5004)
JSR square
LDR R0, R5, #-3; (R5 @ X5004) LOADS RETURN VALUE OF SQUARE
LDR R1, R5, #-1; (R5 @ X5006) LOADS THE SUM INTO R1
ADD R1, R0, R1
STR R1, R5, #-1; (R5 @ X5006) STORES THE CURRENT SUM INTO STACK
ADD R3, R3, #1
STR R3, R5, #0; STORES THE COUNTER INTO STACK
ADD R0, R2, R3
BRnzp WHILE_LOOP

DONE 
LDR R0, R5, #-1; LOADS SUM INTO R0
STR R0, R5, #7; STORES THE SUM INTO SUMOFSQUARES RETURN VALUE
ADD R6, R6, #2; (R6 = X5007)
ADD R6, R6, #1; (R6 = X5008)
LDR R0, R6, #0; (R6 @ X5008)
ADD R6, R6, #1; (R6 = X5009)
LDR R1, R6, #0; (R6 @ X5009)
ADD R6, R6, #1; (R6 = X500A)
LDR R2, R6, #0; (R6 @ X500A)
ADD R6, R6, #1; (R6 = X500B)
LDR R3, R6, #0; (R6 @ X500B)
ADD R6, R6, #1; (R6 = X500C)
LDR R5, R6, #0; (R6 @ X500C)
ADD R6, R6, #1; (R6 = X500D)
LDR R7, R6, #0; (R6 @ X500D)
ADD R6, R6, #2; (R6 = X500F)
RET

square
;	Your square() function starts here
ADD R6, R6, #-1; (R6 = X5003)
STR R7, R6, #0; (R6 @ X5003)
ADD R6, R6, #-1; (R6 = X5002)
STR R5, R6, #0; (R6 @ X5002)
ADD R6, R6, #-1; (R6 = X5001)
STR R3, R6, #0; (R6 @ X5001)
ADD R6, R6, #-1; (R6 = X5000)
STR R2, R6, #0; (R6 @ X5000)
ADD R6, R6, #-1; (R6 = X4FFF)
STR R1, R6, #0; (R6 @ X4FFF)
ADD R6, R6, #-1; (R6 = X4FFE)
STR R0, R6, #0; (R6 @ X4FFE)
ADD R6, R6, #-1; (R6 = X4FFD)
ADD R5, R5, #-10; (R5 = X4FFD)

AND R0, R0, #0; CLEAR FOR PRODUCT
STR R0, R5, #0; STORES PRODUCT (R5 @ X4FFD)
LDR R1, R5, #8; LOADS X INTO R1 (R5 @ X5005)
ADD R2, R1, #0; COPIES X INTO R2

MULTIPLY_LOOP
ADD R0, R1, R0
ADD R2, R2, #-1
BRp MULTIPLY_LOOP

STR R0, R5, #0; STORES THE PRODUCT IN STACK (R5 @ X4FFD)
STR R0, R5, #7; STORES THE PRODUCT IN SQUARE RETURN VALUE (R5 @ X4FFD)

; CLEAN UP
ADD R6, R6, #1; (R6 = X4FFE)
LDR R0, R6, #0; (R6 @ X4FFE)
ADD R6, R6, #1; (R6 = X4FFF)
LDR R1, R6, #0; (R6 @ X4FFF)
ADD R6, R6, #1; (R6 = X5000)
LDR R2, R6, #0; (R6 @ X5000)
ADD R6, R6, #1; (R6 = X5001)
LDR R3, R6, #0; (R6 @ X5001)
ADD R6, R6, #1; (R6 = X5002)
LDR R5, R6, #0; (R6 @ X5002)
ADD R6, R6, #1; (R6 = X5003)
LDR R7, R6, #0; (R6 @ X5003)
ADD R6, R6, #2; (R6 @ X5005)
RET

.END