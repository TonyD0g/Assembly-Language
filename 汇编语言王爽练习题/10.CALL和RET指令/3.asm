;下面的程序执行后，ax中的数值为多少
assume cs:code
code segment
start:  mov ax,0
        call s
        inc ax
      s:pop ax

        mov ax,4c00h
        int 21h
code ends
end start

;ax=6