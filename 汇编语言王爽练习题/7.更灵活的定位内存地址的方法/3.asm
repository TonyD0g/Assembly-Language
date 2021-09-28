;针对2.asm 的算法，可用[bx+idata]的方式进行算法改良

assume cs:codesg,ds:datasg
datasg segment
    db 'BaSiC'
    db 'iNfOrMaTiOn'
datasg ends

codesg segment
start:  mov ax,datasg
        mov ds,ax
        mov bx,0
        mov cx,5    ;设置循环次数为5,因为'BaSiC'中有5个字母

    s:mov al,0[bx]
      and al,11011111B  ;将第五位设置为0，变为大写字母

      mov 0[bx],al
      mov al,5[bx]
      or al,00100000B   ;将第五位设置为1，变为小写字母
      mov 5[bx],al 
      inc bx
      loop s


      mov ax,4c00h
      int 21h
    
codesg ends
end start