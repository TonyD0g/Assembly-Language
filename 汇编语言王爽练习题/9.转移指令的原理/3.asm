;转移的目的地址在指令中的jmp指令
;"jmp far ptr 标号" 实现的是段间转移，又称为远转移
;(CS)=标号所在段的段地址,(IP)=标号在段中的偏移地址

assume cs:codesg
codesg segment
start: s:   mov ax,0
            mov bx,0
            jmp far ptr s
            db 256 dup (0)
        s:  add ax,1
            inc ax 

            mov ax,4c00h
            int 21h  
codesg ends
end start