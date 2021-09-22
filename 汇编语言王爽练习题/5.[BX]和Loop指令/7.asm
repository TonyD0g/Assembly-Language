;下面的程序的功能是将mov ax,4c00h 之前的指令复制到内存 0:200 处，补全程序，上机调试，跟踪运行结果
;问题:
;1.复制的是什么，从哪里到哪里
;2.复制的是什么？有多少个字节？你如何知道要复制的字节的数量

;你如何知道要复制的字节的数量:手动数,(验证对不对： 在debug模式下使用u 命令 即可查看汇编指令的十六进制表示)
assume cs:code
code segment
    mov ax,cs ;2（字节） 
    mov ds,ax ;2
    mov ax,0020h ;3
    mov es,ax ;2
    mov bx,0  ;3
    mov cx,23   ;3          在mov ax,4c00h 指令前的汇编指令所占的字节数为23，所以设cx为23

s:  mov al,[bx] ;2
    mov es:[bx],al  ;3
    inc bx ;1
    loop s ;2

    mov ax,4c00h 
    int 21h
code ends
end