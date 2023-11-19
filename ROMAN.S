;Header:
;Rami Mikha
;rmikh229@mtroyal.ca
;COMP2655-002
;A4
;Due: Thursday Nov.19th
;File: ROMANS.S
;Instructor: Paul Pospisil

;This program translates Improved Roman digits to Arab numbers.
;The program is limited to upper case Roman digits only
;Once the user puts in the digits and presses enter
;the program should do the needed convertion and output the result

;Program Status:
;The program assembles and runs
;but does not produce all the correct result
;Printing: is buggy (reason unknown)
;When printing  
;some times random characters are printed at the end of the string
;
;One digit tests:
;X:	expected:10, real:10
;V:	expected:5,  real:5
;Subtract:
;IX:	expected:9, real:9
;Add:
;VII:	expected:7, real:7
;highest value:
;MMMCMXCIX:	expected:3999, real: creates an infinite loop then crashes
;error testing:
;F:	expected:Not a valid roman digit real: Not a valid roman digit
;IM:	expected:out of order real:out of order
;CMC:	expected:already used as modifier real:already used as a modifier 
;XCL	expected:Invalid combination real: Invalid combination
;VV:	expected:Exceeded max use real: Exceeded max use

;Register table:
;d0-used as a temperory holder of chars when write/read char is called
;d1-used to increment/decrement through the array of structure
;d2:
;-subtractor index of r_index
;-used to hold a char that is read in
;-used when reseting count,modified, and modifier at the end
;d3:
;-subtractor index of r_index+1
;-used to hold roman digits from structure
;d4:
;-used to hold value of r_index+1
;-used to hold value of r_last
;-value at r_index*ROMAN_DIGITS_SIZE
;d5:
;-used to hold count at r_index
;-used to hold subtractor index
;-used to hold arab value at r_index
;d6:
;-used to hold max times at r_index
;-used to hold arab_value at r_index
;-used for intermediate steps to get final sum
;d7:
;-holds the final sum
;-holds an arab value at r_index
;a0:
;-used to point at start of all_roman
;-used to point at various strings to print them
;a1:
;-used to point to string that contain values read in from the user
;a2:
;-used to point at the start of all_roman 

CR			equ	13
LF			equ	10
TAB			equ	9
NULL			equ	0


TRUE			equ	1
FALSE			equ	0
MAX_ROMANS		equ	7
MAX_STRING		equ	20
NO_ERROR		equ	0
MAX_DIGIT_COUNT		equ	3
QUIT			equ	'Q'


ROMAN_DIGITS_SIZE	equ	26
DIGIT			equ	0
ARAB_VALUE		equ	2
SUBTRACTOR_INDEX	equ	6
COUNT			equ	10
MODIFIED		equ	14
MODIFIER		equ	18
MAX_TIMES		equ	22

