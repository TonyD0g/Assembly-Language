;动态输入数组任意个数和任意位数-进行排序
DATAS SEGMENT
   buf dw 100 dup(?)       ;预留100个数组元素
   max dw ?                ;最大值
   COUNT DW ?              ;数组元素个数
   CHUSHU DW 10            ;分离数据取余数用的10
   error db 'input error',13,10,'$'
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
      MOV   AX,DATAS
      MOV   DS,AX
      
      mov   si,0
      mov   di,0
      
      MOV   BX, 0         ;每个从键盘接收的多位数最终放BX，再送内存单元BUF
lp1:  MOV   AH, 1
      INT   21H
      cmp   al,32          ;按空格输入下一组数据
      jz    lp2
      push ax              ;保护Ax，用与判断是不是回车
      cmp   al,13
      jz    lp2            ;回车结束，但要继续累计个数并保存
      SUB   AL, 30H         
      
      JL    error1         ; <0 报错 重新输入
      CMP   AL, 9
      JG    error1         ; >9 报错 重新输入
      CBW
      XCHG  AX, BX         ;33-37行实现把从键盘输入的多个数字字符转换为真正的数值
      MOV   CX, 10
      MUL   CX              ;乘10,变为两位数
      XCHG  AX, BX
      ADD   BX, AX
      
      jmp lp1
      
lp2:  mov   buf[si],bx     ;把输入的元素送内存单元中   
      mov   bx,0
      inc   si
      inc   si
      inc   di                ;记录输入的数组元素个数
      MOV   COUNT,DI          ;存数组元素个数
      pop   ax
      cmp   al,13
      jz    lp3
      JMP   lp1
 
    
lp3:   MOV	CX,di            ;冒泡法排序
	   DEC	CX               ;比较遍数
LOOP1: MOV  DX,CX            ;保存外循环的循环次数也可以做内循环计数
	   MOV	BX,0
LOOP2:
       MOV  AX, BUF[BX] 
       CMP  AX,BUF[BX+2]
       JGE	L
       XCHG  AX,BUF[BX+2]
       MOV   BUF[BX],AX
L:     ADD   BX,2 
       Loop  loop2
       MOV	  CX,DX     
       LOOP	 LOOP1

 
 
     
;lp3: mov si,0     此段代码是求数组的最大值
     ;mov cx,di
;lp5:mov ax,buf[si]
    ;cmp max,ax
    ;jge lp4
    ;mov max,ax
    ;lp4:inc si
        ;inc si
    ;loop lp5
    
    mov ah,2                ;回车,换行
    mov dl,13
    int 21h
    mov ah,2
    mov dl,10
    int 21h
   
    call tern               ;子程序调用，处理商和余数  
    jmp a9  
error1: mov ah,9
        lea dx,error
        int 21h
        jmp start   
a9: MOV AH,4CH
    INT 21H
    
    
    ;;;;;;;;;;;;;;;子程序调用
TERN    	PROC			

	   ;;;;;;;;;;;;;;;入栈的方法，入栈的是余数

            MOV CX,COUNT  
             
            MOV SI,0      ;地址指针变化
                
LP9:    	push cx       ;此cx控制元素输出
            mov BX,BUF[SI]
			mov cx,0      ;此cx用于记录每个元素在分离时入栈次数
lp11:		mov ax,BX
			cwd
			div chushu
			
			push dx       ;;;;;入栈的是余数
			mov bx,ax     ;;;保存商
			inc cx        ;入栈次数
			cmp ax,0      ;;;商不为0 ，继续送BX除10
			jnz lp11
			
lp33:		pop dx        ;;全部分离完，出栈依次从高到低显示
			mov ah,2
			add dl,30h
			int 21h
			loop lp33     
			
	;;;;;;;;;;;;;;;入栈的方法
	         mov ah,2
             mov dl,32    ;输出的元素用空格分隔
             int 21h
             
	         ADD si,2     ;地址指针移动，取下一个数
	         
	         POP CX
	         LOOP LP9     ;此循环控制输出各个元素
			
			RET
TERN  	ENDP

CODES ENDS
    END START





