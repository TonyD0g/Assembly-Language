;1.编程计算2^3 ,结果存在ax中

assume cs:codesg
codesg segment
    mov ax,2
    add ax,ax 
    add ax,ax
    mov ax,4c00h
    int 21h
codesg ends

end 

;2.利用loop指令实现 2^10 ,结果存放在ax中

;assume cs:codesg
;codesg segment
;   mov cx,9
;   mov ax,2
;s: add ax,ax
;   loop s

;   mov ax,4c00h
;   int 21h
;codesg ends
;end