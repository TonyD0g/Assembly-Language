;输入一行字符，分别统计出其中英文字母,
;数字和其他字符的个数，并显示各种统计结果.



;英文字母:41H~5AH(大写字母)   61H~7AH(小写字母) , 数字:30H~39H , 和其他

assume cs:code,ds:data
data segment
    buf1 db 9,?,7 dup (?)   ;可以输入5个字符
data ends

code segment
start:      mov ax,data
            mov ds,ax

            mov ah,1
            int 21h

            cmp al,61h
            jae letterXX1 

next1:      cmp al,41h     
            jae letterDX1

next2:      cmp al,30h
            jae number1
    
next3:      jmp start

number1:    cmp al,39h
            jbe number2
            jmp next3   

number2:    mov ah,2
            mov dl,'n'          ;代表输出数字
            int 21h
            jmp start

letterDX1:  cmp al,5ah
            jbe letterDX2
            jmp next2

letterDX2:   mov ah,2
            mov dl,'d'           ;代表输出大写
            int 21h
            jmp start            ;后面要改为over1

letterXX1:   cmp al,7ah
            jbe letterXX2
            jmp next1

letterXX2:   mov ah,2
            mov dl,'x'          ;输出x，说明是小写字母
            int 21h
            jmp start           ;后面要改为over1

over1:      mov ax,4c00h
            int 21h
code ends
end start