;实验7 寻址方式在结构化数据访问中的应用
;(难)

assume cs:code

data segment
    ;年份
    db '1975', '1976', '1977', '1978', '1979', '1980', '1981', '1982', '1983'
    db '1984', '1985', '1986', '1987', '1988', '1989', '1990', '1991', '1992'
    db '1993', '1994', '1995'
    ;收入
    dd 16, 22, 382, 1356, 2390, 8000, 16000, 24486, 50065, 97479, 140417, 197514
    dd 345980, 590827, 803530, 1183000, 1843000, 2759000, 3753000, 4649000, 5937000
    ;员工
    dw 3, 7, 9, 13, 28, 38, 130, 220, 476, 778, 1001, 1442, 2258, 2793, 4037, 5635, 8226
    dw 11542, 14430, 15257, 17800
data ends

table segment
    db 21 dup ('year sumn ne ?? ')
table ends

stack segment
	dw 8 dup(0)
stack ends

code segment
start:
	mov ax,data
	mov ds,ax
	mov ax,table
	mov es,ax
	
	;年份部分 
	mov bx,0
	mov si,0
	mov cx,21
s0:	
	mov ax,ds:0[bx]
	mov es:[si],ax
	mov ax,ds:2[bx]
	mov es:2[si],ax
	
	add bx,4
	add si,10h
	loop s0
	
	;收入部分
	
	mov bx,84
	mov si,5
	mov cx,21
s1:
	mov ax,ds:0[bx]
	mov es:[si],ax
	mov ax,ds:2[bx]
	mov es:2[si],ax
	
	add bx,4
	add si,10h
	loop s1
	
	;雇员部分
	
	mov bx,168
	mov si,10
	mov cx,21
s2:
	mov ax,ds:0[bx]
	mov es:[si],ax
	
	add bx,2
	add si,10h
	loop s2
	
	;计算人均 
	mov bx,0
	mov cx,21
s3:
	mov ax,es:5[bx]
	mov dx,es:7[bx]
	div word ptr es:0ah[bx]
	mov es:0dh[bx],ax
	
	add bx,10h
	loop s3
	
	mov ax,4c00h
	int 21h
code ends

end start


