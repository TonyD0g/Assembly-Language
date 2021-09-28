;jcxz指令
;补全编程，利用jcxz指令，实现在内存2000H段中查找第一个值为0的字节，找到后,
;将它的偏移地址存储在dx中 

assume cs:code
code segment
start:mov ax,2000H
      mov ds,ax
      mov ds:[0],0020H
      mov bx,0
    s:mov cx,ds:[bx]
      inc bx
      jcxz ok   
      jmp short s
   ok:mov dx,bx

      mov ax,4c00h
      int 21h
code ends
end start