;输入一行字符，分别统计出其中英文字母,
;数字和其他字符的个数，并显示各种统计结果.

;英文字母:41H~5AH(大写字母)   61H~7AH(小写字母) , 数字:30H~39H , 和其他

assume cs:code,ds:data 
data segment
    buf1 db 13,?,11 dup ('$')   ;最多可以输入9个字符
    buf2 db 'Please input the string,it allow max num is 9!','$'
    buf3 db 'The num have :','$'
    buf4 db 'The Dx have :','$'
    buf5 db 'The Xx have :','$'
    buf6 db 'The Other have :','$'
    Num db ?        ;数字
    Ldx db ?        ;大写
    Lxx db ?        ;小写
    Other db ?      ;其他
data ends

code segment
start:      mov ax,data
            mov ds,ax

            mov ah,9
            mov dx,offset buf2          ;输出Please input the string!
            int 21h
            call CR2

            mov ah,0ah                  ;输入一行字符
            mov dx,offset buf1
            int 21h         
            call CR2

            mov cx,0
            mov si,2

Gainthecx:  mov bl,ds:byte ptr [buf1+si]        ;该模块用于求输入的字符串长度
            cmp bl,'$'                          ;字符串长度赋值给cx
            jz letsgo
            inc cx
            inc si
            jmp Gainthecx

letsgo:                               ;开始主循环
            mov si,0
            mov bx,offset buf1+2
cricle:     
            mov al,ds:byte ptr [bx+si]       
            cmp al,61h
            jae letterXX1 

next1:      cmp al,41h     
            jae letterDX1

next2:      cmp al,30h
            jae number1

next4:      add ds:byte ptr [Other],1            

next3:      inc si
            loop cricle
            jmp over1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      

number1:    cmp al,39h
            jbe number2
            jmp next4   

number2:    
            
            add ds:byte ptr [Num],1
            jmp next3

letterDX1:  cmp al,5ah
            jbe letterDX2
            jmp next2

letterDX2:  
            
            add ds:byte ptr [Ldx],1
            jmp next3            ;后面要改为over1

letterXX1:  cmp al,7ah
            jbe letterXX2
            jmp next1

letterXX2:  
            
            add ds:byte ptr [Lxx],1
            jmp next3           ;后面要改为over1



            

over1:      call output1
            mov ax,4c00h
            int 21h

output1:    
            mov ah,9
            mov dx,offset buf3
            int 21h
            mov ah,2
            mov dl,ds:byte ptr [Num]
            add dl,30h
            int 21h
            call CR2

            mov ah,9
            mov dx,offset buf4
            int 21h
            mov ah,2
            mov ah,2
            mov dl,ds:byte ptr [Ldx]
            add dl,30h
            int 21h
            call CR2            

            mov ah,9
            mov dx,offset buf5
            int 21h
            mov ah,2
            mov ah,2
            mov dl,ds:byte ptr [Lxx]
            add dl,30h
            int 21h
            call CR2

            mov ah,9
            mov dx,offset buf6
            int 21h
            mov ah,2
            mov ah,2
            mov dl,ds:byte ptr [Other]
            add dl,30h
            sub dl,1
            int 21h
            call CR2            
            ret

CR2:        mov ah,2
            mov dl,0ah
            int 21h   
            mov ah,2
            mov dl,0dh
            int 21h
            ret



code ends
end start