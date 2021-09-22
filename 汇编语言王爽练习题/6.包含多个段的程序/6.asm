;1.程序返回前，data段中的数据为多少?
;2.程序返回前,cs=?  ss=?    ds=?
;3.设程序加载后，code段的段地址为X ,则data段的段地址为? stack段的段地址为?

;和上一题类似
assume cs:code,ds:data,ss:stack
data segment
    dw  0123h,0456h ;4字节
data ends

stack segment
    dw 0,0  ;16字节
stack ends

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
end start
