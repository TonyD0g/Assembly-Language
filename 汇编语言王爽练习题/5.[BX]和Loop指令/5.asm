; 将内存ffff:0 ~ffff:b 单元中的数据复制到0:200 ~ 0:20b 单元中
;改进方案：（利用es段寄存器，避免重复设置ds）

assume cs:codesg
codesg segment
    mov ax,0ffffh
    mov ds,ax 
    mov ax,0020h
    mov es,ax 
    mov bx,0
    mov cx,12

s:  mov dl,[bx]
    mov es:[bx],dl
    inc bx
    loop s

    mov ax,4c00h
    int 21h
codesg ends
end 