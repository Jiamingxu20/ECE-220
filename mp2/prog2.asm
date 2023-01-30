; Jiaming Xu, jx30
;Description: this program will implement postfix calculation 
;by using stack and subroutine.  The main component of this program 
;is the subroutine 'EVALUATE', which will call other operator subroutines 
;and print subroutines. 
;R0 is for printing
;R1,R2,R5,R6 are temperatury registers 
;R3,R4 are input registers



.ORIG x3000

	BRnzp EVALUATE		; go to evaluate 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;R3- value to print in hexadecimal
PRINT_HEX

	ST R0,PRINT_R0		; save registers
	ST R1,PRINT_R1		
	ST R2,PRINT_R2
	ST R3,PRINT_R3
	ST R4,PRINT_R4
	ST R5,PRINT_R5
	ST R6,PRINT_R6

	ADD R3,R5,#0		; R3 <-R5

LOOP1
	ADD R6,R1,#-4		; R6 <- R1 - 4
	BRzp PRINT_END		; program ends if got 4 sections as well as 16 bits
	AND R2,R2,#0		; set R2 to 0
	AND R4,R4,#0		; set R4 to 0

LOOP2
	ADD R6,R2,#-4		; determine if got 4 bits from R3
	BRzp SUBLOOP1		; go to SUBLOOP1 if have got 4 bits from R3
	ADD R4,R4,R4		; shift digit left 
	ADD R3,R3,#0		; R3 <- R3 + 0
	BRn ADD1			; go to ADD1 if if the most significant bit of R3 is 1
	ADD R4,R4,#0		; add 0 to digit if the most significant bit of R3 is 0
	BRnzp SHIFT 		; go to shift after adding

ADD1
	ADD R4,R4,#1		; add 0 to digit if the most significant bit of R3 is 1

SHIFT 
	ADD R3,R3,R3		; shift R3 left
	ADD R2,R2,#1		; increment bit counter R2
	BRnzp LOOP2			; go to LOOP2

SUBLOOP1 
	AND R6,R6,#0		; set R6 to 0
	ADD R6,R4,#-9		; R6 <- R4 - 9
	BRnz ADD0			; go to ADD0 if less than zero or negative
	ADD R0,R4,#8		; R0 <- R4 + 8 
	ADD R0,R0,#8		; R0 <- R0 + 8 
	ADD R0,R0,#8		; R0 <- R0 + 8 
	ADD R0,R0,#8		; R0 <- R0 + 8 	
	ADD R0,R0,#8		; R0 <- R0 + 8 
	ADD R0,R0,#8		; R0 <- R0 + 8 
	ADD R0,R0,#7		; R0 <- R0 + 7 
	BRnzp OUTPRINT 		; go to print section

ADD0
	ADD R0,R4,#8		; R0 <- R4 + 8 
	ADD R0,R0,#8		; R0 <- R0 + 8 
	ADD R0,R0,#8		; R0 <- R0 + 8 
	ADD R0,R0,#8		; R0 <- R0 + 8 	
	ADD R0,R0,#8		; R0 <- R0 + 8 
	ADD R0,R0,#8		; R0 <- R0 + 8 

OUTPRINT 
	OUT					; print
	ADD R1,R1,#1		; increment digit counter R1
	BRnzp LOOP1			; go back to LOOP1


PRINT_END
	LD R0,PRINT_R0		; restore registers 
	LD R1,PRINT_R1
	LD R2,PRINT_R2
	LD R3,PRINT_R3
	LD R4,PRINT_R4
	LD R5,PRINT_R5
	LD R6,PRINT_R6
	HALT 

PRINT_R0   .BLKW #1		; store registers 
PRINT_R1   .BLKW #1
PRINT_R2   .BLKW #1
PRINT_R3   .BLKW #1
PRINT_R4   .BLKW #1
PRINT_R5   .BLKW #1
PRINT_R6   .BLKW #1



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;R0 - character input from keyboard
;R6 - current numerical output
;
;
EVALUATE

START
	AND R1,R1,#0		; clear R1
	AND R2,R2,#0		; clear R2

	TRAP x20 			; GETC read a char into R0
	ADD R0,R0,#0		; read next input
	ST R0,RRR0			; save R0
	ST R7,SAVE_R7		; save R7
	OUT 				; echo to screen 

	LD R1,EQUAL			; while value != '='
	ADD R1,R1,R0
	BRz SUB1F			; go to SUB1F if value is '='

	LD R1,SPACE			; is input space?	
	ADD R1,R1,R0		
	BRz START			; to read next input

						; is input invalid? 
	LD R1,NUM_N94		; check if input is ^
	ADD R1,R1,R0		
	BRz SKIP			; skip if input is ^

	LD R1,NUM_N44		; check if input is invalid
	ADD R1,R1,R0
	BRz PRINT_INV

	LD R1,NUM_N46		; check if input is invalid
	ADD R1,R1,R0
	BRz PRINT_INV

	LD R1,NUM_N42		; check if input is invalid
	ADD R1,R1,R0
	BRn PRINT_INV

	LD R1,NUM_N57		; check if input is invalid
	ADD R1,R1,R0
	BRp PRINT_INV


SKIP					; is value operand? 
	LD R1,NUM_N94
	ADD R1,R1,R0
	BRz SKIP2			; go to SKIP2

	LD R1,NUM_N48
	ADD R1,R1,R0
	BRzp PUSH1			; go to push 
	
