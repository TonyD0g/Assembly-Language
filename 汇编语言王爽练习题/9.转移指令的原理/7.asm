;执行指令后，(CS)=? (IP)=?

assume cs:code
code segment
start:
      mov ax,2000H
      mov es,ax
      mov es:[1000H],00BEH
      mov es:[1002H],0006H
      jmp dword ptr es:[1000H]

      mov ax,4c00h
      int 21h
code ends
end start