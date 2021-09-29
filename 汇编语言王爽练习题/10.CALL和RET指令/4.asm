;下面的程序执行后，ax中的数值为多少?
assume cs:code
code segment
start:  mov ax,0
        call far ptr s
        inc ax
      s:pop ax
        add ax,ax
        pop bx
        add ax,bx

        mov ax,4c00h
        int 21h
code ends
end start

;ax=1010H
