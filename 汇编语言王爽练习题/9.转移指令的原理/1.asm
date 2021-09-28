;下面的程序段，将使该程序在运行中将S处的一条指令复制到S0处

assume cs:codesg
codesg segment
start: s:   mov ax,bx
            mov si,offset s
            mov di,offset s0
            mov ax,cs:[si]
            mov cs:[di],ax
       s0:  nop          ;nop机器码只占一个字节
            nop

       mov ax,4c00h
       int 21h  
codesg ends
end start