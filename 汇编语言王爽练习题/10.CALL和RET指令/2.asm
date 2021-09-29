;下面的程序中，retf指令执行后，CS:IP指向代码段的第一条指令
assume cs:code
stack segment
    db 16 dup (0)
stack ends

code segment
        mov ax,4c00h
        int 21h

start:  mov ax,stack
        mov ss,ax
        mov sp,16
        mov ax,0
        push cs
        push ax
        mov bx,0
        retf
code ends
end start

;补全程序，实现从内存 1000:0000处开始执行指令
assume cs:code
stack segment
    db 16 dup (0)
stack ends

code segment
start:  mov ax,stack
        mov ss,ax
        mov sp,16
        mov ax,cs
        push ax
        mov ax,0
        retf
code ends
end start