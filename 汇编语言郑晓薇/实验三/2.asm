;设W、X、Y、Z均为8位带符号数，要求完成计算表达式W=X+Y-Z。
;如果运算结果大于等于10，显示的结果正确吗？如何解决
;(此程序是对两位十进制数进行处理)
; 12/10 = 1,         12 mod 10 = 2
;商                         余    


assume cs:code,ds:data
data segment
    x db 7          
    y db 8
    z db 3
    w db ?      ;w=x+y-z
    k db 10
data ends
code segment
start:  mov ax,data
        mov ds,ax
        mov al,x    
        add al,y 
        sub al,z
        mov ds:[w],al

        mov al,ds:byte ptr [w]
        mov ah,00H
        div ds:byte ptr [k]         ;ah存余数，al存商数

        mov bl,al
        mov bh,ah
        mov ah,2
        mov dl,bl
        add dl,30h
        int 21h             ;执行完后，al的值等于dl的值


        mov ah,2 
        mov dl,bh
        add dl,30h   
        int 21h             ;执行完后，al的值等于dl的值

        mov ax,4c00h
        int 21h

code ends
end start