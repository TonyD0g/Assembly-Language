;程序如下，编写code段中的代码，将a段和b段中的数据依次相加，将结果存在c段中

assume cs:code
a segment
    db 1,2,3,4,5,6,7,8  ;每个相邻的段之间都间隔16个字节
a ends

b segment
    db 1,2,3,4,5,6,7,8
b ends

d segment
    db 8 dup (0)
d ends

code segment
start:  mov ax,a
        mov ds,ax
        mov si,16
        ;mov di,8

        mov cx,8
        mov bx,0
    s:  mov dx,ds:[bx]
        mov ax,ds:[bx+si]
        add ax,dx
        mov ds:[bx+si+16],ax
        inc bx
        loop s

        mov ax,4c00h
        int 21h

code ends

end start

;另外一种写法：
; mov ax,a
;        mov ds,ax
        
;       mov ax,b
;        mov es,ax
        
;        mov bx,0
;        mov cx,8
        
;   s:   mov al,ds:[bx]
;       mov dl,es:[bx]
;       add dl,al
;        mov es:[bx+16],dl
;        inc bx
;        loop s

;        mov ax,4c00h
;        int 21h