;下面的程序执行后,ax中的数值为多少?

assume cs:code
code segment
start:  mov ax,6
        call ax
        inc ax
        mov bp,sp
        add ax,[bp]
        
        mov ax,4c00h
        int 21h
code ends
end start


;ax=0bH


