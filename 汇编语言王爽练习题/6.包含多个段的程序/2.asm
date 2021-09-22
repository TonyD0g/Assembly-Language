;下面的程序实现依次用内存0:0 ~ 0:15单元中的内容改写程序中的数据

assume cs:codesg
codesg segment
    dw  0123h,0456h,0789h,0abch,0defh,0fedh,0cbah,0987h  ;定义了8个字形数据
    ;   我们在描述dw的作用时，可以说用它定义数据，也可以说用它开辟内存空间
start:  mov ax,0
        mov ds,ax 
        mov bx,0
        
        mov cx,0
    s:  mov ax,[bx]
        mov cs:[dx],ax
        add bx,2
        loop s

        mov ax,4c00h
        int 21h
codesg ends 
end start   ;指明了程序的入口在标号start处