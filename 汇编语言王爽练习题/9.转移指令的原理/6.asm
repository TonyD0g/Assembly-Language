;使jmp指令执行后，CS:IP指向程序的第一条指令
assume cs:code
data segment
    dd 12345678H
data ends

code segment
start:mov ax,data
      mov ds,ax
      mov bx,0
      mov [bx],00
      mov [bx+2],cs
      jmp dword ptr ds:[0]

      mov ax,4c00h
      int 21h
code ends
end start