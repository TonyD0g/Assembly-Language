;下面的程序实现依次用内存0:0 ~ 0:15单元中的内容改写程序中的数据
;只不过这次使用栈来实现，栈空间设置在程序内

assume cs:codesg
codesg segment
        dw  0123h,0456h,0789h,0abch,0defh,0fedh,0cbah,0987h
        dw  0,0,0,0,0,0,0,0,0,0 ;16+20 = 36 = 24H

start:  mov ax,cs
        mov ss,ax
        mov sp,24h 

        mov ax,0
        mov ds,ax
        mov bx,0
        mov cx,8

    s:  push [bx]
        pop cs:[dx]
        add bx,2
        loop s

        mov ax,4c00h
        int 21h
codesg ends
end start
