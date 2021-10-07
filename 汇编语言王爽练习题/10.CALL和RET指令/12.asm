;显示字符串 
;问题： 
;显示字符串是现实工作中经常要用到的功能，应该编写一个通用的子程序来实现这个功能。
;我们应该提供灵活的调用接口，使调用者可以决定显示的位置(行，列) , 内容和颜色

;子程序描述:
;名称：show_str
;功能：在指定的位置，用指定的颜色，显示一个用0结束的字符串
;参数：(dh)=行号(取值范围 0 ~ 24) , (dl)=列号(取值范围 0 ~ 79)
;      (cl)=颜色 , ds:si 指向字符串的首地址 
;返回:无



;提示:
;1.子程序的入口参数是屏幕删的行号和列号，注意在子程序内部要将它们转化为显存中的地址，
;   首先要分析一下屏幕上的行列位置和显存地址的对应关系

;2.注意保存子程序中用到的相关寄存器

;3.这个子程序的内部处理和显存的结构密切相关，但是向外提供了与显存结构无关的接口.
;通过调用这个子程序，进行字符串的显示时可以不必了解显存的结构，为编程提供了方便
;在实验中，注意体会这种设计思想

;应用举例:在屏幕的8行3列，用绿色显示data段中的字符串
assume cs:code
data segment
    db 'Welcome to masm!',0
data ends

code segment
start:      mov dh,6    ;行号
            mov dl,3    ;列号       
            mov cl,2    ;颜色
            mov ax,data
            mov ds,ax
            mov si,0
            call show_str

            mov ax,4c00h
            int 21h

show_str:   push ax     ;保存子程序中用到的相关寄存器,防止和主程序冲突
            push bx
            push cx
            push dx
            push si
            push di

            mov bx,0
            mov ax,0b800h       ;显存地址
            mov es,ax
            mov ax,0

            push cx     ;保存cx1
            mov cx,0
            mov cl,ah
         s1:add bx,160  ;使显存走到第八行
            loop s1
            
            add dl,dl   ;2*dl - 2
            sub dl,2
              
            add bx,dx       ;使字符串起始位置为:    第dh行+第dl列

            pop cx          ;恢复cx1
            mov dl,cl
            mov di,0

            mov si,0
        s2: mov al,ds:[si]       ;字符给入
        	cmp al,0             ;原书这里超纲了，暂时还没学到cmp指令
	        je ok                ;如果字符为0，则结束
            mov ah,dl            ;颜色
            mov es:[bx+di],ax    ;导到显存
            add bx,2             ;在显存中 以（ASCII，属性）为块 进行存储
            inc si               ;使字符串往后走
            jmp s2

         ok:pop ax              ;恢复子程序中用到的相关寄存器,防止和主程序冲突
            pop bx
            pop cx
            pop dx
            pop si
            pop di
            retf
            
code ends
end start