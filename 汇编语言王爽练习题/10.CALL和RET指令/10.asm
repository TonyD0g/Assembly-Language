;批量数据的传递:
;当子程序需要传递的数据有很多个时，可以将批量的数据放到内存中，然后将它们所在的内存
;空间的首地址放在寄存器中，传递给需要的子程序。对于具有批量数据的返回结果，也可以用同样的方法

;注意：除了用寄存器传递参数外，还有一种通用的方法是用栈来传递参数

;设计一个程序，功能：将一个全是字母的字符串转换为大写.
assume cs:code
data segment
    db 'conversation'
data ends

code segment
start:  mov ax,data
        mov dx,ax
        mov si,0
        mov cx,12
        call capital

        mov ax,4c00h
        int 21h

capital:and byte ptr [si],11011111b
        inc si
        loop capital
        ret
        
code ends
end start