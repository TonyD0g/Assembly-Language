;计算ffff:0 ~ ffff:b 单元中的数据的和，结果存储在dx中.

assume cs:codesg
codesg segment
    mov cx,3
    mov bx,0
    mov ax,0ffffh
    mov ds,ax 
    mov dx,0
    

s:  
    add dx,[bx] 
    inc bx
    loop s

    mov ax,4c00h
    int 21h

codesg ends
end 