;--------------------------------------------------------------------------------------
; GVAHIM 
; 
; Template program for .COM files 
;--------------------------------------------------------------------------------------


ideal
model tiny
include "c:\gvahim\gvahim.mac"
dataseg

;--------------------------------------------------------------------------------------
; Begin Data definitions
;--------------------------------------------------------------------------------------
random_array db 300 dup (0)   ;in this array i put 4b\4d = right\left scan codes
x_array db 0
scan_code_50 equ 050h    ;red left
scan_code_4D equ 04dh     ;green = right
scan_code_4B equ 04bh     ;blue = left
num_of_score dw 0
sum_of_time_second db 59
sum_of_time_minute db 1
nekudotime db ":",0

sound_sign db 0

restart_counter db 0

start_game_question_str db "to start press - 1",0
saved_score_question_str db "to go to the saved scores press - 2",0
quit_question_str db "to quit the game press - 3",0
 
sign_right db ">",0
sign_left db "<",0

ascii_219 db 0,0

score_string db "score:",0

attention_message1 db "<- focus on",0
attention_message2 db "this square!!",0 

esc_instruction db "press ESC for exit",0
restart_instruction db "press 'Z' for restart the game",0
arrows_instruction1 db "press -> for green square",0
arrows_instruction2 db   "and <- for blue square",0


have_fun_instruction db "HAVE FUN :) ",0

space_instruction1 db " now press any key to skip this screen",0 
space_instruction2 db "and start play ",0

shapes_str db "...........MAINE SHAPES...........",0

sound_question1 db "do you want to turn on the sounds?",0
sound_question2 db "it makes the game a little bit slowly...",0
sound_question3 db "press 'y' to yes and any key to no",0
;--------------------------------------------------------------------------------------
; End   Data definitions 
;--------------------------------------------------------------------------------------

codeseg
org 100h
ENTRY: 

;--------------------------------------------------------------------------------------
; Begin Instructions 
;--------------------------------------------------------------------------------------
;name: Dvir Alafi
;names of the teachers:Dov Feldstern,Yair Mirsky,Shaul Chamula.
;2015
start:
;call clear_screen_graphic
mov ax,13h ;set graphical mode
int 10h

push ax  ;to save ax
call print_start_questions
start_get_keystroke:
;pop ax
call get_keystroke

jz start_get_keystroke   ;jz continue the program because if zf=on there is no available keystroke
 ;now we have the ASCII code in  AL
 ;pop ax

 start_loop:
 cmp al,'1'   ;check if  pressed  1  
 je main_loop 
 cmp al,'2'    ;check if  pressed  2  
 je main_loop
 jmp start_get_keystroke
 
main_loop:
pop ax
push_regs <ax,bx,cx,dx,si>
call user_manual_screen
call clear_screen_graphic
call check_for_sound
call clear_screen_graphic
call clear_screen_graphic ;clear the screen and turn it to mode: graphic.
call print_the_instructions    ;print -> attention this square ->
call print_the_big_squares_and_arrows ;-> <-  and big squares 
call draw_the_walls ;white walls to enclose the little squares.
call put_4B_and_4D_and_scan_code_50_in_random_array 
pop_regs <si,dx,cx,bx,ax>

;==================================================================================
;jmp before_evarim_of_the_array
;====================================
before_evarim_of_the_array:
mov si,0
mov ax,0
mov bx,0
mov cx,0   ;cl= counter of the print first/second/last  square..
mov dx,0
mov [x_array],0   ;the first element of the array 
mov [num_of_score],0  ;for the restart

jmp cmp_restart

end_of_the_general_program1:  ;because the jump in the begining of the code its too far.
call clear_screen_graphic
jmp end_of_the_general_program

