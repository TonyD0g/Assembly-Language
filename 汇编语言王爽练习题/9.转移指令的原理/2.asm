;依据位移进行转移的jmp指令
;段内短转移:    "jmp short 标号" 对IP的修改范围是-128~127(IP=IP+8位位移)
;段内近转移:    "jmp near ptr 标号"  对IP的修改范围是-32768~32767(IP=IP+16位位移)
codesg segment
start:    mov ax,bx
          jmp short s       ;机器码：E8 03  其中03指的是要转移的位移
          add ax,1
        s:inc ax 

       mov ax,4c00h
       int 21h  
codesg ends
end start

;上面的程序执行后,ax=1