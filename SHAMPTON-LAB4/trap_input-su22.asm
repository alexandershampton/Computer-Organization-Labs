.ORIG x4000
STI R6, STACK_R6;
LD R6, STACK; (R6 = x4700)
;STORES REGISTERS ON STACK
STR R0, R6, #0; (R6 @ x4700)
STR R1, R6, #-1; (R6 @ x46FF)
STR R2, R6, #-2; (R6 @ x46FE)
STR R3, R6, #-3; (R6 @ x46FD)
STR R4, R6, #-4; (R6 @ x46FC)
STR R5, R6, #-5; (R6 @ x46FB)
STR R7, R6, #-7; (R6 @ x46F9)
;
; LOADS AND PRINTS PROMPT
LEA R0, PROMPT
PUTS
;
LD R1, CHARACTER_COUNT
;
CHAR_GET
GETC
OUT
;
LD R2, X_VAL
NOT R2, R2
ADD R2, R2, #1
ADD R2, R0, R2
BRz X_DETECTED
;
LD R2, ALPHA_VAL
NOT R2, R2
ADD R2, R2, #1
ADD R2, R0, R2
BRzp ALPHA_DETECTED
;
LD R2, NUMERIC_VAL
NOT R2, R2
ADD R2, R2, #1
ADD R2, R0, R2
BRzp NUMERIC_DETECTED
BRnzp CHAR_FINISHED
;
;IF CHARACTER IS ALPAHBETICAL CONVERTS TO HEX
ALPHA_DETECTED
ADD R2, R2, x000A
ADD R3, R1, #-1
BRz CHAR_FINISHED
ADD R3, R3, #-1
BRnzp BITSHIFT
;
;IF CHARACTER IS NUMERIC COVERTS TO HEX
NUMERIC_DETECTED
ADD R3, R1, #-1
BRz CHAR_FINISHED
ADD R3, R3, #-1
;
BITSHIFT
ADD R2, R2, R2
ADD R2, R2, R2
ADD R2, R2, R2
ADD R2, R2, R2
ADD R3, R3, #-1
BRzp BITSHIFT
BRnzp CHAR_FINISHED
;
X_DETECTED
CHAR_FINISHED
ADD R4, R2, R4
ADD R1, R1, #-1
BRp CHAR_GET
;
LD R0, NEWLINE_VAL
OUT
AND R0, R0, #0
ADD R0, R0, R4
;
; LOADS REGISTERS
LDR R1, R6, #-1
LDR R2, R6, #-2
LDR R3, R6, #-3
LDR R4, R6, #-4
LDR R5, R6, #-5
LDR R7, R6, #-7
LDR R6, R6, #-6
RET
;
; GLOBAL VARIABLES
STACK                   .FILL x4700	        ; DEFINES the starting address of the stack
STACK_R6                .FILL x46FA         ; DEFINES where R6 will be stored in the stack before running
 
CHARACTER_COUNT         .FILL #5	        ; DEFINES how many characters are expected to be inputted
PROMPT .STRINGZ	"Enter your address: \n"	; DEFINES the string prompt
 
X_VAL                    .FILL x0078 		; HEX value of "x" in ASCII
ALPHA_VAL                .FILL x0041    	; HEX value of the start of UPPERCASE alphabetical HEX digits (A - F)
NUMERIC_VAL              .FILL x0030	    ; HEX value of the start of numeric HEX digits (0 - 9)
; Use ONLY the following value if on Windows/web sim and keep the second commented out
NEWLINE_VAL              .FILL x000A	    ; HEX value of a new line character
; Uncomment the below line if you are on the UNIX desktop sim and comment out the line above
; NEWLINE_VAL               .FILL x000D       ; HEX value of a new line character 
 
; --------------------------------------
.END