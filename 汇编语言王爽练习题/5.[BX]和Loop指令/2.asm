;计算 ffff:0006单元中的数乘以3 ，结果存储在dx中

;应考虑的问题：
;1.运算后的结果是否会超出dx所能存储的范围？
;   ffff:0006单元中的数是一个字节型的数据，范围在0~255之间，则用它和3相乘，结果不会大于65535,所以可以在dx中存放

;2.用循环累加来实现乘法，用哪个寄存器进行累加？
;   将ffff:0006单元中的数复制给ax，用dx进行累加.先设(dx)=0，然后做3次 (dx)=(dx)+(ax)

;3.ffff:6单元是一个字节单元，ax是一个16位寄存器，数据的长度不一样，如何赋值？
;设ffff:0006 单元中的数据是00xxH,所以若实现ffff:0006 单元向ax赋值，应该令(ax)=0,(al)=(06H)





assume cs:codesg
codesg segment
    mov ax,0ffffh ;汇编语言源程序，数据不能以字母为开头 
    mov ds,ax 
    mov bx,0006h
    mov dx,0
    mov al,[bx]
    mov ah,0 
    mov cx,3 

s:add dx,ax 
    loop s 

    mov ax,4c00h 
    int 21h 

codesg ends 

end