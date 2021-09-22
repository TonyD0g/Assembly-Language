;编译连接下列汇编源程序，用debug观察一下，看看发现了什么问题
assume cs:code
code segment 
    dw 0123h,0456h,0789h,0abch,0defh,0fedh,0cbah,0987h  ;定义了8个字形数据

    mov bx,0
    mov ax,0

    mov cx,0

s:  add ax,cs:[bx]
    add bx,2
    loop s

    mov ax,4c00h
    int 21h

code ends
end 

;可以发现，前面并没有看到程序中的指令，而是dw定义的数据.
;在此程序中，前面有一个代码段，字节长为16.所以16字节开始才是汇编指令所对应的机器码
;因此要想执行汇编指令，必须让ip指向10H,然后才能使用t命令，p命令，或者其他命令

;这样一来，每次都要用Debug来执行程序，为了避免这样的麻烦，下面引用分段的概念