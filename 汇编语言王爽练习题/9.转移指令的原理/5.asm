;转移地址在内存中的jmp指令
assume cs:code
data segment
    db 1,0,0,2
data ends

code segment
start:mov ax,data
      mov ds,ax
      mov bx,0
      jmp word ptr [bx+1]

      mov ax,4c00h
      int 21h
code ends
end start