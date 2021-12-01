;设数据区有两个字节串，串1的长度为5,串2的长度为10
;编程：
;若串2的最后5个字符和串1相同，则置flag单元为"Y",否则置为"N"
;(要求用串比较指令完成)

assume cs:code,ds:data,es:data
data segment
    buf1 db 'word!'
    buf2 db 'helloword!'
    ;buf3 db 'The output is: ','$'
    flag db '0','$'
data ends

code segment
start:      mov ax,data
            mov ds,ax
            mov es,ax
            cld         ;顺时针
            mov si,offset buf1          ;ds:si
            
            mov di,offset buf2          ;es:di
            add di,5
            mov cx,5
            repe cmpsb
            jz let1             ;全相等就退出
            mov dl,'n'
            jmp print1

let1:       mov dl,'y'
            mov ds:byte ptr [flag],dl
            jmp print2
print1:      
            mov ds:byte ptr [flag],dl
print2:     mov ah,2
            int 21h

over1:      mov ax,4c00h
            int 21h

    CR2:    mov ah,2
            mov dl,0ah
            int 21h   
            mov ah,2
            mov dl,0dh
            int 21h
            ret
code ends
end start
