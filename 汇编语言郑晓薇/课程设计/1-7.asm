;定义一个过程输入年、月、日
;1、	该年是否是闰年？							[#]
;2、	该日是这一年的第几天？						 [#]	
;3、	计算这一年每月最后一天是本年中的第几天？      [#] 
;4、	将结果存放于数组中。                         [#]


;教程: [在debug模式下]  先 g 004b 执行程序，后 d 076c:0/70  查看结果 
;Author:TonyDog
;Coding:UTF-8
;GitHub:https://github.com/TonyD0g
assume cs:code,ds:data,ss:stack
data segment                                           
	outcome	  db 300 dup (?)		;输出结果           
    Divisor1 dw 4
	Divisor2 dw 100
	Divisor3 dw 400
	Var1     db 13      ;用于计算月份,[var1-CL=月份]
                        ;例如:13-1=12月    13-3=10月份

	userYear dw 0	    ;用户输入的年份
	leapflag db 0		;leapflag为1时，则代表此年是闰年	
	userMonth db 0      ;用户输入的月份
	userDay   db 0     	;用户输入的日期
	spacekey  db ' '	;空格	
	totalDay  dw 0 		;计算总的天数
	allowMaxDay dw 0	;该月允许的最大天数，比如3月最大31天，4月最大30天
	totalLength dw 0
    key1      db 0      ;年份key
    key2      db 0      ;月份key
    key3      db 0      ;日期key
    key4      db 0      ;计算该日是这一年的第几天的 key
    key5      db 0      ;计算这一年每月最后一天是本年中的第几天的 key
    key6      db 0      ;输出天数的key

    buf0     db ' Welcome To The Date query system!','$'
	buf1     db ' The year is Leap year',0ah,0dh,'$'
	buf2     db ' The year is Common year',0ah,0dh,'$'
	buf3 	 db 0ah,0dh,'The day is the ','$'
	buf4 	 db ' in the year ',0ah,0dh,'$'
    buf5     db 0ah,0dh,'The last day of ','$'
    buf6 	 db ' month is the  ','$'    ;The last day of December is the 10th day of this year
    Leapyear db ' is Leap year ','$'
    Commonyear db ' is Common year ','$'
    month db ' month:','$'
    Dian    db '.','$'      ;点号

	notice1  db 0ah,0dh,'Please input the year',0ah,0dh,'$'
	notice2  db 0ah,0dh,'Please input the month',0ah,0dh,'$'
	notice3  db 0ah,0dh,'---------------------------------------------------',0ah,0dh,'$'   ;美化
	notice4  db 0ah,0dh,'Please input the day',0ah,0dh,'$'
    notice5  db 0ah,0dh,'Press any key to continue',0ah,0dh,'$'
    notice6  db 0ah,0dh,'Input 1: Use the system',0ah,0dh,'Input Others: Exit the system',0ah,0dh,'$'

	errorbuf1 db 0ah,0dh,'Please input the correct num!',0ah,0dh,'$'
data ends
Notice0  MACRO x1
	mov ah,9
	mov dx,offset x1
	int 21h
ENDM

stack segment
	dw 30 dup (?)
stack ends	

code segment
start:  mov ax,data
        mov ds,ax
		mov ax,stack
		mov ss,ax
		mov sp,1eh
        mov dh,15    ;行号 , 子程序show_str 的参数
        mov dl,3    ;列号  , 子程序show_str 的参数     
        mov cl,6    ;颜色  , 子程序show_str 的参数 
        mov si,0
        call show_str
        Notice0 notice6
        Notice0 notice3
        mov ah,1
        int 21h
        cmp al,'1'
        jnz over1
        Notice0 notice1
        call Judge		;判断是否是闰年,需要执行完Input后的ax
		call CalculationDate	;计算该日是这一年的第几天？
        call OutYear            ;将是否是闰年的结果输出到数组中
        call timeout1           ;暂停
        call CalculationDate1	;计算这一年每月最后一天是本年中的第几天？
        
over1:  mov ax,4c00h
        int 21h
OutMonth proc far            ;将每个月有多少天的结果输出到数组中
        push dx
        push ax
        push si
        mov si,0				;计算字符串长度		
loop50: mov al,ds:byte ptr [month+si]        
		inc si
		cmp al,'$'
		jnz loop50
		dec si
		
		mov cx,si
		mov bx,ds:word ptr [totalLength]			;接着存储
		mov si,0
loop51:	mov al,ds:byte ptr [month+si]
		mov ds:byte ptr [outcome+si+bx],al
		inc si
		add ds:word ptr [totalLength],1
		loop loop51
        jmp over5
over5:  pop si 
        pop ax
        pop dx
        ret
OutMonth endp           

OutYear proc far                        ;输出该年是否是闰年,如果是闰年则是LeapYear
        push dx
        push ax
        push si
        cmp ds:byte ptr [leapflag],1    ;如果是闰年，则跳转
        jz next4
        mov si,0				;计算字符串长度		
loop30:	mov al,ds:byte ptr [buf2+si]        ;平年
		inc si
		cmp al,'$'
		jnz loop30
		dec si
		
		mov cx,si
		mov bx,ds:word ptr [totalLength]			;接着存储
		mov si,0
loop31:	mov al,ds:byte ptr [buf2+si]
		mov ds:byte ptr [outcome+si+bx],al
		inc si
		add ds:word ptr [totalLength],1
		loop loop31
        jmp over4

next4:  mov si,0				;计算字符串长度		
loop40:	mov al,ds:byte ptr [buf1+si]        ;闰年
		inc si
		cmp al,'$'
		jnz loop40
		dec si
		
		mov cx,si
		mov bx,ds:word ptr [totalLength]			;接着存储
		mov si,0
loop41:	mov al,ds:byte ptr [buf1+si]
		mov ds:byte ptr [outcome+si+bx],al
		inc si
		add ds:word ptr [totalLength],1
		loop loop41
        jmp over4

over4:  pop si 
        pop ax
        pop dx  
        ret
OutYear endp

timeout1   proc far                     ;暂停,等待用户输入任意字符继续
            Notice0 notice5
            mov ah,1
            int 21h
            ret
timeout1   endp

CalculationDate1 proc far   ;计算这一年每月最后一天是本年中的第几天？
        mov cx,12
        mov ds:word ptr [totalDay],0        ;从0开始累加
loop2:  mov ds:byte ptr [var1],13
        call CaDay
        Notice0 buf5        ;The last day of _
        mov dx,0
        mov ax,0
        mov ds:byte ptr [key5],1
        call space          ;输出空格到数组中
        push cx 
        sub ds:byte ptr [var1],cl
        mov al,ds:byte ptr [var1]   
        call stackdiv16     ;输出月份
        call OutMonth       ;输出"month"到数组中
        pop cx

        Notice0 buf6        ; month is the  _
        mov dx,0
        mov ax,0
        mov ax,ds:word ptr [totalDay]
        mov ds:byte ptr [key6],1
        call stackdiv16     ;输出天数
        
        Notice0 buf4        ; in the year 
        loop loop2
        ret
CalculationDate1 endp

space proc far
        push dx
        push ax
        push si
       
		mov bx,ds:word ptr [totalLength]			;接着存储
    	mov al,ds:byte ptr [spacekey]
		mov ds:byte ptr [outcome+bx],al
		add ds:word ptr [totalLength],1

        pop si 
        pop ax
        pop dx
        ret  
space endp

CalculationDate proc far	;计算该日是这一年的第几天？
start1: 
        mov ds:byte ptr [key2],1        ;作用:将此时用户输入的month输出到数组中
		Notice0 notice2 ;输出Please input the month
		mov ax,0
		call Input      ;调用输入功能,结果保存在ax中
		cmp ax,1        ;ax不在1~12范围内的，直接报错，并重新输入
		jb error1   
		cmp ax,12
		ja error1	

        push ax             ;保存寄存器，防止破坏
        push dx 
        mov dx,0
        call stackdiv16		;将月份输出到数组中
        pop dx  
        pop ax	

		mov ds:byte ptr [userMonth],al		;保存用户输入的月份
        call OutMonth1                      ;输出年份到数组中

start2: mov ds:byte ptr [key3],1    ;作用:将此时用户输入的day输出到数组中
        Notice0 notice3	;输出---------------------------------	
		Notice0 notice4	;输出Please input the day
		mov ax,0
		call Input      ;调用输入功能,结果保存在ax中
		mov cl,ds:byte ptr [userMonth]		
		call CaDay1     ;查找该cl(即月份)所允许的最大天数,例如1月最大是31天.
		cmp ax,ds:word ptr [allowMaxDay]    ;如果ax>allowMaxDay ，则用户输入的天数太大
		ja  error2

        push ax
        push dx 
        mov dx,0
        call stackdiv16		;将日期输出到数组中
        pop dx  
        pop ax

		mov ds:byte ptr [userDay],al		;保存用户输入的日期

		;计算该日是这一年的第几天？
		mov ax,0
		mov cx,0
		mov cl,ds:byte ptr [userMonth]		;将月份-1作为循环次数
		cmp cl,1
		jz addday							;如果为1月，则直接加上天数
		sub cl,1

loop1:	call CaDay                      ;计算前[cx=cx-1]月的总天数 
		loop loop1
addday:	mov ax,0
		mov al,ds:byte ptr [userDay]
		add ds:word ptr [totalDay],ax	;total=total+day

		mov dx,0
		mov ax,0
		mov ax,ds:word ptr [totalDay]
		push ax	
        mov ds:byte ptr [key4],1    ;作用:将此时计算出来的total输出到数组中
		Notice0 notice3	;输出---------------------------------
		Notice0 buf3			;输出The day is _
        call OutPut2            ;输出The day is _ 到数组中
		pop ax
		mov dx,0
		call stackdiv16					
		call OutPut3            ;输出 in the year 到数组中
		Notice0 buf4            ;输出天数 in the year
		Notice0 notice3	;输出---------------------------------

		jmp over3
	
error1:Notice0 notice3	;输出---------------------------------
	   Notice0 errorbuf1	;输出Please input the correct num!
	   jmp start1
error2:Notice0 notice3	;输出---------------------------------
	   Notice0 errorbuf1	;输出Please input the correct num!
	   jmp start2

over3:	ret
CalculationDate endp

OutMonth1 proc far
        mov si,0				;计算字符串长度		
loop70: mov al,ds:byte ptr [Dian+si]
	  	inc si
		cmp al,'$'
		jnz loop70
		dec si
		
		mov cx,si
		mov bx,ds:word ptr [totalLength]			;接着存储
		mov si,0
loop71:	mov al,ds:byte ptr [Dian+si]
		mov ds:byte ptr [outcome+si+bx],al
		inc si
		add ds:word ptr [totalLength],1
		loop loop71
        ret
OutMonth1 endp

OutPut3 proc far
        push dx
        push ax
        push si
        mov si,0				;计算字符串长度		
loop80: mov al,ds:byte ptr [buf4+si]        
		inc si
		cmp al,'$'
		jnz loop80
		dec si
		
		mov cx,si
		mov bx,ds:word ptr [totalLength]			;接着存储
		mov si,0
loop81:	mov al,ds:byte ptr [buf4+si]
		mov ds:byte ptr [outcome+si+bx],al
		inc si
		add ds:word ptr [totalLength],1
		loop loop81
over6:  pop si 
        pop ax
        pop dx
        ret
OutPut3 endp
OutPut2 proc far
        push dx
        push ax
        push si
        mov si,0				;计算字符串长度		
loop60: mov al,ds:byte ptr [buf3+si]        
		inc si
		cmp al,'$'
		jnz loop60
		dec si
		
		mov cx,si
		mov bx,ds:word ptr [totalLength]			;接着存储
		mov si,0
loop61:	mov al,ds:byte ptr [buf3+si]
		mov ds:byte ptr [outcome+si+bx],al
		inc si
		add ds:word ptr [totalLength],1
		loop loop61
        pop si 
        pop ax
        pop dx
        ret
OutPut2 endp

CaDay1	proc far			;查找用户所输入的月份中允许的最大天数
		.if cl==4||cl==6||cl==9||cl==11
			mov ds:word ptr [allowMaxDay],30
		.endif
		.if cl==1||cl==3||cl==5||cl==7||cl==8||cl==10||cl==12
			mov ds:word ptr [allowMaxDay],31
		.endif
		.if cl==2						;特殊，必须先判断是否是闰年
			.if ds:byte ptr [leapflag] == 1	;如果为闰年
				mov ds:word ptr [allowMaxDay],29
			.endif
			.if ds:byte ptr [leapflag] == 0	;如果为平年
				mov ds:word ptr [allowMaxDay],28
			.endif
		.endif
		ret
CaDay1	endp

CaDay	proc far			;计算天数
		.if cl==4||cl==6||cl==9||cl==11
			add ds:word ptr [totalDay],30
		.endif
		.if cl==1||cl==3||cl==5||cl==7||cl==8||cl==10||cl==12
			add ds:word ptr [totalDay],31
		.endif
		.if cl==2						;特殊，必须先判断是否是闰年
			.if ds:byte ptr [leapflag] == 1	;如果为闰年
				add ds:word ptr [totalDay],29
			.endif
			.if ds:byte ptr [leapflag] == 0	;如果为平年
				add ds:word ptr [totalDay],28
			.endif
		.endif
		ret
CaDay	endp

stackdiv16 proc far
              push bx
              push dx
              push si
              mov si,0
              
cricle1:      mov bx,10
              div bx

              cmp ax,0
              jbe  next1     ;商比0小就退出，代表数据全部处理完毕
              
              push dx
              inc si
              mov dx,0

              jmp cricle1

next1:        push dx
              inc si
next2:        cmp si,0
              jbe next3         ;如果计数器小于0，则结束

              pop bx
              dec si
              
              .if ds:byte ptr [key1]==1
                    push si
                    push dx   
                    push bx
                    
                    mov dl,bl
                    mov bx,ds:word ptr [totalLength]			;接着存储
                    add dl,30h
                    mov ds:byte ptr [outcome+bx],dl  
                    add ds:word ptr [totalLength],1			;计算总长度
                    pop bx
                    pop dx    
                    pop si
              .endif
              .if ds:byte ptr [key2]==1
                    push si
                    push dx   
                    push bx
                    
                    mov dl,bl
                    mov bx,ds:word ptr [totalLength]			;接着存储
                    add dl,30h
                    mov ds:byte ptr [outcome+bx],dl  
                    add ds:word ptr [totalLength],1			;计算总长度
                    pop bx
                    pop dx    
                    pop si
              .endif
              .if ds:byte ptr [key3]==1
                    push si
                    push dx   
                    push bx
                    
                    mov dl,bl
                    mov bx,ds:word ptr [totalLength]			;接着存储
                    add dl,30h
                    mov ds:byte ptr [outcome+bx],dl  
                    add ds:word ptr [totalLength],1			;计算总长度
                    pop bx
                    pop dx    
                    pop si
              .endif
              .if ds:byte ptr [key4]==1
                    push si
                    push dx   
                    push bx
                    
                    mov dl,bl
                    mov bx,ds:word ptr [totalLength]			;接着存储
                    add dl,30h
                    mov ds:byte ptr [outcome+bx],dl  
                    add ds:word ptr [totalLength],1			;计算总长度
                    pop bx
                    pop dx    
                    pop si
              .endif
              .if ds:byte ptr [key5]==1
                    push si
                    push dx   
                    push bx
                    
                    mov dl,bl
                    mov bx,ds:word ptr [totalLength]			;接着存储
                    add dl,30h
                    mov ds:byte ptr [outcome+bx],dl  
                    add ds:word ptr [totalLength],1			;计算总长度
                    pop bx
                    pop dx    
                    pop si
              .endif
              .if ds:byte ptr [key6]==1
                    push si
                    push dx   
                    push bx
                    
                    mov dl,bl
                    mov bx,ds:word ptr [totalLength]			;接着存储
                    add dl,30h
                    mov ds:byte ptr [outcome+bx],dl  
                    add ds:word ptr [totalLength],1			;计算总长度
                    pop bx
                    pop dx    
                    pop si
              .endif      
              mov ah,2
              mov dl,bl
              add dl,30h
              int 21h

              jmp next2
             
next3:        mov ds:byte ptr [key1],0
              mov ds:byte ptr [key2],0
              mov ds:byte ptr [key3],0
              mov ds:byte ptr [key4],0
              mov ds:byte ptr [key5],0
              mov ds:byte ptr [key6],0
              pop si     
              pop dx       
              pop bx
              ret
stackdiv16 endp

Judge proc far
repter:  call Input                  ;输入年份
         cmp ax,0
         jz error3
    mov ds:byte ptr [key1],1
    push dx 
    push ax
    mov dx,0
    call stackdiv16
    call CR2   
    pop ax
    pop dx
    call OutDian        ;输出点号到数组中去       
    mov dx,0
	mov ds:word ptr [userYear],ax
    div ds:word ptr [Divisor3]	;除以400
    cmp dx,0					;如果被0整除,则是闰年
	jz leapyear0
	
	mov dx,0
	mov ax,ds:word ptr [userYear]
	div ds:word ptr [Divisor1]
	cmp dx,0
	jz judge1				;如果能被4整除,则接着判断
	jmp judge2

error3:
    Notice0 notice3
    Notice0 errorbuf1
    jmp repter

judge1: mov dx,0
		mov ax,ds:word ptr [userYear]
		div ds:word ptr [Divisor2]
		cmp dx,0
		jnz leapyear0			;如果不能被100整除，则是闰年

judge2:	call CR2				
		Notice0 buf2			;输出The year is Common year
		Notice0 notice3
		jmp over2    

leapyear0: call CR2
		   Notice0 buf1	;输出The year is Leap year
		   Notice0 notice3
		   mov ax,0
		   mov al,1
		   mov ds:byte ptr [leapflag],al

over2:	   ret
Judge endp

OutDian proc far
            push dx
            push ax
            push si
    	    mov si,0				;计算字符串长度		
	loop5:	mov al,ds:byte ptr [Dian+si]
			inc si
			cmp al,'$'
			jnz loop5
			dec si
			
			mov cx,si
			mov bx,ds:word ptr [totalLength]			;接着存储
			mov si,0
	loop6:	mov al,ds:byte ptr [Dian+si]
			mov ds:byte ptr [outcome+si+bx],al
			inc si
            add ds:word ptr [totalLength],1
			loop loop6
            pop si 
            pop ax
            pop dx
            ret
OutDian endp

Input proc far			
		
		push bx
		push cx
		push dx
		xor bx, bx  ;bl保存结果	如果两个位的值相同（同为 0 或同为 1），则结果位等于 0；否则结果位等于 1。
		xor cx, cx  ;将cx清零
        xor dx, dx									   ;CX为正负标志，0为正，－1为负
		mov ah, 1	
		int 21h				
		cmp al, '+'
		jz symbol1
		cmp al, '-'
		jnz symbol2	
		mov cx, -1
symbol1: 						;作用:不断输入数字，直到输入不是数字就结束
		mov ah,  1
		int 21h
symbol2:    					;-号:
		cmp al, '0'				
		jb exit1		;清除输入的字符中不是数字的ascii码值
		cmp al, '9'		
		ja exit1		;清除输入的字符中不是数字的ascii码值
		
		sub al, 30h	;将其变为纯数字
		xor ah, ah	;将ah清零
        call change
		jmp symbol1
exit1:
		cmp cx, 0
		jz exit2
		neg bx
exit2:
		mov ax, bx
		pop dx
		pop cx
		pop bx
		ret

        ret
		
change proc far         ;x * 10 + y
	shl bx, 1	
	mov dx, bx	
	shl bx, 1	
	shl bx, 1       ;将bl中的数据左移两次,使bl==8
	add bx, dx
	add bx, ax      
        ret
change endp
Input endp

show_str  proc far   
            push ax     ;保存子程序中用到的相关寄存器,防止和主程序冲突
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
        s2: mov al,ds:[buf0+si]       ;字符给入
        	cmp al,'$'          
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
show_str endp
CR2 proc far    ;输出回车和换行
                push ax
                push dx
                mov ah,2
                mov dl,0ah
                int 21h   
                mov ah,2
                mov dl,0dh
                int 21h
                pop dx
                pop ax
                ret
        CR2 endp
code ends
end start