;=================================================================
cmp_restart:    ;all this for  the begining bishvil sheze lo yadpis 0 stam in the begining.
cmp [restart_counter],0
je evarim_of_the_array
;print score:0
push_regs <dx,ax>
;mov dl,8
;mov dh,0    ;this is for the restart the game for the score will be printed :0
;call change_cursor_position
;mov ax,[num_of_score]
;call print_num_dec
mov dl,7
mov dh,0    ;this is for the restart the game for the score will be printed :0
call change_cursor_position
mov ax,[num_of_score]
call print_num_dec

mov dl,6
mov dh,0    ;this is for the restart the game for the score will be printed :0
call change_cursor_position
mov ax,[num_of_score]
call print_num_dec
pop_regs <ax,dx>
;=================================================
jmp evarim_of_the_array ;For it doesn't jump without a break

inc_restart_counter:
inc [restart_counter]
jmp before_evarim_of_the_array
;jmp main_loop
;=-=-=-==-=-=-=-=-=-=-==-=-=-=-==-=-=-=-=-==-=-=-=-=-==-=-=-=-=-=-==-=-=
;access for the array x-y 0- 2   1-3   2-4 
;x_array =the first element of the array  i inc it every loop  (in bl)
;bl=x_array 
;al=the element from the array  \(the  Content of x_array).
;ah=the scan code from the kelet 
evarim_of_the_array:
;call print_timer
;jc end_of_the_general_program1
mov al,[random_array+bx]    ;AL= the element from the array.
inc cl  
cmp cl,1
je print_first_square    ;I'm doing a push for <dx,ax,cx>     
cmp cl,2                                ;(in the taviot).
je print_second_square   ;I'm doing a push for <dx,ax,cx> 
cmp cl,3
je print_last_square    ;I'm doing a push for <dx,ax,cx>

continue_to_get_keystroke:
mov cl,0 ;the counter of first/second/last printing square.
mov bh,0   ;to get bx 0
call get_keystroke
;DEBUG_REG <ax>
jz continue_to_get_keystroke   ;jz continue the program because if zf=on there is no available keystroke.
call check_for_key
jz continue_to_get_keystroke


;left\right -continue ,ESC =exit the game ,any key = get_keystroke again.
;jz continue_to_get_keystroke    ;is not a legal key stroke (arrows left\right).
;jc end_of_the_general_program
cmp al,27  ;cmp if pressed ESC  if it does exit.
je end_of_the_general_program1

cmp al,'z'
je inc_restart_counter   ;cmp if pressed z if it does restart the game.




mov bl,[x_array]
mov al,[random_array+bx]


cmp ah,al    ;al-in the array ,ah-the scan code from the player 

je right_desicion
jmp wrong_desicion

continue_to_inc_x_array:
inc [x_array]  ;first it was 0-2 now its 1-3 and than 2-4 ....
mov bl,[x_array]
jmp evarim_of_the_array

;print the first,second,last:
 ;first:
print_first_square:
mov [x_array],bl   ;save for the next printing
push cx   ;to save cl for the counting of the first/second/last
mov cx,155   ;x
mov dx,100   ;y

cmp al,scan_code_4D   ;4D
je print_4D_square
cmp al,scan_code_50 
je print_scan_code_50_square
jmp print_4B_square

;second:

print_second_square:
push cx     ;to save cl = the counter
mov cx,155   ;x
mov dx,70    ;y
cmp al,scan_code_4D    ;4D
je print_4D_square
cmp al,scan_code_50 
je print_scan_code_50_square
jmp print_4B_square

;last:

print_last_square:
push cx   ;to save cl the counter
mov cx,155  ;x
mov dx,40   ;y
cmp al,scan_code_4D   ;4D
je print_4D_square
cmp al,scan_code_50 
je print_scan_code_50_square
jmp print_4B_square
;=========================================================================================

print_4B_square:
call make_blue_square
pop cx    ;to save cl the counter
inc bl
jmp evarim_of_the_array

;~~~~~~~~~~~~~~~~~~~~~

print_4D_square:
call make_green_square
pop cx      ;to save cl the counter
inc bl
jmp evarim_of_the_array


