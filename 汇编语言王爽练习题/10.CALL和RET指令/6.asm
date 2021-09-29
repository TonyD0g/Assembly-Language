;转移地址在内存中的call指令

;下面的程序执行后，ax中的数值为多少?    (注意：用call 指令的原理来分析，不要在
;debug 中单步跟踪来验证你的结论，对于此程序，在debug 中单步跟踪的结果，不能代表CPU
;的实际执行结果)

assume cs:code
stack segment
    dw 8 dup (0)
stack ends

code segment
start:  mov ax,stack
        mov ss,ax
        mov sp,16
        mov ds,ax
        mov ax,0

        call word ptr ds:[0EH]
        inc ax
        inc ax
        inc ax

        mov ax,4c00h
        int 21h
code ends
end start

;ax=3
