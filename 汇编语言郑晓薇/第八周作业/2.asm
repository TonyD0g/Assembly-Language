;编写计算下面函数值的程序:
;(一种投机取巧的做法)
;X的值在 -128 ~ 127之间
;   1   x>0时
;y= 0   x=0时
;  -1   x<0时

;设输入数据为x
;输出数据y
;且皆为字节变量.

assume cs:code,ds:data
data segment
    x db 'x=','$'
    y db 'y=','$'
    buf db 10,?,6 dup ('$')
    notice db 'x:-999 ~ 999','$'
data ends

code segment
start:      mov ax,data             ;(未完工:先进行符号的判断,如果是负号,则再检测下一位，下一位是0则输出y=0.)
            mov ds,ax               ;(如果是正号,则再检测下一位，下一位是0则输出y=0.)
            mov ah,9
            mov dx,offset notice
            int 21h
            call cr
            
            call x1   ;x=           ;(如果不是0,则输出y=1或y=-1)

            mov ah,0ah    ;输入x
            mov dx,offset buf
            int 21h
            call CR1
            call cr

            call y1
              

            cmp ds:byte ptr [buf+2],'+'
            jz option1  ;为正数
            jnz option2 ;为负数,或其他奇奇怪怪的数据

            

            

       over:mov ax,4c00h
            int 21h
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    option1:cmp ds:byte ptr [buf+3],30h
            jz s1    ;如果为x=0,则输出y=0,
            jnz s0   ;否则输出y=1
            
    option2:cmp ds:byte ptr [buf+3],30h
            jz s1    ;如果为x=0,则输出y=0,
            
            cmp ds:byte ptr [buf+2],'-'   ;如果为负数，则输出y=-1
            jz s2

            xor dl,dl
            cmp ds:byte ptr [buf+3],30h   ;如果为正数，则输出y=1   
            jnz s0            

         s0:mov ah,2          
            mov dl,'1'           ;输出1
            int 21h
            call cr
            jmp start

         s1:mov ah,2             ;输出2
            mov dl,'0'
            int 21h
            call cr
            jmp start

        s2:mov ah,2
           mov dl,'-'
           int 21h
           mov ah,2
           mov dl,'1'
           int 21h
           call cr
           jmp start

        cr:mov ah,2             ;输出回车
           mov dl,0ah
           int 21h
           ret  

      CR1:  mov bx,offset buf                     ;将输入字符串中的回车删除
            inc bx
            add bl,ds:byte ptr [bx]
            inc bx
            mov ds:[bx],'$'
            ret

        x1:mov ah,9            ;输出x=
           mov dx,offset x 
           int 21h
           ret

        y1:mov ah,9            ;输出y=
           mov dx,offset y 
           int 21h 
           ret

        


code ends
end start

