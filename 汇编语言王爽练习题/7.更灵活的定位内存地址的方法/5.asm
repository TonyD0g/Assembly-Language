;编程，将datasg段中的每个单词的头一个字母改为大写字母

assume cs:codesg,ds:datasg
datasg segment
    db '1.file          '
    db '2.edit          '
    db '3.search        '
    db '4.view          '
    db '5.options       '
    db '6.help          '
datasg ends

codesg segment
start:mov ax,datasg
      mov ds,ax
      mov bx,2
      mov cx,6

    s:mov al,ds:[bx]
      and al,11011111B
      mov ds:[bx],al
      add bx,0010H
      loop s
      
      mov ax,4c00H
      int 21h
    
codesg ends
end start