print_scan_code_50_square:
call make_red_square
pop cx      ;to save cl the counter
inc bl
jmp evarim_of_the_array
;===============================
right_desicion:
add [num_of_score],00001 ;because its word and I don't want to Dec the asarot or meot.
call print_score
jmp continue_to_inc_x_array

wrong_desicion:  ;add on\off questions ...
cmp [sound_sign],0
je dont_play
call play_wrong
dont_play:
cmp [num_of_score],0
je dont_sub
sub [num_of_score],00001   ;because its word and I don't want to Dec the asarot or meot.
call print_score
dont_sub:
jmp continue_to_inc_x_array
;===============================
 end_of_the_general_program:
   ;  :)   :)  :) :) :) :) :) :) :) :) :) DVIR ALAFI!@#@%#$!~!!!!!~~~~~~~~~~~~~~~
    ret     ; Return to O/S - Last instruction
	
	
	
	;====================================================================================
	
	proc put_4B_and_4D_and_scan_code_50_in_random_array
	;input:the start of the program so that is the parameters:
	;;parameters:
;CX-the counter of the end of the array
;DL-the milliseconds
;SI-the sign to [random_array]
;4D -left scan codes
;4B -right scan codes
;scan_code_50 -down scan code 
;output:i have a array with 300 random elements 4D\4B.	

	push_regs <ax,bx,cx,dx,si>
	
mov cl,0
mov al,2   ;for the xor_shift_random_generator function
mov [word ptr si],0 ;   where si is pointing
lea si,[random_array]


@@loop_array:   
cmp cx,300   ;it signed to the end of the array 
jae @@end_of_function    ;if its the end of the array print all the elements in the  array

call xor_shift_random_generator  ;al=the random number from the function 
;al=the random number

mov bl,2   ;for the hiluk
div bl   ;AH=she'erit 
cmp ah,0
je @@put_4D_in_the_array    ;if zugi put 4D 
mov bl,3 ;if div in 3 put scan_code_50
div bl
cmp ah,0
je @@put_scan_code_50_in_the_array
jmp @@put_4B_in_the_array    ;if iii zugi put 4B



@@put_4D_in_the_array:    ; put in the array 4D that signed a ...
mov [word ptr si],scan_code_4D   ;4D   
inc si
inc cx   ;;the counter of the 300 elements
jmp @@loop_array



@@put_4B_in_the_array:   ;put in the array a 4B that signed a ...
mov [word ptr si],scan_code_4B    ;4B    
inc si
inc cx ;the counter of the 300 elements
jmp @@loop_array




@@put_scan_code_50_in_the_array:   ;put in the array a 4B that signed a ...
mov [word ptr si],scan_code_50   ;4B    
inc si
inc cx ;the counter of the 300 elements
jmp @@loop_array





@@end_of_function:
pop_regs <si,dx,cx,bx,ax>
	ret
	endp put_4B_and_4D_and_scan_code_50_in_random_array
	
	;=========================================================================================
	;;;----this function read a keystroke from the key board 
	;input: ah,0,1
	;output:al-ASCII character. ah-scan code  ZF=
	
	proc get_keystroke
	@@main_loop:
    mov ah,1
    int 16h   ;check if available a key if not jump to main_loop
    jz @@end_of_program   ;ZF is on when key its not available
    mov ah,0  ;there is a key,read it,and clear the buffer
    int 16h
	;if we have a character:
    ;we have the SCAN CODE in  AH.
	;and the ASCII character in Al.
	@@end_of_program:
	;ZF is on when key its not available
	ret 
	endp get_keystroke
	
	;========================================================================================
	proc get_time
push ax
mov al,00h
mov ah,2ch
int 21h
pop ax

ret
endp get_time

;========================================================================================================
	proc xor_shift_random_generator 
	;this function is product a random number and return it in AL
;1	;x (cl)= x  XOR  (shl x,13)    ;shift left  -mul
;2	;x (al)= x  XOR  (shr x,9)      ;shift right -div
;3	;x (cl)= x  XOR  (shl x,7)         