start:
	xref	read_char
	xref	write_char
	xref	exit

				;declaring array of roman digits
	lea	all_roman,a0
	clr.w	d1
	move.b	#'I',DIGIT(a0,d1.w)
	move.l	#1,ARAB_VALUE(a0,d1.w)
	move.l	#-1,SUBTRACTOR_INDEX(a0,d1.w)
	move.l	#0,COUNT(a0,d1.w)
	move.l	#FALSE,MODIFIED(a0,d1.w)
	move.l 	#FALSE,MODIFIER(a0,d1.w)
	move.l	#MAX_DIGIT_COUNT,MAX_TIMES(a0,d1.w)

	add.w	#ROMAN_DIGITS_SIZE,d1
	move.b	#'V',DIGIT(a0,d1.w)
	move.l	#5,ARAB_VALUE(a0,d1.w)
	move.l	#0,SUBTRACTOR_INDEX(a0,d1.w)
	move.l	#0,COUNT(a0,d1.w)
	move.l	#FALSE,MODIFIED(a0,d1.w)
	move.l	#FALSE,MODIFIER(a0,d1.w)
	move.l	#1,MAX_TIMES(a0,d1.w)  


	add.w	#ROMAN_DIGITS_SIZE,d1
	move.b	#'X',DIGIT(a0,d1.w)
	move.l	#10,ARAB_VALUE(a0,d1.w)
	move.l	#0,SUBTRACTOR_INDEX(a0,d1.w)
	move.l	#0,COUNT(a0,d1.w)
	move.l	#FALSE,MODIFIED(a0,d1.w)
	move.l	#FALSE,MODIFIER(a0,d1.w)
	move.l	#MAX_DIGIT_COUNT,MAX_TIMES(a0,d1.w)

	add.w	#ROMAN_DIGITS_SIZE,d1
	move.b	#'L',DIGIT(a0,d1.w)
	move.l	#50,ARAB_VALUE(a0,d1.w)
	move.l	#2,SUBTRACTOR_INDEX(a0,d1.w)
	move.l	#0,COUNT(a0,d1.w)
	move.l	#FALSE,MODIFIED(a0,d1.w)
	move.l	#FALSE,MODIFIER(a0,d1.w)
	move.l	#1,MAX_TIMES(a0,d1.w)

	add.w	#ROMAN_DIGITS_SIZE,d1
	move.b	#'C',DIGIT(a0,d1.w)
	move.l	#100,ARAB_VALUE(a0,d1.w)
	move.l	#2,SUBTRACTOR_INDEX(a0,d1.w)
	move.l	#0,COUNT(a0,d1.w)
	move.l	#FALSE,MODIFIED(a0,d1.w)
	move.l	#FALSE,MODIFIER(a0,d1.w)
	move.l	#MAX_DIGIT_COUNT,MAX_TIMES(a0,d1.w)

	add.w	#ROMAN_DIGITS_SIZE,d1
	move.b	#'D',DIGIT(a0,d1.w)
	move.l	#500,ARAB_VALUE(a0,d1.w)
	move.l	#4,SUBTRACTOR_INDEX(a0,d1.w)
	move.l	#0,COUNT(a0,d1.w)
	move.l	#FALSE,MODIFIED(a0,d1.w)
	move.l	#FALSE,MODIFIER(a0,d1.w)
	move.l	#1,MAX_TIMES(a0,d1.w)

	add.w	#ROMAN_DIGITS_SIZE,d1
	move.b	#'M',DIGIT(a0,d1.w)
	move.l	#1000,ARAB_VALUE(a0,d1.w)
	move.l	#4,SUBTRACTOR_INDEX(a0,d1.w)
	move.l	#0,COUNT(a0,d1.w)
	move.l	#FALSE,MODIFIED(a0,d1.w)
	move.l	#FALSE,MODIFIER(a0,d1.w)
	move.l	#MAX_DIGIT_COUNT,MAX_TIMES(a0,d1.w)

	
	

	lea	str1,a0		;printing string when program starts

write_str1:
	move.b	(a0)+,d0
	beq	done_str1
	jsr	write_char
	bra	write_str1

done_str1:
	lea	str2,a0
write_str2:
	move.b	(a0)+,d0
	beq	done_str2
	jsr	write_char
	bra	write_str2

done_str2:	
	lea string,a1
read_str:
	;checking if enter key is typed to stop taking input
	jsr	read_char
	cmp.b	#CR,d0		
	beq	done_read

	;checking if input is Q to exit of program
	cmp.b	#QUIT,d0	
	beq	exit_program
	move.b	d0,(a1)+
	bra	read_str

done_read:
	;putting NULL at the end of the string to know when to end loop
	move.b	#NULL,(a1)+
	
	clr.l	sum
	move.l	#MAX_ROMANS-1,r_last
	move.l	#NO_ERROR,error

	lea	string,a1
		
error_check:
	;branching to done_proccessing if some error is detected
	cmp.l	#NO_ERROR,error
	bne	done_proccessing
				
null_check:
	move.b	(a1)+,d2	;storing each roman char from string           
	cmp.b	#NULL,d2
	beq	done_proccessing
	
				;finding  which roman char is read
	move.l	#MAX_ROMANS-1,r_index
	move.l	r_index,d1
	muls.w	#ROMAN_DIGITS_SIZE,d1
	lea	all_roman,a2	;r_index index stored in a2
