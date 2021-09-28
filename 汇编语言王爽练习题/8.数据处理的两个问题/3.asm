;伪指令dd
;前面我们用db 和dw 定义字节型数据和字形数据，dd 是用来定义dword(double word)型数据的

;用div计算data段中的第一个数据除以第二个数据后的结果,商存在第三个数据的存储单元中

assume cs:codesg,ds:datasg
datasg segment
    dd 100001   ;186a1
    dw 100
    dw 0
datasg ends

codesg segment
start:  
        mov ax,datasg
        mov ds,ax

        mov dx,ds:[2]   ;将186a1中的 最高位放入dx
        mov ax,ds:[0]   ;将186a1中的 86a1放入ax
        mov bx,ds:[4]
        div word ptr ds:[4]

        mov ds:[6],ax

        mov ax,4c00h
        int 21h

codesg ends
end start