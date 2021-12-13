;coding:GBK
;3.如果运算结果小于0,显示的结果正确吗，如何解决

;应该用补码neg      ,这里我投机取巧了，你可以试着改改
;(仅支持个位数的负数运算)
assume cs:code,ds:data,ss:stack
data segment
    x db ?  ;3  ;3+2-6
    y db ?  ;2
    z db ?  ;6
    w db ?  
data ends

stack segment
    dw 3 dup (0)
stack ends

code segment
start:  mov ax,data
        mov ds,ax
        mov cx,3
        mov si,0
        mov ax,stack
        mov ss,ax
        mov sp,0006h

   
       mov ax,'='   ;将符号全部压栈
       push ax
       mov ax,'-'
       push ax
       mov ax,'+'
       push ax

    s:  mov ah,1    ;从键盘上输入一个字符并将该字符的ASCII码送入al中    
        int 21h
        sub al,30h
        mov ds:byte ptr [si],al

        mov ah,2    
        pop dx      ;符号弹栈
        int 21h

        inc si
        loop s

        mov bl,00h
        mov al,00h
        mov al,ds:byte ptr [z]
        mov bl,ds:byte ptr [x]
        add bl,ds:byte ptr [y]
        sub al,bl
        mov ds:byte ptr [w],al

        mov ah,2
        mov dl,'-'
        int 21h

        mov ah,2            ;输出w的结果
        mov dl,ds:byte ptr [w]
        add dl,30h
        int 21h             ;执行完后，al的值等于dl的值


        mov ax,4c00h
        int 21h

code ends
end start
