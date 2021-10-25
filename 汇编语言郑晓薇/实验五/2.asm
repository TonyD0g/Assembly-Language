;coding:GBK
;要求：（1）用9号功能显示一串字符，如”INPUT  YOUR NAME:” 
;（2）在串的尾部输入你的英文名字，至少3个字符，按回车键后，
;（3）在下一行，重新显示你输入的名字，
;（4）名字后面，继续显示串“(y/n)?”
;（5） 输入为字母”y”结束程序，输入字母”n”回到（1）重新输入。

assume cs:code,ds:data
data segment
   x db 'INPUT  YOUR NAME:','$'
   y db 10,?,4 dup (0ah,'$')
data ends
code segment
start:      mov ax,data
            mov ds,ax
            mov dx,0
            mov ah,9    ;功能9，输出一个字符串
            int 21h


            mov ah,10   ;功能10，输入一个字符串
            mov dx,offset y
            int 21h

            mov dx,offset y+2       ;mov dx,0014
            mov ah,9    ;功能9，输出一个字符串
            int 21h

            ;mov ah,2
           ; mov dl,0ah
            ;int 21h   

            ;mov ah,2
            ;mov dl,20h
            ;int 21h

            ;mov ah,2
            ;mov dl,'$'
           ; int 21h   
      

            mov ax,4c00h
            int 21h
code ends   
end start