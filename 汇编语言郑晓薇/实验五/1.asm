;不断输入小写字符，将输入的小写字符转换为大写字母如果输入的是ESC控制字符，则停止
assume cs:code
code segment
start:  mov ah,1
        int 21h ;功能1，输入

        cmp al,1bH
        je exit

        add al,32

        mov ah,2
        mov dl,al
        int 21h     ;功能2,输出

        cmp al,27
        jne start
    

exit:   mov ax,4c00h
        int 21h

code ends
end start