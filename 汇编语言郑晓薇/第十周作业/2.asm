;动态从键盘输入20个二位无符号数,找出其中
;最大数并显示.

assume cs:code,ds:data,ss:stack
stack segment
    dw 10 dup (?)
stack ends

data segment
    buf1 db 'Please input the num!','$'
    number1 db 5 dup (?)
    max db ?
data ends

code segment
start:      mov ax,data
            mov ds,ax
            mov ax,stack
            mov ss,ax
            mov sp,14H  
            mov si,0
            mov cx,5 

            mov ah,9
            mov dx,offset buf1
            int 21h
            call CR2

continue1:  call control1                           ;输入20个二位数
            mov ds:byte ptr [number1+si],al
            call CR2
            inc si
            loop continue1

            mov cx,5
            mov si,0
continue2:  mov al,ds:byte ptr [number1+si]         ;求最大值
            cmp al,ds:byte ptr [max]
            ja TheMax
continue3:  inc si
            loop continue2 

            mov dx,0
            mov ah,0
            mov bx,0
            mov al,ds:byte ptr [max]

            call stackdiv16

            
over1:      mov ax,4c00h
            int 21h

TheMax:     mov ds:byte ptr [max],al
            jmp continue3

control1:			
		push bx
		push cx
		push dx
		xor bl, bl  ;bl保存结果	如果两个位的值相同（同为 0 或同为 1），则结果位等于 0；否则结果位等于 1。
		xor cx, cx  ;将cx清零									   ;CX为正负标志，0为正，－1为负
		mov ah, 1	
		int 21h				
		cmp al, '+'
		jz symbol1
		cmp al, '-'
		jnz symbol2	
		mov cx, -1
symbol1: 						;作用:不断输入数字，直到输入回车就结束
		mov ah,  1
		int 21h
symbol2:    					;-号:
		cmp al, '0'				
		jb exit1		;清除输入的字符中不是数字的ascii码值
		cmp al, '9'		
		ja exit1		;清除输入的字符中不是数字的ascii码值
		
		sub al, 30h	;将其变为纯数字
		xor ah, ah	;将ah清零
        call change
		jmp symbol1
exit1:
		cmp cx, 0
		jz exit2
		neg bl
exit2:
		mov al, bl
		pop dx
		pop cx
		pop bx
		ret

        ret

change:	shl bl, 1	
		mov dl, bl	;将0给dl
		shl bl, 1	;将bl中的数据左移
		shl bl, 1
		add bl, dl
		add bl, al
        ret




stackdiv16:   push si
              mov si,0

cricle:       cmp ax,99         ;如果超过2位数，则跳走
              ja cricle2
              cmp ax,90         ;(特殊情况)先压dx,再压ax,最后弹栈
              jz    next4
              cmp ax,80
              jz    next4            
              cmp ax,70
              jz    next4
              cmp ax,60
              jz    next4
              cmp ax,50
              jz    next4
              cmp ax,40
              jz    next4
              cmp ax,30
              jz    next4
              cmp ax,20
              jz    next4
              cmp ax,10
              jz    next4             
cricle1:      mov bx,10
              div bx

              cmp dx,0
              jbe  next1     ;余数比0小就退出，代表数据全部处理完毕
              
              push dx
              inc si
              mov dx,0

              jmp cricle1

cricle2:      mov bx,10
              div bx
              push dx
              mov dx,0
              div bx
              push dx
              push ax
              add si,3
              jmp next2

next1:       
              push ax
              inc si
next2:        cmp si,0
              jbe next3         ;如果计数器小于0，则结束

              pop bx
              dec si
              mov ah,2
              mov dl,bl
              add dl,30h
              int 21h

              jmp next2

next4:        mov bx,10
              div bx
              push dx
              push ax
              pop bx
              mov ah,2
              mov dl,bl
              add dl,30h
              int 21h
              pop bx
              mov ah,2
              mov dl,bl
              add dl,30h
              int 21h
              jmp next3              
 
next3:        call CR2          ;回车和换行
              pop si            
              ret


    CR2:    mov ah,2
            mov dl,0ah
            int 21h   
            mov ah,2
            mov dl,0dh
            int 21h
            ret

code ends
end start