;coding:GBK

assume cs:code,ds:data
data segment
    mess1 db 'Input x:','$'
    mess2 db 0ah,0dh,'Output y:','$'
data ends

code segment
start:  mov ax,data
        mov ds,ax
        mov dx,offset mess1
        mov ah,9
        int 21h

        mov dx,offset mess2
        mov ah,9
        int 21h 
        mov ax,4c00h
        int 21h 

code ends
end start