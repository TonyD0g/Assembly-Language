;设W、X、Y、Z均为8位带符号数，要求完成计算表达式W=X+Y-Z。
assume cs:code,ds:data
data segment
    x db 5          
    y db 2
    z db 3
    w db ?
data ends
code segment
start:  mov ax,data
        mov ds,ax
        mov al,x    
        add al,y 
        sub al,z
        mov ds:[w],al

        mov ah,2
        mov DL,ds:byte ptr[w]
        add dl,30h
        int 21h
        
        mov ax,4c00h
        int 21h

code ends
end start