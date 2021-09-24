;将下面的程序编译，连接，用debug加载，跟踪，然后回答问题
;cpu执行程序，程序返回前,cs=?   ss=?    ds=?
;设程序加载后，code段的段地址为x,则data段的段地址为?    stack段的段地址为？

assume cs:code,ds:data,ss:stack
code segment
start:  mov ax,stack
        mov ss,ax
        mov sp,16

        mov ax,data
        mov ds,ax

        push ds:[0]
        push ds:[2]
        pop ds:[2]
        pop ds:[0]

        mov ax,4c00h
        int 21h
code ends

data segment
    dw  0123h,0456h ;4字节
data ends

stack segment
    dw 0,0  ;16字节
stack ends

end start

