;寄存器冲突的问题：

;设计一个子程序，将一个全是字母，以0结尾的字符串，转换为大写

;程序要处理的字符串以0作为结尾符，这个字符串可以如下定义:
; db 'conversation',0

;应用这个子程序，字符串的内容后面一定要有一个 0 ，标记字符串的结束.
;子程序可以依次读取每个字符进行检测，如果不是0 ，就进行大写的转化.如果是0 ，就结束处理
;由于可通过检测0而知道是否已经处理完毕整个字符串.
;所以子程序可以不需要字符串的长度作为参数,可以用jcxz来检测0

assume cs:code
data segment
    db 'conversation'
data ends

code segment
start:  mov ax,data
        mov dx,ax
        mov bx,0

        mov cx,4
      s:mov si,bx
        call capital
        add bx,5
        loop s

        mov ax,4c00h
        int 21h

capital:push cx     ;用之前保存起来
        push si

 change:mov cl,[si]
        mov ch,0
        jcxz 0k
        and byte ptr [si],11011111b
        inc si
        jmp short change

     ok:pop si      ;恢复先前的数据
        pop cx
        ret
        
code ends
end start