;input:cl-the x for the generate
;output:al-the random number

	push cx   ;because cx is my counter
	mov cl,al ;for saving al for the xor 
	shl al,13
	xor cl,al  ;and this is ;1 
	mov al,cl ;for saving the ;1 x
	shr cl,9
	xor al,cl  ;and this is ;2 x
	mov cl,al ;for saving the ;2 x
	shl al,7
	xor cl,al  ;and this is ;3 x
	mov al,cl        ;and now we have a random number in al 
	pop cx
	
	ret
	endp xor_shift_random_generator
	;=========================================================================================
		proc print_white_pixel  
;INPUT:
;i have to give this function a x and y position in :
;dx = x,cx =y
;input: dx=x    cx=y   
;output: pixel in (dx,cx) - (x,y).
push ax
mov al,15
mov ah,0ch   ;this is the interrupt do the pixel ,al= color
int 10h
pop ax
ret 
endp print_white_pixel
;======================================================================================================

proc print_red_pixel 
;INPUT:
;i have to give this function a x and y position in :
;dx = x,cx =y
;output: pixel in (dx,cx) - (x,y).
push ax
mov al,4
mov ah,0ch   ;this is the interrupt do the pixel ,al= color
int 10h
pop ax
ret 
endp print_red_pixel
;======================================================================================================

proc make_red_square
push_regs <ax,bx>
	mov bx,dx    ;i have the x in bx and dx
	mov ax,cx     ;i got the y in ax and cx
	add ax,20    ;y+20
	add bx,20    ;x+20
	
	@@loop1:
	call print_red_pixel
	inc dx 
	cmp dx ,bx ;x+20
    jne @@loop1	
	
	@@loop2:
	call print_red_pixel
	inc cx 
	cmp cx,ax   ;y+20
	jne @@loop2
 
	sub ax,20   ;ax=y =the first y from the input 
	sub bx,20    ;bx=x =the first x from the input 
	
	@@loop3:
	call print_red_pixel
    dec dx
	cmp dx,bx
	jne @@loop3
	
	@@loop4:
	call print_red_pixel
	dec cx
	cmp cx,ax
	jne @@loop4
	
	
	pop_regs <bx,ax>
ret
endp make_red_square
;==========================================================================================	
	;this function is clear the screen and turn it to mode: graphic.
	
	;input:
	;ah=the number to the interrupt (the identity of the interrupt).
	;al=the number to the interrupt for clearing the screen.
	
	;output:
	;the screen is clean!!
	
	
	proc clear_screen_graphic
	push ax  ;to save ax
	;clear screen:
	mov ah,07h        
	mov al ,00h	
	int 10h         
	;set graphical-mode:
	mov ah,00h
	mov al,13h
	int 10h
	pop ax
	ret
	endp clear_screen_graphic
;=====================================================================================
;input:
;DH=y position
;DL=x position

;output:
;the cursor being changed.{dl,dh} coordinate

proc change_cursor_position
push_regs <ax,bx>

;dh ;y position
;dl ;x position
mov bh, 0  
mov ah, 2  
int 10h
pop_regs <bx,ax>
ret
endp change_cursor_position

;=====================================================================================
;	(x,y).---------->(x+20,y)
;   |               |  
;	|               | 
;	|               |
;   |               |
;	(x-20,x+20)======(x+20,y+20)

			    
	;its help in print_blue_pixel
