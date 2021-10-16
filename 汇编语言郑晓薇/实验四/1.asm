;1和2.改为从键盘输入X，Y，Z的值，分别为1,4,3

assume cs:code,ds:data
data segment
    x db ?  ;3
    y db ?  ;2
    z db ?  ;1
    w db ?  
data ends
code segment
start:  mov ax,data
        mov ds,ax
        mov cx,3
        mov si,0

    s:  mov ah,1    ;从键盘上输入一个字符并将该字符的ASCII码送入al中    
        int 21h
        mov ds:byte ptr [si],al
        inc si      ;1=31h-30h  4=34h-30h   3=33h-30h
        loop s

        mov si,0
        mov cx,3

     s1:sub ds:byte ptr [si],30h
        inc si 
        loop s1

        mov al,ds:[x]
        add al,ds:[y]
        sub al,ds:[z]
        mov ds:[w],al

        mov ah,2
        mov dl,ds:[w]
        add dl,30h
        int 21h             ;执行完后，al的值等于dl的值


        mov ax,4c00h
        int 21h

code ends
end start
