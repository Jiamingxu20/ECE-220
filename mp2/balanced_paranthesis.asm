;balanced_paranthesis
;
;
.ORIG x3000
	AND R0, R0, #0			;
	AND R6, R6, #0			;
	AND R4, R4, #0			;
GET_NEXT_CHAR
	GETC				; Getting input from keyboard
	OUT					; echoing to screen
	ADD R3, R0, #0		; 2's complement of the input character stored in R3
	NOT R3, R3			;
	ADD R3, R3, #1
	LD R1, NEW_LINE			;
	ADD R5, R1, R3			;
	BRz DONE_MAIN			;if '/n' branch to done
	LD R1, CHAR_RETURN		;
	ADD R5, R1, R3			;
	BRz DONE_MAIN			;if '/r' branch to done
	LD	R1, SPACE		; if space then get next character. Nothing to be done.
	ADD R5, R1, R3			;
	BRz GET_NEXT_CHAR
	JSR IS_BALANCED			; Call to IS_BALANCED
	ADD R1, R6,#1			; if return value is -1 then halt
	Brz HALT_MAIN
	BRnzp GET_NEXT_CHAR		;

DONE_MAIN
	AND R6,R6,#0  ; clearing R6 and assuming balanced
	ADD R6,R6,#1  ; so setting R6 to 1. will verify using pop.
	JSR POP       ; checking if there is anything on stack
	ADD R5,R5,#0  ; if pop is a success then unblanced
	BRp HALT_MAIN ; else balanced. go to halt.
	AND R6, R6,#0 ; pop was a success. so unbalanced.
	ADD R6, R6,#-1 ;clear R6 and set to -1
	
HALT_MAIN
	HALT
		
SPACE	.FILL x0020
NEW_LINE	.FILL x000A
CHAR_RETURN	.FILL x000D
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;if ( push onto stack if ) pop from stack and check if popped value is (
;input - R0 holds the input
;output - R6 set to -1 if unbalanced. else not modified.
IS_BALANCED
	
	ST R2, IS_BALANCED_R2
	ST R5, IS_BALANCED_R5		;callee-saved	reg
	ST R7, IS_BALANCED_R7

	AND R6,R6,#0 ; clearing R6
	LD R2, NEG_OPEN ; storing 2's complement of open bracket
	ADD R5, R2, R0 ; checking if input value is open bracket
	BRnp IS_CLOSE ; jump to handling close bracket
	JSR PUSH ; push open bracket on to stack
	Brnzp DONE_IS_BALANCED ; exiting the subroutine
IS_CLOSE
	JSR POP ; input is close bracket. pop.
	ADD R5, R2, R6 ; check if popped char is open bracket.
	Brz DONE_IS_BALANCED ; if it is exit subroutine.
	AND R6,R6,#0 ; if popped char is not open bracket
	ADD R6,R6,#-1 ; set r6 to -1
DONE_IS_BALANCED  ; exiting subrouting. restoring registers
	LD R2,IS_BALANCED_R2
	LD R5,IS_BALANCED_R5
	LD R7,IS_BALANCED_R7
	RET

IS_BALANCED_R2 .BLKW #1
IS_BALANCED_R5 .BLKW #1
IS_BALANCED_R7 .BLKW #1
NEG_OPEN .FILL xFFD8
;IN:R0, OUT:R5 (0-success, 1-fail/overflow)
;R3: STACK_END R4: STACK_TOP
;
PUSH	
	ST R3, PUSH_SaveR3	;save R3
	ST R4, PUSH_SaveR4	;save R4
	AND R5, R5, #0		;
	LD R3, STACK_END	;
	LD R4, STACK_TOP	;
	ADD R3, R3, #-1		;
	NOT R3, R3		;
	ADD R3, R3, #1		;
	ADD R3, R3, R4		;
	BRz OVERFLOW		;stack is full
	STR R0, R4, #0		;no overflow, store value in the stack
	ADD R4, R4, #-1		;move top of the stack
	ST R4, STACK_TOP	;store top of stack pointer
	BRnzp DONE_PUSH		;
OVERFLOW
	ADD R5, R5, #1		;
DONE_PUSH
	LD R3, PUSH_SaveR3	;
	LD R4, PUSH_SaveR4	;
	RET


PUSH_SaveR3	.BLKW #1	;
PUSH_SaveR4	.BLKW #1	;


;OUT: R6, OUT R5 (0-success, 1-fail/underflow)
;R3 STACK_START R4 STACK_TOP
;
POP	
	ST R3, POP_SaveR3	;save R3
	ST R4, POP_SaveR4	;save R3
	AND R5, R5, #0		;clear R5
	LD R3, STACK_START	;
	LD R4, STACK_TOP	;
	NOT R3, R3		;
	ADD R3, R3, #1		;
	ADD R3, R3, R4		;
	BRz UNDERFLOW		;
	ADD R4, R4, #1		;
	LDR R6, R4, #0		;
	ST R4, STACK_TOP	;
	BRnzp DONE_POP		;
UNDERFLOW
	ADD R5, R5, #1		;
DONE_POP
	LD R3, POP_SaveR3	;
	LD R4, POP_SaveR4	;
	RET


POP_SaveR3	.BLKW #1	;
POP_SaveR4	.BLKW #1	;
STACK_END	.FILL x3FF0	;
STACK_START	.FILL x4000	;
STACK_TOP	.FILL x4000	;

.END