;this program is get a x,y in cx ,dx      
	;input: cx=y   ,  dx=x	
	;output:make a green square
	proc make_green_square
	push_regs <ax,bx>
	mov bx,dx    ;i have the x in bx and dx
	mov ax,cx     ;i got the y in ax and cx
	add ax,20    ;y+20
	add bx,20    ;x+20
	
	@@loop1:
	call print_green_pixel
	inc dx 
	cmp dx ,bx ;x+20
    jne @@loop1	
	
	@@loop2:
	call print_green_pixel
	inc cx 
	cmp cx,ax   ;y+20
	jne @@loop2
 
	sub ax,20   ;ax=y =the first y from the input 
	sub bx,20    ;bx=x =the first x from the input 
	
	@@loop3:
	call print_green_pixel
    dec dx
	cmp dx,bx
	jne @@loop3
	
	@@loop4:
	call print_green_pixel
	dec cx
	cmp cx,ax
	jne @@loop4
	
	
	pop_regs <bx,ax>
	ret
	endp make_green_square
	
	;===================================================================================
;	(x,y).---------->(x+20,y)
;   |              |  
;	|               | 
;	|               |
;   |               |
;	(x-20,x+20)======(x+20,y+20)	

		    
	;this program is get a x,y in cx ,dx     its help in print_blue_pixel
	;input: cx=y   ,  dx=x	
	;output:make a blue square
    proc make_blue_square	
	push_regs <ax,bx>
	mov bx,dx    ;i have the x in bx and dx
	mov ax,cx     ;i got the y in ax and cx
	add ax,20    ;y+20
	add bx,20    ;x+20
	
	@@loop1:
	call print_blue_pixel
	;call print_red_pixel
	inc dx 
	cmp dx ,bx ;x+20
    jne @@loop1	
	
	@@loop2:
	;call print_red_pixel
	call print_blue_pixel
	inc cx 
	cmp cx,ax   ;y+20
	jne @@loop2
 
	sub ax,20   ;ax=y =the first y from the input 
	sub bx,20    ;bx=x =the first x from the input 
	
	@@loop3:
	call print_blue_pixel
	;call print_red_pixel
    dec dx
	cmp dx,bx
	jne @@loop3
	
	@@loop4:
	;call print_red_pixel
	call print_blue_pixel
	dec cx
	cmp cx,ax
	jne @@loop4
	
	
	pop_regs <bx,ax>

	ret
	endp make_blue_square
;==================================================================================
proc print_black_pixel    
;input: dx=x    cx=y   
;output: pixel in (dx,cx) - (x,y).al=black (0)
push ax
mov al,0   ;black
mov ah,0ch   ;this is the interrupt do the pixel ,al= color
int 10h
pop ax
ret
endp  print_black_pixel
;==================================================================================================
	
proc print_green_pixel    
;input: dx=x    cx=y   
;output: pixel in (dx,cx) - (x,y).al=green (10)
push ax
mov al,10   ;green
mov ah,0ch   ;this is the interrupt do the pixel ,al= color
int 10h
pop ax
ret
endp  print_green_pixel

;=======================================================================================
	
proc print_blue_pixel
;input: dx=x    cx=y    
;output: pixel in (dx,cx) - (x,y).al=blue(1)
push ax
mov al,1   ;blue
mov ah,0ch   ;this is the interrupt do the pixel ,al= color
int 10h
pop ax
ret
endp print_blue_pixel
;=====================================================================================	
;input: there is no input but the parameters:
;AL=the duty number of the array
;BX=the counter of how many to print -100 the all elements of the array
;BX=the pointer for the array element 1 element 2 and then ....

;output:
;printing all the elements of the array ...

	proc  print_the_array
	push_regs <ax,bx>
mov ax,0
mov bx,0
@@print:
mov al,[random_array+bx]  ;the duty  (toran) number of the array.
mov ah,0
call print_num_hex
call new_line
inc bx
cmp bx,100
jb @@print
 
pop_regs <bx,ax> 
	ret
	endp print_the_array
; =====================================================================================================	
	;this function is print a black square (to clean the previous score)and print the score in ;[num_of_score]
	;input:
	;[num_of_score] meudkan lanikud.
	;output:the score 
proc print_score

	push_regs <ax,bx,cx,dx,si>