roman_check:
	tst.l	r_index
	blt	done_roman_check
	move.b	DIGIT(a2,d1.w),d3	;moving roman digit to d3 for comparison
	cmp.b	d2,d3
	beq	done_roman_check
	sub.l	#1,r_index
	sub.l	#ROMAN_DIGITS_SIZE,d1
	bra	roman_check
done_roman_check:
	tst.l	r_index
	bge	not_error_1	;if we have error 1 do the following:
	move.l	#1,error	;put error code 1 into error
	bra	error_check	
not_error_1:
	move.l	r_last,d4	;storing r_last in d4 for comparison
	cmp.l	r_index,d4
	bge	smaller_index
	move.l	SUBTRACTOR_INDEX(a2,d1.w),d5
	cmp.l	d4,d5
	bne	is_error_2
				;address for the last roman char
	muls.w	#ROMAN_DIGITS_SIZE,d4
	move.l	COUNT(a2,d4.w),d5
	cmp.l	#1,d5
	bgt	is_error_2

not_error_2:
;storing the address for the last roman char in d4
	move.l	r_last,d4
	muls.w	#ROMAN_DIGITS_SIZE,d4

	;sum + arab_value of r_index - 2 * arab_value of r_last
	move.l	ARAB_VALUE(a2,d1.w),d5
	move.l	ARAB_VALUE(a2,d4.w),d6
	muls.w	#2,d6
	add.l	d5,sum
	move.l	sum,d7
	sub.l	d6,d7
	move.l	d7,sum

	move.l	SUBTRACTOR_INDEX(a2,d1.w),d2
	mulu.w	#ROMAN_DIGITS_SIZE,d2
	sub.l	#1,COUNT(a2,d2.w)

	add.l	#1,COUNT(a2,d1.w)
	move.l	#TRUE,MODIFIED(a2,d1.w)
	move.l	#TRUE,MODIFIER(a2,d2.w)
	
	move.l	r_index,r_last	
	bra	null_check

is_error_2:
	move.l	#2,error	
	bra	error_check 
smaller_index:
	cmp.l	#TRUE,MODIFIER(a2,d1.w)
	bne	not_error_3
	move.l	#3,error
	bra	error_check

not_error_3:
				;checking for error 4
	move.l	d1,d4
	add.l	#ROMAN_DIGITS_SIZE,d4
	move.l	SUBTRACTOR_INDEX(a2,d1.w),d2
	move.l	SUBTRACTOR_INDEX(a2,d4.w),d3
	cmp.l	d2,d3
	bne	not_error_4
	mulu.w	#ROMAN_DIGITS_SIZE,d2
	cmp.l	#TRUE,MODIFIER(a2,d2.w)
	bne	not_error_4
	move.l	#4,error
	bra	error_check	

	
not_error_4:
	add.l	#1,COUNT(a2,d1.w)
	
	move.l	COUNT(a2,d1.w),d5
	move.l	MAX_TIMES(a2,d1.w),d6
	cmp.l	d6,d5
	ble	not_error_5
	move.l	#5,error
	bra	error_check
not_error_5:
	move.l	ARAB_VALUE(a2,d1.w),d7
	add.l	d7,sum
	move.l	r_index,r_last
	bra	null_check
					
;as long as there is no error and not end of string loop back up to error_check
done_proccessing:
	cmp.l	#NO_ERROR,error
	beq	write_result
	lea	str3,a0
write_str3:
	move.b	(a0)+,d0
	beq	done_str3
	jsr	write_char
	bra	write_str3
done_str3:
	move.l	s_index,d0
	add.l	#'0',d0
	jsr 	write_char
	move.l	#CR,d0
	jsr	write_char
	move.l	#LF,d0
	jsr	write_char
				;checking which error and branching to that case
	cmp.l	#1,error
	beq	case1
	cmp.l	#2,error
	beq	case2
	cmp.l	#3,error
	beq	case3
	cmp.l	#4,error
	beq	case4
	cmp.l	#5,error
	beq	case5

case1:
	lea	case1_str,a0
