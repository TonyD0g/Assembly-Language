;计算ffff:0 ~ ffff:b 单元中的数据的和，结果存储在dx中.
; 我自己写的：（经测试暂时没有发现问题)
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

;书上的原程序：

;assume cs:code
;code segment
;   mov ax,0ffffh
;   mov ds,ax
;   mov bx,0
;   mov dx,0
;   mov cx,12

;s: mov al,[bx]
;   mov ah,0
;   add dx,ax
;   inc bx
;   loop s

;   mov ax,4c00h
;   int 21h
;code ends
;end