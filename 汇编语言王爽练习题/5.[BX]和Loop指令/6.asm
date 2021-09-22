;编程，向内存 0:200 ~ 0:23F 依次传送数据 0~63(3FH)      (9条指令实现)

assume cs:codesg
codesg segment
    mov ax,20h 
    mov ds,ax 
    mov bx,0    
    mov cx,40h
s:  mov [bx ],bx
    inc bx 
    loop s 

    mov ax,4c00h
    int 21h 

codesg ends
end 
