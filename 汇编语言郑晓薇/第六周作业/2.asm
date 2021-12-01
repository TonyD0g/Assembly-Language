;coding:GBK
;3.改为从键盘输入X，Y，Z的值，分别为1,4,3
;输出格式:  3+2-1=4

assume cs:code,ds:data,ss:stack
data segment
    x db ?  ;3
    y db ?  ;2
    z db ?  ;1
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
        mov ds:byte ptr [si],al

        mov ah,2    
        pop dx      ;符号弹栈
        int 21h

        inc si
        loop s
        
        mov al,00h              ;运算
        mov al,ds:byte ptr [x]
        add al,ds:byte ptr [y]
        sub al,ds:byte ptr [z]
        mov ds:byte ptr [w],al

        mov ah,2            ;输出w的结果
        mov dl,ds:byte ptr [w]
        int 21h             ;执行完后，al的值等于dl的值


        mov ax,4c00h
        int 21h

code ends
end start
