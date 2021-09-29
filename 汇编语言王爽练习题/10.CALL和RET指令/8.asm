;下面的程序执行后，bx中的数值为多少?

assume cs:code
code segment
start:  mov ax,1
        mov cx,3
        call s
        mov bx,ax 
        mov ax,4c00h
        int 21h

      s:add ax,ax
        loop s
        ret 

code ends
end start

;bx=8