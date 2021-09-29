; 计算data段中第一组数据的3次方，结果保存在后面一组dword单元中

;这里有两个问题：1.将参数存储在什么地方 2.计算得到的数值，存储在什么地方?

;很显然，可以用寄存器来存储，可以将参数放到bx中 ,因为子程序中要计算 N*N*N ,可以使用多个mul指令
assume cs:code
data segment
    dw 1,2,3,4,5,6,7,8
    dd 0,0,0,0,0,0,0,0
data ends

code segment

start:  mov ax,data
        mov ds,ax
        mov si,0        ;ds:si 指向第一组word单元
        mov di,16       ;ds:di 指向第二组dword单元
        
        mov cx,8
      s:mov bx,[si]
        call cube
        mov [di],ax
        mov [di].2,dx   
        add si,2        ;ds:si 指向下一个word单元
        add di,4        ;ds:di 指向下一个dword单元
        loop s 

        mov ax,4c00h
        int 21h

   cube:mov ax,bx
        mul bx
        mul bx
        ret

code ends
end start