;first printing the "score:"

	mov dl,0
	mov dh,0
    call change_cursor_position	
	lea si,[score_string]
	call print_str
	
	@@continue:
	cmp [num_of_score],10
	jb @@loop1 
	
	
	

	mov ax,[num_of_score]  ;print in dl=6
	call print_num_dec
	jmp @@end_of_function
	
	@@loop1:
	mov dl,6 
	mov dh,0
	call change_cursor_position
	mov ax,0
	call print_num_dec  ;i print 0 because: ;for if its 10 and the -1 its printing 90 <-(this 0 from the previous 10)and now it doesn't... 
	
	mov dl,7  
	mov dh,0
	call change_cursor_position
	mov ax,[num_of_score]
	call print_num_dec
	
	@@end_of_function:
	
	pop_regs <si,dx,cx,bx,ax>
	ret
	endp print_score
	;=============================================================================================
	;this function is a wait interrupt
	proc wait_functiun
	push_regs <ax,cx,dx>
	mov ah,86h
	mov cx,0424h
	mov cx,0ah
	int 15h
	pop_regs <dx,cx,ax>
	ret
	endp wait_functiun
	;=========================================================================================
	proc print_timer
	
push_regs <dx,si>	
	@@loop_time:
	
mov [sum_of_time_second],59
mov bh,60 ;bh=the seconds
mov ah,0
;INT 21h / AH=2Ch 
;DH = second from the int 
loop_:
call get_time
mov dh,bl
inc bl
loop_time:
call get_time
cmp dh,bl
jae dec_and_print_the_timer
jmp loop_time
dec_and_print_the_timer:
cmp [sum_of_time_second],1
je end_of
dec [sum_of_time_second]
mov ah,0
mov al,[sum_of_time_second]
call print_num_dec
call new_line
;jmp loop_
jmp contin
end_of:
jmp end_of_the_general_program
;mov [sum_of_time_second],59

contin:
	
	
	
	
	
	pop_regs <si,dx>
	
	ret 
	endp print_timer
	
	
	;============================================================================================
	proc check_for_key
    push dx
	cmp ah,scan_code_4B
	je @@turn_off_zf
	cmp ah,scan_code_4D
	je @@turn_off_zf
	cmp ah,scan_code_50
	je @@turn_off_zf
	cmp al,'z'
	je @@turn_off_zf
	cmp al,27
	je @@turn_off_zf
	
	@@turn_on_zf_isnt_a_legal_key:
	mov dx,2
	sub dx,2
	jmp @@end_of_program
	
	
	@@turn_off_zf:
	add dx,2
	@@end_of_program:
	pop dx
	ret
	endp check_for_key
	;============================================================================================
	;;this function is draw the walls between the squares...
	;input: no input it just paint
	;output:its draw the walls

	proc draw_the_walls
    push_regs <ax,cx,dx>
	
	
	
    ;draw the left wall :
    mov cx,140   ;x position
    mov dx,40  ;y position
 
    @@draw_left_wall:
    call print_white_pixel
    inc dx
    cmp dx,130
    je @@draw_right_wall
    jmp @@draw_left_wall


    @@draw_right_wall:   ;draw the right wall:
    mov cx,190   ;x position
    mov dx,40  ;y position
 
    @@draw_loop:
    call print_white_pixel
    inc dx
    cmp dx,130
    je @@end_of_program
    jmp @@draw_loop

@@end_of_program:
	pop_regs <dx,cx,ax>
	
	ret
	endp draw_the_walls
;=========================================================================================	
;this function is printing the start questions =quit ?,start?,saved scores?
	proc print_start_questions

push_regs <ax,bx,cx,dx,si>
mov dl,4
mov dh,3
call change_cursor_position
lea si,[shapes_str]
call print_str



mov dl,2
mov dh,12
call change_cursor_position

lea si,[start_game_question_str] 
call print_str
call new_line
call new_line


mov dl,2
mov dh,15
call change_cursor_position

lea si,[saved_score_question_str]
;call print_str
call new_line
call new_line



mov dl,4
mov dh,18
call change_cursor_position

