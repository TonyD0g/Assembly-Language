; 将内存ffff:0 ~ffff:b 单元中的数据复制到0:200 ~ 0:20b 单元中

assume cs:codesg
codesg segment
    mov bx,0
    mov cx,12

s:  mov ax,0ffffh 
    mov ds,ax 
    mov dl,[bx]

    mov ax,0020H
    mov ds,ax 
    mov [bx],dl 

    inc bx 
    loop s 

    mov ax,4c00h 
    int 21h 

codesg ends
end 
