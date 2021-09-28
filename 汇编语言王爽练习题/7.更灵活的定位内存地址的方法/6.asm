;编程，将datasg段中每个单词改为大写单词

;双层循环,类似于C语言中的双层for循环
assume cs:codesg,ds:datasg
datasg segment
    db 'ibm             '
    db 'dec             '
    db 'dos             '
    db 'vax             '
datasg ends

codesg segment

start:mov ax,datasg
      mov ds,ax
      mov bx,0
      mov cx,4


    s:mov si,cx     ;将外层循环的cx值保存在dx中
      mov cx,3      ;设置内循环次数
      mov di,0

   s0:mov al,ds:[bx+di]
      and al,11011111B
      mov ds:[bx+di],al
      inc di
      loop s0

      add bx,0010H    ;相当于换下一个数组
      mov cx,si       ;恢复用于外层循环计数的cx
      loop s

      mov ax,4c00h
      int 21h

codesg ends

end start

