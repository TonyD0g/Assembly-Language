;下面的程序执行后，ax和bx中的数值为多少?

assume cs:code
data segment
    dw 8 dup (0)
data ends

code segment
start:  mov ax,data
        mov ss,ax
        mov sp,16
        mov word ptr ss:[0],offset s
        mov ss:[2],cs
        call dword ptr ss:[0]
        nop

      s:;mov ax,0ffset s 
        sub ax,ss:[0cH]
        mov bx,cs
        sub bx,ss:[0EH]

        mov ax,4c00h
        int 21h
code ends
end start

;ax=1,bx=0