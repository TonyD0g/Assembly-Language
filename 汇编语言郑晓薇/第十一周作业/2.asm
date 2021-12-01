;编写一个子程序嵌套结构的程序模块，分别从键盘
;输入姓名及8个字符的电话号码,并以一定的格式显示出来.
assume cs:code,ds:data,ss:stack
stack segment
    dw 8 dup (?)
stack ends

data segment
    buf0 db 0ah,0dh,'Input the name: ',0ah,0dh,'$'
    buf1 db 0ah,0dh,'Input the name: ',0ah,0dh,'$'
    buf5 db 0ah,0dh,'---------------------------------------------------',0ah,0dh,'$'   ;美化
    buf6 db 0ah,0dh,'Name       Score   ',0ah,0dh,'$'   
    errorbuf db 0ah,0dh,'Please enter the correct number!',0ah,0dh,'$'  ;错误提示
    name1 db 'name: ','$'         ;姓名
    score1 db 'score: ','$'       ;分数
    student1    db ?,?,?,?,?,?,?,?
data ends 

code segment
start:mov ax,data
      mov ds,ax
      mov ax,stack
      mov ss,ax
      mov sp,10h
      call INPUT_NAME
      call INPUT_PHONE
      call PRINT


over1:mov ax,4c00h
      int 21h

PRINT proc far
        mov ah,9
        mov dx,offset buf6
        int 21h

        mov cx,7
        mov si,0
loop2:  mov ah,2
        mov dl,ds:byte ptr [student1+si]
        int 21h
        inc si
        loop loop2

        mov cx,5
loop3:  mov ah,2
        mov dl,20h
        int 21h
        loop loop3

        mov dx,0
        mov ax,0
        mov al,ds:byte ptr [student1+7]
        call stackdiv16

        mov ah,9
        mov dx,offset buf5
        int 21h                  
        ret
PRINT endp

stackdiv16 proc far
              push bx
              push dx
              push si
              mov si,0
              
cricle1:      mov bx,10
              div bx

              cmp ax,0
              jbe  next1     ;商比0小就退出，代表数据全部处理完毕
              
              push dx
              inc si
              mov dx,0

              jmp cricle1

next1:        push dx
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
             
next3:        
              pop si     
              pop dx       
              pop bx
              ret


stackdiv16 endp

INPUT_PHONE proc far
    go2:mov ah,9
        mov dx,offset buf1
        int 21h
        mov ah,9
        mov dx,offset score1
        int 21h
        mov ax,0
        call control1       ;输入成绩
        cmp ax,100          ;如果是非法成绩
        ja over12
        mov ds:byte ptr [student1+7],al      ;保存成绩
        mov ah,9
        mov dx,offset buf5
        int 21h
        jmp go3

over12: mov ah,9
        mov dx,offset buf5
        int 21h
        mov ah,9
        mov dx,offset errorbuf
        int 21h
        jmp go2
   go3: ret
INPUT_PHONE endp  

control1 proc far			
		
		push bx
		push cx
		push dx
		xor bx, bx  ;bl保存结果	如果两个位的值相同（同为 0 或同为 1），则结果位等于 0；否则结果位等于 1。
		xor cx, cx  ;将cx清零
        xor dx, dx									   ;CX为正负标志，0为正，－1为负
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
		neg bx
exit2:
		mov ax, bx
		pop dx
		pop cx
		pop bx
		ret

        ret
		
change proc far         ;x * 10
	shl bl, 1	
	mov dl, bl	
	shl bl, 1	
	shl bl, 1       ;将bl中的数据左移两次,使bl=8
	add bx, dx
	add bx, ax      
        ret
change endp

control1 endp

INPUT_NAME proc far     ;成绩录入并输出
                
                mov ah,9
                mov dx,offset buf0
                int 21h 
		        cmp al, '0'				
                mov si,0
                mov bx,0
studentnum1:    call CR2        
                mov ah,9
                mov dx,offset name1
                int 21h
        Restart:mov cx,7
                mov si,0
        loop1:  mov ah,1
                int 21h
                cmp al,20h      ;遇到空格换下一个位置
                jz go1
                .if al>='a'
                        .if al<='z'
                                mov ds:byte ptr [student1+si],al     ;ASCII码直接传入
                                jmp test1
                        .endif
                .endif

                .if al>='A'
                        .if al<='Z'
                                mov ds:byte ptr [student1+si],al     ;ASCII码直接传入
                                jmp test1
                        .endif
                .endif
                sub si,1
                inc cx
        test1:  inc si
                loop loop1      
         go1:   mov ah,9
                mov dx,offset buf5
                int 21h
                ret
INPUT_NAME endp

CR2 proc far    ;输出回车和换行
                push ax
                push dx
                mov ah,2
                mov dl,0ah
                int 21h   
                mov ah,2
                mov dl,0dh
                int 21h
                pop dx
                pop ax
                ret
        CR2 endp     
code ends
end start   