SKIP2
	JSR POP				; POP TWO VALUE
	ADD R4,R0,#0		; give value to input R4

	ADD R5,R5,#0		; Stack Underflow?
	BRp PRINT_INV

	JSR POP				; POP
	ADD R3,R0,#0		; give value to input R3

	ADD R5,R5,#0		; Stack Underflow?
	BRp PRINT_INV

	LD R0,RRR0			; LOAD R0
	LD R1,NUM_N94		; apply operand
	ADD R1,R1,R0		
	BRz EXP1			; EXP
	LD R1,NUM_N42		
	ADD R1,R1,R0
	BRz MUL1			; MUL
	LD R1,NUM_N43
	ADD R1,R1,R0
	BRz PLUS1			; PLUS
	LD R1,NUM_N45
	ADD R1,R1,R0
	BRz MIN1			; MIN
	LD R1,NUM_N47
	ADD R1,R1,R0
	BRz DIV1			; DIV
	BRnzp PUSH1			; push the result

EXP1 					; Label for EXP operation
	JSR EXP
	BRnzp PUSH2

MUL1 					; Label for MUL operation
	JSR MUL
	BRnzp PUSH2

PLUS1 					; Label for PLUS operation
	JSR PLUS
	BRnzp PUSH2

MIN1 					; Label for MIN operation
	JSR MIN
	BRnzp PUSH2

DIV1 					; Label for DIV operation
	JSR DIV
	BRnzp PUSH2


SUB1F					; check if stack has only one value
	LD R2,STACK_TOP		; load STACK_TOP into R2
	LD R1,STACK_START	; load STACT_START into R1
	NOT R2,R2			; check if they have a difference of 1 
	ADD R2,R2,#1
	ADD R1,R2,R1
	ADD R1,R1,#-1
	BRz LOAD_R5			; go to load R5


PRINT_INV				; print "Invalid Expression"
	ST R0,PRI_R0
	LEA R0,STR_INV
	PUTS 
	LD R0,PRI_R0
	HALT				; Halt

PUSH1					; push and next value for number
	LD R1,NUM_N48		; set R1 as -48
	ADD R0,R0,R1		
	JSR PUSH
	LD R7,SAVE_R7		; restore R7
	BRnzp START			; go to begining 

PUSH2					; push and next value for result	
	JSR PUSH		
	LD R7,SAVE_R7		; restore R7
	BRnzp START			; go to begining 



LOAD_R5
	JSR POP				; POP
	ADD R5,R0,#0		; load result in R5
	BRnzp PRINT_HEX		; go to print R5
	HALT				; Program ends

PRI_R0 .BLKW #1
RRR0   .BLKW #1
SAVE_R7	.BLKW #1



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
PLUS					; plus subroutine
	ADD R0,R3,R4
	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
MIN						; minus subroutine
	NOT R0,R4
	ADD R0,R0,#1
	ADD R0,R0,R3
	RET 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
MUL						; multiply subroutine
	AND R0,R0,#0
	ADD R1,R4,#0
MUL_LOOP				; loop 
	ADD R0,R0,R3
	ADD R1,R1,#-1
	BRp MUL_LOOP
	RET 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4 (R3/R4)
;out R0-quotient, R1-remainder
DIV						; divide subroutine
	ST R2,DIV_R2
	ST R3,DIV_R3
	NOT R2,R4
	ADD R2,R2,#1
	AND R0,R0,#0
	ADD R0,R0,#-1
DIV_LOOP	
	ADD R0,R0,#1
	ADD R3,R3,R2
	BRzp DIV_LOOP
	ADD R1,R3,R4
	LD R2,DIV_R2
	LD R3,DIV_R3
	RET

DIV_R2 .BLKW #1	;
DIV_R3 .BLKW #1	;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
EXP						; exponential subroutine
	ST R1,EXP_R1		; save registers
	ST R2,EXP_R2
	ST R5,EXP_R5

	ADD R0,R3,R4		; R0 <- R3 + R4
	ADD R2,R3,#0		
	ADD R5,R4,#0		; R5 <- R4
	BRz ZERO_R5

EXP_LOOP1
	ADD R4,R4,#-1
	BRz STOP			; go to stop if have completed
	ADD R1,R3,#0
	ADD R0,R2,#0

EXP_LOOP2
	ADD R0,R0,#-1
	BRz EXP_LOOP1
	ADD R3,R3,R1
	BRnzp EXP_LOOP2

STOP					; completed
	ADD R0,R3,#0		
	LD R1,EXP_R1		; restore registers
	LD R2,EXP_R2
	LD R5,EXP_R5
	RET

ZERO_R5
    AND R0,R0,#0
	ADD R0,R0,#1
	LD R1,EXP_R1		; restore registers
	LD R2,EXP_R2
	LD R5,EXP_R5
	RET


EXP_R1 .BLKW #1
EXP_R2 .BLKW #1
EXP_R5 .BLKW #1
	


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


;OUT: R0, OUT R5 (0-success, 1-fail/underflow)
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
	LDR R0, R4, #0		;
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

SPACE 		.FILL #-32	;
EQUAL		.FILL #-61	;
NUM_48		.FILL #48	;
NUM_55		.FILL #55	;
NUM_N30		.FILL #-30	;
NUM_N42		.FILL #-42	;
NUM_N43		.FILL #-43	;
NUM_N44		.FILL #-44	;
NUM_N45		.FILL #-45	;
NUM_N46		.FILL #-46	;
NUM_N47		.FILL #-47	;
NUM_N48		.FILL #-48	;
NUM_N57		.FILL #-57	;
NUM_N94		.FILL #-94	;
STR_INV		.STRINGZ "Invalid Expression"


.END
