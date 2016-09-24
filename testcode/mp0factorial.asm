ORIGIN 4x0000

; End result will be in R2 and R3


; Registers
;	R0:	used for the value 0	
;	R1:	
;	R2:	used as a number to multiply by, starting with the parameter value. 
;		will contain final answer
;	R3: contains the product so far. Also will contain final answer
;	R4: contains the current number we are on to multiply by (5...4...3...2...1)
;	R5:	contains counter for the number of times to add (number to multiply by)
;	R6: contains -1 to decrement counters
;	R7: 

	; init all the used registers
START:
	LDR R2, R0, PARAMETER
	LDR R6, R0, DECREMENT
	LDR R5, R0, PARAMETER 
	LDR R4, R0, PARAMETER
	ADD R5, R5, R6			;Parameter N - 1
	ADD R4, R4, R6			;Parameter N - 1

	BRp	MULTIPLY


LOOP:
	ADD R4, R4, R6	;decrement R4
	ADD R5, R4, R6	;set R5 to the new number to multiply by, minus 1

	BRp	MULTIPLY	;go to multiplication unless the counter is 0
	BRnzp HALT
	
	
	;Here we add R2 to R3 (should contain same value evertime this loop begins)
	;do this until counter reaches 0, effectively multiplying
MULTIPLY:
	ADD R3, R3, R2
	ADD R5, R5, R6
	BRp MULTIPLY
	ADD R2, R0, R3	;store the new value of R3 (product so far) into R2
	BRnzp LOOP


	;infinite loop
HALT:
	BRnzp HALT
	




PARAMETER:	DATA2 4x0005

DECREMENT: DATA2 4xffff







