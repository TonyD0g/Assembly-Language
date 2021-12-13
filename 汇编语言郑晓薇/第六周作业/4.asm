;coding:GBK

;[只能显示个位数]
;5.在此基础上，把程序改为下面的表达式，写出代码：   
;W=((X+Y)*2-Z)/2   ;X,Y,Z,W均为8位二进制数值

assume cs:code,ds:data,ss:stack
data segment
    x db ?  ;3
    y db ?  ;2
    z db ?  ;1
    w db ?  
data ends

stack segment
    dw 13 dup (0)
stack ends

code segment
start:  mov ax,data
        mov ds,ax
        mov cx,4
        mov si,0
        mov ax,stack
        mov ss,ax
        mov sp,001Ah


       mov ax,'='   ;将符号全部压栈
       push ax   
       mov ax,'2'   
       push ax
       mov ax,'/'
       push ax
       mov ax,')'
       push ax
       mov ax,'-'
       push ax
       mov ax,'2'       
       push ax
       mov ax,'*'
       push ax
       mov ax,')'
       push ax
       mov ax,'+'
       push ax
       mov ax,'('
       push ax
       mov ax,'('
       push ax
       mov ax,'='
       push ax
       mov ax,'w'
       push ax
      
    s: mov ah,2    ;符号弹栈
       pop dx      
       int 21h      
       loop s      ;w=((

       mov ah,1    ;从键盘上输入一个字符并将该字符的ASCII码送入al中    
       int 21h      ;x
       mov ds:byte ptr [x],al

       mov ah,2    ;符号弹栈
       pop dx      
       int 21h      ;+

       mov ah,1    ;从键盘上输入一个字符并将该字符的ASCII码送入al中    
       int 21h      ;y
       mov ds:byte ptr [y],al

       mov cx,4
    s1:mov ah,2    ;符号弹栈
       pop dx      
       int 21h      ;) *2-
      loop s1


       mov ah,1    ;从键盘上输入一个字符并将该字符的ASCII码送入al中    
       int 21h      ;z
       mov ds:byte ptr [z],al


       mov cx,4
    s2:mov ah,2    ;符号弹栈
       pop dx      
       int 21h      ;)/2=
        loop s2
                   
        
        mov ax,0000h              ;运算
        mov al,ds:byte ptr [x]  ;x+y=w
        sub al,30h
        add al,ds:byte ptr [y]  ;x+y=w
        sub al,30h

        mov bl,02h
        mul bl      ;w*2，结果放在ax中
        ;mov ds:byte ptr [w],al
        mov bl,ds:byte ptr [z]
        sub bl,30h
        sub al,bl  ;w-z
        mov dl,02h
        div dl

        mov ds:byte ptr [w],al

        mov ah,2            ;输出w的结果
        mov dl,ds:byte ptr [w]
        add dl,30h
        int 21h             ;执行完后，al的值等于dl的值


        mov ax,4c00h
        int 21h

code ends
end start