lea si,[have_fun_instruction]
call print_str
call new_line
call new_line

;mov dl,2
;mov dh,12
;call change_cursor_position

;lea si,[quit_question_str]
;call print_str
;call new_line
;call new_line
pop_regs <si,dx,cx,bx,ax>	
ret
endp print_start_questions
	;===============================================================================================
	proc print_the_big_squares_and_arrows
	
	push_regs <si,ax,bx,cx,dx>
mov dx,140
mov cx,200
;the big green::::::

	;its help in print_blue_pixel
;this program is get a x,y in cx ,dx      
	;input: cx=y   ,  dx=x	
	;output:make a green square
	mov bx,dx    ;i have the x in bx and dx
	mov ax,cx     ;i got the y in ax and cx
	add ax,40    ;y+40
	add bx,40    ;x+40
	
	@@loop1green:
	call print_green_pixel
	inc dx 
	cmp dx ,bx ;x+40
    jne @@loop1green
	
	@@loop2green:
	call print_green_pixel
	inc cx 
	cmp cx,ax   ;y+40
	jne @@loop2green
 
	sub ax,40   ;ax=y =the first y from the input 
	sub bx,40    ;bx=x =the first x from the input 
	
	@@loop3green:
	call print_green_pixel
    dec dx
	cmp dx,bx
	jne @@loop3green 
	
	@@loop4green:
	call print_green_pixel
	dec cx
	cmp cx,ax
	jne @@loop4green
	
	
	;print the big blue::::::::
	
	
;this program is get a x,y in cx ,dx     its help in print_blue_pixel
	;input: cx=y   ,  dx=x	
	;output:make a blue big square
  
  
mov dx,140
mov cx,90
  
  
	mov bx,dx    ;i have the x in bx and dx
	mov ax,cx     ;i got the y in ax and cx
	add ax,40    ;y+40
	add bx,40    ;x+40
	
	@@loop1:
	call print_blue_pixel
	inc dx 
	cmp dx ,bx ;x+40
    jne @@loop1	
	
	@@loop2:
	call print_blue_pixel
	inc cx 
	cmp cx,ax   ;y+40
	jne @@loop2
 
	sub ax,40   ;ax=y =the first y from the input 
	sub bx,40    ;bx=x =the first x from the input 
	
	@@loop3:
	call print_blue_pixel
    dec dx
	cmp dx,bx
	jne @@loop3
	
	@@loop4:
	call print_blue_pixel
	dec cx
	cmp cx,ax
	jne @@loop4
	
	
	
	;ARROWS:
	
mov dx,189
mov cx,200
@@loop_left_arrow:     ;green arrow
call print_white_pixel
inc cx
cmp cx,240
je @@next_arrow
jmp @@loop_left_arrow

@@next_arrow:     ;blue arrow

mov dx,189
mov cx,90
@@loop_right_arrow:
call print_white_pixel
inc cx
cmp cx,131
je  @@before_print_the_sign_of_arrows    ;>
jmp @@loop_right_arrow


;print the sign of arrows   -->  .  <--    :


@@before_print_the_sign_of_arrows:
mov dh,151
mov dl,51
call change_cursor_position	
lea si,[sign_left]  ;<	
call print_str;;;;
                      
mov dh,151
mov dl,70
call change_cursor_position
lea si,[sign_right]  ;>
call print_str	
	
	@@end_of_program:
pop_regs <dx,cx,bx,ax,si>
ret
	endp print_the_big_squares_and_arrows



;============================================================================================
;print:

;|======
;|     |    <-attention this square
;=======


proc print_the_instructions
push_regs <dx,si>

mov dl,1
mov dh,2
call change_cursor_position
lea si,[esc_instruction]
call print_str

mov dl,1
mov dh,3
call change_cursor_position
lea si,[restart_instruction]
call print_str


mov dl,1
mov dh,7
call change_cursor_position
lea si,[have_fun_instruction]
call print_str










