.ORIG x5000
MEMDUMP
STI R6, OUT_STACK_R6
LD R6, OUT_STACK_BASE; (R6 = X5FFF)
; STORES REGISTERS ON STACK
STR R0, R6, #0; (R6 @ X5FFF)
STR R1, R6, #-1; (R6 @ X5FFE)
STR R2, R6, #-2; (R6 @ X5FFD)
STR R3, R6, #-3; (R6 @ X5FFC)
STR R4, R6, #-4; (R6 @ X5FFB)
STR R5, R6, #-5; (R6 @ X5FFA)
STR R7, R6, #-7; (R6 @ X5FF8)
ADD R6, R6, #-8
;
; COPIES R0 AND R1 INTO R4 AND R5
ADD R4, R0, #0
ADD R5, R1, #0
;
LEA R0, MEMCONBEGIN
PUTS
;
ADD R0, R4, #0
JSR WORD_OUT
;
LEA R0, MEMCONMIDDLE
PUTS
;
ADD R0, R5, #0
JSR WORD_OUT
;
LEA R0, MEMCONEND
PUTS
;
LD R0, CHAR_LB
OUT
;
; PRINTS OUT EACH ADDRESS AND VALUE IN ADDRESS
MDLOOP
ADD R3, R4, #0
NOT R3, R3
ADD R3, R3, #1
ADD R3, R5, R3
BRn MDMP_EXIT
;
ADD R0, R4, #0
JSR WORD_OUT
;
LD R0, CHAR_SPACE
OUT
OUT
OUT
;
LDR R0, R4, #0
JSR WORD_OUT
;
LD R0, CHAR_LB
OUT
;
ADD R4, R4, #1
BRnzp MDLOOP
;
; LOADS REGISTERS BACK IN HOW IT WAS BEFORE TRAP WAS CALLED
MDMP_EXIT
ADD R6, R6, #8
LDR R0, R6, #0
LDR R1, R6, #-1
LDR R2, R6, #-2
LDR R3, R6, #-3
LDR R4, R6, #-4
LDR R5, R6, #-5
LDR R7, R6, #-7
LDR R6, R6, #-6
RET
;
; PRINTS OUT WORD AS ASCII CHARACTERS
WORD_OUT
STR R0, R6, #0; (R6 @ X5FF7)
STR R1, R6, #-1; (R6 @ X5FF6)
STR R2, R6, #-2; (R6 @ X5FF5)
STR R3, R6, #-3; (R6 @ X5FF4)
STR R4, R6, #-4; (R6 @ X5FF3)
STR R5, R6, #-5; (R6 @ X5FF2)
STR R6, R6, #-6; (R6 @ X5FF1)
STR R7, R6, #-7; (R6 @ X5FF0)
ADD R6, R6, #-8; (R6 @ x5FEF)
;
LD R0, CHAR_X
OUT
;
LEA R5, NIBBLE_1_SHIFT
;
; GOES THROUGH EACH LABEL MOST SIGNIFICANT TO LEAST
WO_NIBBLE_LOOP
LD R1, MSB_MASK
LDR R0, R6, #8
LDR R3, R5, #0
BRz WO_NIB_SHIFT_DONE
;
; SETS UP CIRCULAR LEFT SHIFT
WO_CLS_LOOP
AND R2, R0, R1
BRz WO_CLS
AND R2, R2, #0
ADD R2, R2, #1
;
; CIRCULAR LEFT CHIFT
WO_CLS
ADD R0, R0, R0
ADD R0, R0, R2
ADD R3, R3, #-1
BRp WO_CLS_LOOP
;
; DETERMINES IF CHARACTER IS NUMERIC OR ALPHABETIC
WO_NIB_SHIFT_DONE
LD R1, NUM_MASK
AND R0, R0, R1
LD R1, CHAR_NL
NOT R1, R1
ADD R1, R1, #1
ADD R1, R0, R1
BRn WO_CHAR_NUM
;
ADD R0, R1, #0
LD R1, ALPHA_BASE
ADD R0, R0, R1
BRnzp WO_CHAR_PRINT
;
; MAKES NUMER ASCII
WO_CHAR_NUM
LD R1, DIGIT_BASE
ADD R0, R0, R1
;
; PRINTS OUT CHARACTER
WO_CHAR_PRINT
OUT
LDR R3, R5, #0
BRz WO_EXIT
ADD R5, R5, #1
BRnzp WO_NIBBLE_LOOP
;
; RESTORES STACK TO ORIGINAL STATE
WO_EXIT
ADD R6, R6, #8; (R6 = X5FF7)
LDR R0, R6, #0; (R6 @ X5FF7)
LDR R1, R6, #-1; (R6 @ X5FF6)
LDR R2, R6, #-2; (R6 @ X5FF5)
LDR R3, R6, #-3; (R6 @ X5FF4)
LDR R4, R6, #-4; (R6 @ X5FF3)
LDR R5, R6, #-5; (R6 @ X5FF2)
LDR R6, R6, #-6; (R6 @ X5FF1)
LDR R7, R6, #-7; (R6 @ X5FF0)
RET

; --------------------------------------
; GLOBAL VARIABLES
 
MEMCONBEGIN     .STRINGZ "Memory Contents " ; First bit of header line
MEMCONMIDDLE     .STRINGZ " to " ; Middle bit of header line
MEMCONEND       .STRINGZ ":" ; Ending bit of header line
CHAR_X          .FILL x0078 ; The value for lowercase 'x' in ASCII
CHAR_NL         .FILL x000A ; Newline character (Windows)
CHAR_LB         .FILL x000D ; Newline/line break character (Mac/Linux/Chrome OS)
CHAR_SPACE      .FILL x0020 ; The value for the space character in ASCII
 
OUT_STACK_BASE  .FILL x5FFF ; The base address of the stack
OUT_STACK_R6    .FILL x5FF9 ; The address in memory that the contents of R6 will go to
 
; Amounts to shift each nibble left circularly by (with x0000 as a sentinel to tell us to not shift and continue). Normally we'd need to right shift, but LC-3 makes this very difficult. So instead we shift left circularly. 
NIBBLE_1_SHIFT  .FILL #4
                .FILL #8
                .FILL #12
                .FILL x0000
 
MSB_MASK        .FILL x8000 ; A mask that looks for the most significant bit in the word being set. In other words, it is 1000 0000 0000 0000 in binary. 
 
NUM_MASK        .FILL x000F ; A mask that looks for the lowest nibble of the word being set. In other words, it is 0000 0000 0000 1111 in binary. 
 
ALPHA_BASE      .FILL x0041 ; The beginning of the uppercase ASCII letters
DIGIT_BASE      .FILL x0030 ; The beginning of the digits in ASCII
.END