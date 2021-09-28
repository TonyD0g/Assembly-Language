;si和di是8086CPU中和bx功能相近的寄存器,si和di不能够分成两个8位寄存器来使用

;用si和di实现将字符串'welcome to masm!' 复制到它后面的数据区中

assume cs:codesg,ds:datasg
datasg segment
    db 'welcome to masm!' ;16字节
datasg ends

codesg segment
start:mov ax,datasg
      mov ds,ax
      mov bx,0
      mov cx,8
      mov si,0010H

    s:mov ax,ds:[bx]
      mov ds:[bx+si],ax
      add bx,2
      loop s
    
      mov ax,4c00h
      int 21h

codesg ends
end start