;print the  <- focus on this square::

mov dl,24
mov dh,13   ;row
call change_cursor_position
lea si,[attention_message1]  ;"<-focus on"
call print_str

mov dl,24
mov dh,14   ;row
call change_cursor_position
lea si,[attention_message2]  ;"this square!!"
call print_str

pop_regs <si,dx>
ret 
endp print_the_instructions

;============================================================================================================
proc user_manual_screen
push_regs <ax,dx,si>
;call print_red_screen
call clear_screen_graphic
mov dl,4
mov dh,3
call change_cursor_position
lea si,[shapes_str]
call print_str



mov dl,3
mov dh,6
call change_cursor_position
lea si,[esc_instruction]
call print_str

mov dl,3
mov dh,8
call change_cursor_position
lea si,[restart_instruction]
call print_str


mov dl,3
mov dh,10
call change_cursor_position
lea si,[arrows_instruction1]
call print_str


mov dl,3
mov dh,12
call change_cursor_position
lea si,[arrows_instruction2]
call print_str



mov dl,0
mov dh,14
call change_cursor_position
lea si,[space_instruction1]
call print_str

mov dl,3
mov dh,16
call change_cursor_position
lea si,[space_instruction2]
call print_str


mov dl,1
mov dh,19
call change_cursor_position
lea si,[have_fun_instruction]
call print_str


@@get_keystroke:
call get_keystroke
jz @@get_keystroke
cmp al,8    ;check if pressed backspace...
je @@end_of_function
 


@@end_of_function:
pop_regs <si,dx,ax>
ret
endp user_manual_screen 
;==================================================================================================================
;print the whole screen in red color
proc print_red_screen
mov dx,0
mov cx,0
mov bx,0
@@loop_row:
call print_red_pixel
inc cx
cmp cx,318
je @@inc_dx
jmp @@loop_row


@@inc_dx:
;call wait_functiun
cmp dx,198
je @@end_of_function
inc dx
inc bx
mov cx,bx
jmp @@loop_row

@@end_of_function:
call clear_screen_graphic
ret
endp print_red_screen
;===================================================================================================================
;this function is play in the speakers
;a musical note if the user pressed the wrong key
;input:
;ax=the octave
;ax=the access for the speakers (turn on\off and changing).
;output:a note
	proc play_wrong
	push ax
	
	in al, 61h  ;read the speaker status 
or al, 00000011b ;make the last two bytes =00
out 61h, al ;write back to the speaker

mov al, 0b6h  ;an access for changing the musical note
out 43h, al

mov ax, 0222fh   ;131 Hz   =1,193,180\131
out 42h, al
mov al, ah
out 42h, al
  
  
loop_play:  
call get_keystroke
jnz @@end_of_function
push_regs <ax,cx,dx>
	mov ah,86h
	mov dx,01h
	mov cx,04h
	int 15h
	pop_regs <dx,cx,ax>

  @@end_of_function:
in al, 61h    ;stop the speakers
and al, 11111100b
out 61h, al
pop ax
ret
	endp play_wrong
;-=====================================================================================================
proc check_for_sound
push_regs <dx,si,ax>
 mov dl,2
mov dh,14
call change_cursor_position
lea si,[sound_question1]
call print_str


mov dl,0
mov dh,16
call change_cursor_position
lea si,[sound_question2]
call print_str

mov dl,2
mov dh,18
call change_cursor_position
lea si,[sound_question3]
call print_str


@@get_sound_keystroke:
call get_keystroke
jz @@get_sound_keystroke

cmp al,'y'
jne @@end_of_function
mov [sound_sign],1 ;he pressed 'y' what mean that he wants sounds in the game... 


@@end_of_function:
pop_regs <ax,si,dx>
ret
endp check_for_sound



;--------------------------------------------------------------------------------------
; End   Instructions 
;--------------------------------------------------------------------------------------

include "c:\gvahim\gvahim.asm"
end ENTRY
