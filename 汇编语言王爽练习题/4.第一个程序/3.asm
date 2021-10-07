assume cs:code,ds:data
data segment
    x db 5
    y db 3
data ends

code segment
start:  mov ax,data
        mov ds,ax
        mov al,x
        add al,y
        mov ah,2
        mov dl,al
        mov ax,4c00h
        int 21h
code ends
end start