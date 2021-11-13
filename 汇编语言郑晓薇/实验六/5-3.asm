;coding:gbk
;实验五，分支程序设计的第五题：
;题目:
;在内存中以buf单元开始缓冲区中连续存放着10个
;学生的分数，试编制程序统计其中90~100分，80~89分，60~79分
;及60分以下者各有多少人，并把结果分别存放
;在S9,S8,S7和S6中，并显示各段人数

;90~100分，80~89分，60~79分,60分以下.

assume cs:code,ds:data,ss:stack
data segment
   x db 'INPUT  YOUR NAME:','$'
   y db 39,91,92,80,81,82,60,61,62,50         
   buf0 db 'Input the score :','$'
   buf1 db 'The number is too big','$'
   buf2 db 'The s9 hava :','$'
   buf3 db 'The s8 hava :','$'
   buf4 db 'The s7 hava :','$'
   buf5 db 'The s6 hava :','$'
   s9 db ?
   s8 db ?
   s7 db ?
   s6 db ?
   num db ?
data ends

stack segment
   dw 7 dup ('/')         
stack ends

code segment
start:      mov ax,data
            mov ds,ax

            mov ax,stack
            mov ss,ax   
            mov sp,0eh  

            mov si,0
            mov cx,10
            mov bx,0
            mov bx,offset y
            mov ds:byte ptr [num],bl
    main:   call input1         ;输出Input the score
            call control1
            mov ds:byte ptr [num+si],al

            cmp ds:byte ptr [num+si],100     ;如果输入的数字太大
            ja over2

            cmp ds:byte ptr [num+si],60      ;如果小于60分
            jb set1

            cmp ds:byte ptr [num+si],90      ;如果大于等于90分
            jae set2

            cmp ds:byte ptr [num+si],80      ;如果大于等于80分
            jae set3    

            cmp ds:byte ptr [num+si],60      ;如果大于等于60分
            jae set4
            
    continue:
            inc si        
            loop main
            jmp over1

    set1:   
            
            add ds:byte ptr [s6],1
            call output
            mov ah,9
            mov dx,offset buf5  
            int 21h

            mov ah,2
            mov dl,ds:byte ptr [s6]
            add dl,30h
            int 21h

            call CR2
            jmp continue

    set2:   

            add ds:byte ptr [s9],1  
            call output
            mov ah,9
            mov dx,offset buf2  
            int 21h

            mov ah,2
            mov dl,ds:byte ptr [s9]
            add dl,30h
            int 21h

            call CR2
            jmp continue   

    set3:   
        
            add ds:byte ptr [s8],1
            call output
            mov ah,9
            mov dx,offset buf3  
            int 21h

            mov ah,2
            mov dl,ds:byte ptr [s8]
            add dl,30h
            int 21h

            call CR2
            jmp continue

    set4:   

            add ds:byte ptr [s7],1
            call output
            mov ah,9
            mov dx,offset buf4  
            int 21h

            mov ah,2
            mov dl,ds:byte ptr [s7]
            add dl,30h
            int 21h

            call CR2
            jmp continue

    over2:  call CR2
            mov ah,9
            mov dx,offset buf1
            int 21h
            call CR2
            jmp continue

    over1:  mov ax,4c00h
            int 21h


    CR2:    mov ah,2
            mov dl,0ah
            int 21h   
            mov ah,2
            mov dl,0dh
            int 21h
            ret

output:     mov ah,2
            mov dl,0dh
            int 21h
            ret


input1:     mov ah,9
            mov dx,offset buf0
            int 21h  
            ret

control1:   push bx
            push cx
            push dx			

            xor bl, bl  
            xor cx, cx  ;将cx清零	;CX为正负标志，0为正，－1为负
            mov ah, 1	
            int 21h				
            cmp al, '+'
            jz symbol1
            cmp al, '-'
            jnz symbol2	
            mov cx, -1
symbol1: ;作用:不断输入数字，直到输入回车就结束
                
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
                call CR2
		jz exit2
		neg bl
exit2:
		mov al, bl
        pop dx
		pop cx
		pop bx
		ret
               
                ret

change:	        shl bl, 1	
		mov dl, bl	;将0给dl
		shl bl, 1	;将bl中的数据左移
		shl bl, 1
		add bl, dl
		add bl, al
                ret

code ends
end start