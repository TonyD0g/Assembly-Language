;1.将下面的程序保存为2.asm 文件，将其生成可执行文件2.exe
;2.用debug加载2.exe ,查看PSP的内容。（PSP的头两个字节是CD 20)
;2的解法：将cs - 10H 并视为S ，并用u命令查看 段地址为S，偏移地址为0000H 即可
assume cs:codesg

codesg segment
    mov ax,2000h
    mov ss,ax
    mov sp,0 
    add sp,10 
    pop ax 
    pop bx
    push ax 
    push bx 

    mov ax,4c00h
    int 21h

codesg ends

end 