;在编程中需要注意何处是数据，何处是栈，何处是代码，这样做会带来以下问题:
;1.把它们放到一个段中使程序显得混乱
;2.如果数据，栈和代码需要的空间超过64KB,就不能放在一个段中
;(64KB是8086 模式的限制)
;所以我们将数据，栈和代码放到不同的段中

assume cs:codesg,ds:data,ss:stack
data segment
    dw  0123h,0456h,0789h,0abch,0defh,0fedh,0cbah,0987h
data ends

stack segment
    dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0  ;32字节
stack ends

codesg segment
start:  mov ax,stack
        mov ss,ax
        mov sp,20h

        mov ax,data
        mov ds,ax

        mov bx,0
        mov cx,8
    
s:      push [bx]
        add bx,2
        loop s

        mov bx,0
        mov cx,8

s0:     pop [bx]
        add bx,2
        loop s0

        mov ax,4c00h
        int 21h

codesg ends
end start