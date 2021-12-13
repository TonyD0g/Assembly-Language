;编写计算下面函数值的程序:
;X的值在 -128 ~ 127之间
;   1   x>0时
;y= 0   x=0时                   ;>=0为分界，
;  -1   x<0时

;设输入数据为x
;输出数据y
;且皆为字节变量.

assume cs:code,ds:data
data segment
    x db -11
    y db ?
data ends

code segment
start:  mov ax,data
        mov ds,ax
        cmp ds:[x],0
        jns s1              ;大于等于

    s2:           ;小于0(求补)
        mov ah,2 
        mov dl,'<'
        int 21h
        jmp endline

    s1: 
        cmp ds:[x],0        ;大于等于0
        jz s3               ;如果等于0，则跳转
        mov ah,2            
        mov dl,'>'
        int 21h
        jmp endline

    s3: 
        mov ah,2        ;等于0就输出0
        mov dl,'0'
        int 21h
        jmp endline

    endline: mov ax,4c00h
             int 21h

code ends
end start
