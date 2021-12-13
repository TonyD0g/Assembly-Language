;定义一个过程输入年、月、日
;1、	该年是否是闰年？							[#]
;2、	该日是这一年的第几天？
;3、	计算这一年每月最后一天是本年中的第几天？
;4、	将结果存放于文件test1.txt或数组中。

;每个月31天的有 1月、3月、5月、7月、8月、10月、12月，一共是七个月；
;每月30天的有 4月、6月、9月、11月共四个月
;2月是平月（二十八天）或者是闰月（二十九天）

;平年:	1月:31	2月:31+day	3月:31+28+day	4月:31+28+30+day	5月:31+28+30+30+day
;		6月:31+28+30+30+31+day	7月:31+28+30+30+31+30+day	8月:31+28+30+30+31+30+31+day
;		9月:31+28+30+30+31+30+31+31+day		10月:31+28+30+30+31+30+31+31+30+day
;coding: gbk
assume cs:code,ds:data,ss:stack
Notice0  MACRO x1
	mov ah,9
	mov dx,offset x1
	int 21h
ENDM
data segment
    Divisor1 dw 4
	Divisor2 dw 100
	Divisor3 dw 400
	Month31  db 31	;每个月31天的有 1月、3月、5月、7月、8月、10月、12月，一共是七个月
	Month30	 db 30	;每月30天的有 4月、6月、9月、11月共四个月
	Month28  db 28	;平年2月二十八天
	Month29  db 29	;闰年2月二十九天

	leap     dw 0
	leapflag db 0		;leapflag为1时，则代表此年是闰年
	userMonth db 0      ;用户输入的月份
	userDay   db 0     	;用户输入的日期
	totalDay  dw 0 		;计算总的天数

	buf1     db 0ah,0dh,'The year is Leap year',0ah,0dh,'$'
	buf2     db 0ah,0dh,'The year is Common year',0ah,0dh,'$'
	
	notice1  db 0ah,0dh,'Please input the year',0ah,0dh,'$'
	notice2  db 0ah,0dh,'Please input the month',0ah,0dh,'$'
	notice3  db 0ah,0dh,'---------------------------------------------------',0ah,0dh,'$'   ;美化
	notice4  db 0ah,0dh,'Please input the day',0ah,0dh,'$'

	errorbuf1 db 0ah,0dh,'Please input the correct num!',0ah,0dh,'$'
data ends

stack segment
	dw 20 dup (?)
stack ends	

code segment
start:  mov ax,data
        mov ds,ax
		mov ax,stack
		mov ss,ax
		mov sp,14h
		Notice0 notice1
        call Control1	;输入年份
        call Judge		;判断是否是闰年,需要执行完Control1后的ax
		call CalculationDate	;计算该日是这一年的第几天？
        
over1:  mov ax,4c00h
        int 21h

CalculationDate proc far	;计算该日是这一年的第几天？
start1: 
		Notice0 notice2 ;Please input the month
		mov ax,0
		mov ah,1
		int 21h
		cmp al,'0'
		jb error1
		cmp al,'9'
		ja error1
		sub al,30h		;003b
		mov ds:byte ptr [userMonth],al		;保存用户输入的月份
start2: Notice0 notice3	;---------------------------------	
		Notice0 notice4	;Please input the day
		mov ax,0
		call Control1
		cmp ax,31
		ja  error2
		sub al,30h
		mov ds:byte ptr [userDay],al		;保存用户输入的日期
		;计算该日是这一年的第几天？
		mov ax,0
		mov cx,0
		mov cl,ds:byte ptr [userMonth]		;将月份-1作为循环次数
		sub cl,1


loop1:	;call CaDay
		loop loop1
		mov ax,0
		mov al,ds:byte ptr [userDay]
		add ds:word ptr [totalDay],ax	;+day

		mov dx,0
		mov ax,ds:word ptr [totalDay]
		call stackdiv16
		
		jmp over3
	
error1:Notice0 errorbuf1	;Please input the correct num!
	   jmp start1
error2:Notice0 errorbuf1	;Please input the correct num!
	   jmp start2

over3:	ret
CalculationDate endp

CaDay	proc far
		.if cl==11
			add ds:word ptr [totalDay],30
		.endif
		.if cl==10
			add ds:word ptr [totalDay],31
		.endif
		.if cl==9
			add ds:word ptr [totalDay],30
		.endif
		.if cl==8
			add ds:word ptr [totalDay],31
		.endif
		.if cl==7
			add ds:word ptr [totalDay],31
		.endif
		.if cl==6
			add ds:word ptr [totalDay],30
		.endif
		.if cl==5
			add ds:word ptr [totalDay],31
		.endif
		.if cl==4
			add ds:word ptr [totalDay],30
		.endif
		.if cl==3
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
		.if cl==1
			add ds:word ptr [totalDay],31
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
              mov ah,2
              mov dl,bl
              add dl,30h
              int 21h

              jmp next2
             
next3:        
              pop si     
              pop dx       
              pop bx
              ret


stackdiv16 endp

Judge proc far
    mov dx,0
	mov ds:word ptr [leap],ax
    div ds:word ptr [Divisor3]	;除以400
    cmp dx,0					;如果被0整除,则是闰年
	jz leapyear0
	
	mov dx,0
	mov ax,ds:word ptr [leap]
	div ds:word ptr [Divisor1]
	cmp dx,0
	jz judge1				;如果能被4整除,则接着判断
	jmp judge2

judge1: mov dx,0
		mov ax,ds:word ptr [leap]
		div ds:word ptr [Divisor2]
		cmp dx,0
		jnz leapyear0			;如果不能被100整除，则是闰年
judge2:					
		Notice0 buf2			;输出The year is Common year
		Notice0 notice3
		jmp over2


leapyear0: 
		   Notice0 buf1	;输出The year is Leap year
		   Notice0 notice3
		   mov ax,0
		   mov al,ds:byte ptr [leapflag]
		   mov al,1
    
over2:	   ret
Judge endp

Control1 proc far			
		
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
		
change proc far         ;x * 10
	shl bl, 1	
	mov dl, bl	
	shl bl, 1	
	shl bl, 1       ;将bl中的数据左移两次,使bl==8
	add bx, dx
	add bx, ax      
        ret
change endp

Control1 endp

code ends
end start