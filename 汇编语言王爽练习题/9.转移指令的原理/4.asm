;转移地址在寄存器中的jmp指令
;指令格式:  jmp 16位 reg
;功能:(IP)=(16位reg)


assume cs:codesg
codesg segment
start: s:   mov ax,8
            mov bx,0
            jmp ax  
            add ax,1
            inc ax 

            mov ax,4c00h
            int 21h  
codesg ends
end start