write_case1:
	move.b	(a0)+,d0
	beq	end_of_loop
	jsr	write_char
	bra	write_case1
case2:
	lea	case2_str,a0
write_case2:
	move.b	(a0)+,d0
	beq	end_of_loop
	jsr	write_char
	bra	write_case2
case3:
	lea	case3_str,a0
write_case3:
	move.b	(a0)+,d0
	beq	end_of_loop
	jsr	write_char
	bra	write_case3
case4:
	lea	case4_str,a0
write_case4:
	move.b	(a0)+,d0
	beq	end_of_loop
	jsr	write_char
	bra	write_case4
case5:
	lea	case5_str,a0
write_case5:
	move.b	(a0)+,d0
	beq	end_of_loop
	jsr	write_char
	bra	write_case5
write_result:
	move.l	#CR,d0
	jsr	write_char
	move.l	#LF,d0
	jsr	write_char

	move.l	sum,d1
convert_loop:	
	divu.w	#10,d1
	move.l	d1,d0		
	lsr.l	#8,d0
	lsr.l	#8,d0
	add.l	#'0',d0
	move.l	d0,-(sp)
	tst.w	d1
	bne	convert_loop

write_result_loop:
	move.l	(sp)+,d0
	jsr	write_char
	tst.l	d0
	bne	write_result_loop
	move.b	#CR,d0
	jsr	write_char
	move.b	#LF,d0
	jsr	write_char	
	
end_of_loop: 
	lea	all_roman,a0
	clr.w	d0
	move.w	#MAX_ROMANS-1,d1
reset:
	move.l	COUNT(a0,d0.w),d2
	clr.l	d2
	move.l	d2,COUNT(a0,d0.w)
	
	move.l	MODIFIED(a0,d0.w),d2
	move.l	#FALSE,d2
	move.l	d2,MODIFIED(a0,d0.w)

	move.l	MODIFIER(a0,d0.w),d2
	move.l	#FALSE,d2
	move.l	d2,MODIFIER(a0,d0.w)

	add.w	#ROMAN_DIGITS_SIZE,d0
	dbra	d1,reset	
clear_input:	
	lea	string,a1
	clr.l	d0
	clr.l	d1
	clr.l	d2
clear_increment:
	move.l	(a1)+,d0
	beq	clear_input_loop
	add.l	#1,d1		
	bra	clear_increment
clear_input_loop:
	move.l	d2,-(a1)
	dbra	d1,clear_input_loop
	
	clr.l	d1
	clr.l	d2
	clr.l	d3
	clr.l	d4
	clr.l	d5
	clr.l	d6
	clr.l	d7
	
	bra	done_str1	;looping back up to start

exit_program:
	jsr	exit		


all_roman:	ds.b	ROMAN_DIGITS_SIZE*MAX_ROMANS
string:		ds.b	MAX_STRING+1
sum:		ds.l	1
r_last:		ds.l	1
r_index:	ds.l	1
i:		ds.l	1
error:		ds.l	1	

str1:		dc.b	"This program converts numbers in" 
		dc.b	CR,LF,"Improved Roman notation to Arabic notation",CR,LF
		dc.b	"Input is limited to UPPER case Roman digits only.",CR,LF		
		dc.b	"To exit the program type only the Enter key.",CR,LF,NULL
str2:		dc.b	CR,LF,"Input a Roman number (Press 'Q' to exit): ",CR,LF,NULL
str3:		dc.b	CR,LF,"Character at position ",NULL
case1_str:	dc.b	TAB,"is not a valid Roman digit",CR,LF,NULL
case2_str:	dc.b	TAB,"is out of order for a Improved Roman number",CR,LF,NULL
case3_str:	dc.b	TAB,"has been used as a modifier and can't be used unmodified",CR,LF,NULL
case4_str:	dc.b	TAB,"combination of the modified prior digit and this digit is",CR,LF
		dc.b	"an invalid Roman number",CR,LF,NULL
case5_str:	dc.b	TAB,"has exceeded the maximum occurrences for this digit",CR,LF,NULL
result:		dc.l	sum,CR,LF,NULL 		