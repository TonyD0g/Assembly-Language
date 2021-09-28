;大小写转换:
;大写       十六进制        二进制    
; A           41           0100 0001                     

;小写       十六进制        二进制 
; a           61           0110 0001

;发现：二进制中第五位有1则为小写字母
;所以可用and 和 or指令实现大小写转换

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

    s:mov al,[bx]       ;对al进行与运算，不对ax进行，对ax进行与运算会影响下一个字符
      and al,11011111B  ;将第五位设置为0，变为大写字母

      mov [bx],al
      inc bx
      loop s

      mov bx,5          ;使ds:bx 指向'iNfOrMaTiOn'的第一个字母
      mov cx,11         ;设置循环次数为5,因为'iNfOrMaTiOn'中有11个字母

   s0:mov al,[bx]
      or al,00100000B   ;将第五位设置为1，变为小写字母
      mov [bx],al
      inc bx
      loop s0

      mov ax,4c00h
      int 21h
    
codesg ends
end start
       

