;因6.asm 知，程序中经常需要数据的暂存，可是寄存器的数量又有限
;可以考虑内存空间的使用，但是内存空间使用需要你记住数据放在了哪个单元中,这样容易显得程序混乱
;所以一般来说，在需要暂存数据的时候，我们应该使用栈来实现

;6.asm程序改良：

assume cs:codesg,ds:datasg,ss:stack
datasg segment
    db 'ibm             '
    db 'dec             '
    db 'dos             '
    db 'vax             '
datasg ends

stack segment
    dw 8 dup(0)
stack ends

codesg segment
  
start:mov ax,datasg
      mov ds,ax
      mov ax,stack
      mov ss,ax
      mov sp,0010H

      mov bx,0
      mov cx,4


    s:
      push cx    ;将cx压栈
      mov cx,3      ;设置内循环次数
      mov di,0

   s0:mov al,ds:[bx+di]
      and al,11011111B
      mov ds:[bx+di],al
      inc di
      loop s0

      add bx,0010H    ;相当于换下一个数组
      pop cx       ;将cx弹栈
      loop s

      mov ax,4c00h
      int 21h  


        mov ax,4c00h
        int 21h
codesg ends
end start
