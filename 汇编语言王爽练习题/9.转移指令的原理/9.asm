;利用Loop指令，实现在内存2000H段中查找第一个值为0的字节，
;找到后，将它的偏移地址存储在dx中

assume cs:code
code segment
start:mov ax,2000H
      mov ds,ax
      mov ds:[0],0020H
      mov bx,0 
    s:mov cl,[bx]
      mov ch,0
      inc bx
      jcxz ok 
      loop s
   ok:dec bx    ;dec指令的功能和inc相反，dec bx 进行的操作为:   (bx)=(bx)-1
      mov dx,bx
      

      mov ax,4c00h
      int 21h
code ends
end start