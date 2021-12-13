;输出三位以下(包三位)的数字
;coding:gbk
assume cs:code,ds:data,ss:stack
stack segment
    dw 8 dup (?)
stack ends
data segment
    buf1 db 'The n is (d):','$'
    buf2 db 'The sum is (d):','$'
    n dw ?
    sum dw ?

data ends
code segment
start:      mov ax,data
            mov ds,ax

            mov ax,stack
            mov ss,ax
            mov sp,10h


            mov dx,0
            mov ax,528      ;这里填你想输出的数字
            call stackdiv16    

    over0:  mov ax,4c00h
            int 21h

stackdiv16 proc far
              push bx
              push dx
              push si
              mov si,0
              
cricle1:      mov bx,10
              div bx

              cmp ax,0
              jbe  next1     ;商比0小就退出，代表数据全部处理完毕
              
              push dx
              inc si
              mov dx,0

              jmp cricle1

next1:        push dx
              inc si
next2:        cmp si,0
              jbe next3         ;如果计数器小于0，则结束

              pop bx
              dec si
              mov ah,2
              mov dl,bl
              add dl,30h
              int 21h

              jmp next2
             
next3:        ;call CR2          ;回车和换行
              
              
              pop si     
              pop dx       
              pop bx
              ret

CR2  proc far    
                mov ah,2
                mov dl,0ah
                int 21h   
                mov ah,2
                mov dl,0dh
                int 21h
                ret
CR2 endp

stackdiv16 endp
code ends
end start