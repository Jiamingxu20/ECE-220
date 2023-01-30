
	.ORIG	x3000		; starting address is x3000
	LD R0,HIST_ADDR     ; point R0 to the start of the histogram
	
	; fill the histogram with zeroes 
	AND R6,R6,#0		; put a zero into R6
	LD R1,NUM_BINS		; initialize loop count to 27
	ADD R2,R0,#0		; copy start of histogram into R2

	; loop to fill histogram starts here
HFLOOP	
	STR R6,R2,#0		; write a zero into histogram
	ADD R2,R2,#1		; point to next histogram entry
	ADD R1,R1,#-1		; decrement loop count
	BRp HFLOOP			; continue until loop count reaches zero

	; initialize R1, R3, R4, and R5 from memory
	LD R3,NEG_AT		; set R3 to additive inverse of ASCII '@'
	LD R4,AT_MIN_Z		; set R4 to difference between ASCII '@' and 'Z'
	LD R5,AT_MIN_BQ		; set R5 to difference between ASCII '@' and '`'
	LD R1,STR_START		; point R1 to start of string

	; the counting loop starts here
COUNTLOOP
	LDR R2,R1,#0		; read the next character from the string
	BRz PRINT_HIST		; found the end of the string

	ADD R2,R2,R3		; subtract '@' from the character
	BRp AT_LEAST_A		; branch if > '@', i.e., >= 'A'
NON_ALPHA
	LDR R6,R0,#0		; load the non-alpha count
	ADD R6,R6,#1		; add one to it
	STR R6,R0,#0		; store the new non-alpha count
	BRnzp GET_NEXT		; branch to end of conditional structure
AT_LEAST_A
	ADD R6,R2,R4		; compare with 'Z'
	BRp MORE_THAN_Z     ; branch if > 'Z'

; note that we no longer need the current character
; so we can reuse R2 for the pointer to the correct
; histogram entry for incrementing
ALPHA	ADD R2,R2,R0		; point to correct histogram entry
	LDR R6,R2,#0		; load the count
	ADD R6,R6,#1		; add one to it
	STR R6,R2,#0		; store the new count
	BRnzp GET_NEXT		; branch to end of conditional structure

; subtracting as below yields the original character minus '`'
MORE_THAN_Z
	ADD R2,R2,R5		; subtract '`' - '@' from the character
	BRnz NON_ALPHA		; if <= '`', i.e., < 'a', go increment non-alpha
	ADD R6,R2,R4		; compare with 'z'
	BRnz ALPHA		; if <= 'z', go increment alpha count
	BRnzp NON_ALPHA		; otherwise, go increment non-alpha

GET_NEXT
	ADD R1,R1,#1		; point to next character in string
	BRnzp COUNTLOOP		; go to start of counting loop






; jx30
; Description: the job of my code, PRINT_HIST is to print a histogram 
; based on the calculation above.
; PRINT_HIST composes of 4 parts: 
; 1. print the symbol
; 2. print the space 
; 3. print the number of counts of that symbol
; 4. print the next line

; Register uses:
; R0: print register
; R1: digit counter 
; R2: bit counter 
; R3: histogram
; R4: digit 
; R5: incrementer
; R6: temperatory register



PRINT_HIST

	AND R0,R0,#0		; clear the value of R0
	AND R1,R1,#0		; clear the value of R0
	AND R2,R2,#0		; clear the value of R0
	AND R3,R3,#0		; clear the value of R0
	AND R4,R4,#0		; clear the value of R0
	AND R5,R5,#0		; clear the value of R0
	AND R6,R6,#0		; clear the value of R0
	LD R6,NUM_BINS		; set R0 to 27


S1
	LD R0,HHH			; load the first symbol into R0
	ADD R0,R0,R5		; add incrementer R5 to R0
	OUT					; print the symbol


	LD R0,SPACE			; load the space into R0
	OUT					; print the space

	ST R5,HERE5			; save the value of R5
	ST R6,HERE6			; save the value of R6

	AND R1,R1,#0		; set R1 to 0
	AND R6,R6,#0		; set R6 to 0 

	LD R3,HIST_ADDR		; load the histgram address into R3
	ADD R3,R3,R5		; increment R3 with R5
	LDR R3,R3,#0		; load the value stored at address R3


LOOP1
	
	ADD R6,R1,#-4		; R6 <- R1 - 4
	BRzp HIST_END		; program ends if got 4 sections as well as 16 bits
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



HIST_END

	LD R5,HERE5			; restore R5 from where we save
	ADD R5,R5,#1		; increment R5 

	LD R0,NEXT_LINE		; load the next line into R0
	OUT					; print the next line

	LD R6,HERE6			; restore R6 from where we save
	ADD R6,R6,#-1		; decrement R6
	BRp S1				; go back to S1 if have not printed all 27 lines

DONE	HALT			; done


; the data needed by the program
NUM_BINS	.FILL #27	; 27 loop iterations
NEG_AT		.FILL xFFC0	; the additive inverse of ASCII '@'
AT_MIN_Z	.FILL xFFE6	; the difference between ASCII '@' and 'Z'
AT_MIN_BQ	.FILL xFFE0	; the difference between ASCII '@' and '`'
HIST_ADDR	.FILL x3F00 ; histogram starting address
STR_START	.FILL x4000	; string starting address
HHH			.FILL #64
NUM55		.FILL #55
NEXT_LINE   .FILL x0A
SPACE		.STRINGZ " "
HERE5		.FILL xB005 
HERE6		.FILL xB006 

; for testing, you can use the lines below to include the string in this
; program...
; STR_START	.FILL STRING	; string starting address
; STRING		.STRINGZ "This is a test of the counting frequency code.  AbCd...WxYz."



	; the directive below tells the assembler that the program is done
	; (so do not write any code below it!)

	.END
