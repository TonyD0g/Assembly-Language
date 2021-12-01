;coding:GBK
;要求：（1）用9号功能显示一串字符，如”INPUT  YOUR NAME:” 
;（2）在串的尾部输入你的英文名字，至少3个字符，按回车键后，
;（3）在下一行，重新显示你输入的名字，
;（4）名字后面，继续显示串“(y/n)?”
;（5） 输入为字母”y”结束程序，输入字母”n”回到（1）重新输入。

assume cs:code,ds:data
data segment                     ;0a:换行 , 0d:回车,回到这一行的顶头
   x db 'INPUT  YOUR NAME:','$'
   y db 10,?,8 dup ('$')         ;只能输入6个字符,因为要减去0dh和$(内存中显示为: 0dh '$') 8-2 = 6
   z db '?(y/n)','$'
data ends
code segment
start:      mov ax,data
            mov ds,ax
            
         s0:mov ah,9    ;功能9，输出一个字符串:INPUT  YOUR NAME:
            mov dx,0 
            int 21h

            mov bx,0

            mov ah,10   ;功能10，输入your name
            mov dx,offset y
            int 21h

            call CR



            mov ah,2
            mov dl,0ah
            int 21h   

            mov ah,2
            mov dl,0dh
            int 21h

            mov ah,9    ;功能9，输出your name
            mov dx,offset y+2       
            int 21h

            call CR

            mov ah,9    ;功能9，输出一个字符串:?(y/n)
            mov dx,offset z       
            int 21h

            mov ah,1
            int 21h

            cmp al,79h
            call CR1

            jnz s0
      
            mov ax,4c00h
            int 21h

      CR:   mov bx,offset y                     ;将输入字符串中的回车删除
            inc bx
            add bl,ds:byte ptr [bx]
            inc bx
            mov ds:[bx],'$'
            ret

      CR1:  mov ah,2                            ;换行
            mov dl,0ah
            int 21h
            ret

code ends   
end start