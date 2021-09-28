;我们在汇编程序中，可用 '...' 的方式指明数据是以字符的形式给出的，编译器将它们转换
;为相对应的ASCII码

;使用Debug查看ASCII

assume cs:code,ds:data
data segment
    db 'unIX'   ;相当于 db 75H,6EH,49H,68H
    db 'foRK'
data ends

code segment
start:  mov al,'a'  ;相当于 mov al,61H
        mov bl,'b'  ;相当于 mov al,62H

        mov ax,4c00h
        int 21h
code ends
end start