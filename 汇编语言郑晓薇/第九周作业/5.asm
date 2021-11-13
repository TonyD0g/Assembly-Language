;coding:gbk
;实验五，分支程序设计的第五题：
;题目:
;在内存中以buf单元开始缓冲区中连续存放着10个
;学生的分数，试编制程序统计其中90~100分，80~89分，60~79分
;及60分以下者各有多少人，并把结果分别存放
;在S9,S8,S7和S6中，并显示各段人数

assume cs:code,ds:data
data segment
    buf db 14,?,12 dup ('$')
    buf1 db 'Please input the num','$'
data ends
code segment
start:      mov ax,data
            mov ds,ax

            mov ah,9
            mov dx,offset buf1
            int 21h
            call CR1

            mov ah,10   ;功能10，输入your name
            mov dx,offset buf+2
            int 21h
            call CR
            
            call CR1
            
            mov ax,4c00h
            int 21h

      CR:   mov bx,offset buf                     ;将输入字符串中的回车删除
            inc bx
            add bl,ds:byte ptr [bx]
            inc bx
            mov ds:byte ptr [bx],'$'
            ret

    CR1:    mov ah,2
            mov dl,0ah
            int 21h
            ret

    CR2:    mov ah,2
            mov dl,0ah
            int 21h   
            mov ah,2
            mov dl,0dh
            int 21h
            ret


code ends
end start