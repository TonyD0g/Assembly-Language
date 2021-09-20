;下面是一段简单的汇编语言源程序

;codesg segment     ;定义一个段，段的名称叫做"codesg"
;... ...
;codesg ends        ;名称为"codesg"的段到此结束


assume cs:codesg
codesg segment  ;"codesg"为标号,一个标号指代了一个地址，这个段最终被编译，连接程序处理为一个段的段地址
    mov ax,0123h
    mov bx,0456h
    add ax,bx
    add ax,ax 

    mov ax,4c00h    ;程序返回（必备）
    int 21h         ;程序返回(必备）

codesg ends

end 
