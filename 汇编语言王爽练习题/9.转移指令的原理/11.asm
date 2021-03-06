;实验9，根据材料编程     

;编程：在屏幕中间分别显示绿色，绿底红色，白底蓝色的字符串 'welcome to masm!'
;编程所需要的知识:
;80*25 彩色字符模式显示缓冲区(以下简称为显示缓冲区)的结构
;内存地址空间中，B8000H ~ BFFFFH 共32KB 的空间，为80*25 彩色字符模式的显示缓冲区。
;向这个地址空间写入数据,写入的内容将立即出现在显示器上

;在80*25 彩色字符模式下，显示器可以显示25行，每行80个字符，每个字符可以有256种属性
;(背景色，前景色，闪烁，高亮等组合信息)

;这样，一个字符在显示缓冲区中就要占两个字节，分别存放字符的ASCII码和属性,80*25模式下
;一屏的内容在显示缓冲区中共占4000个字节

;显示缓冲区分为8页，每页4KB (约= 4000B),显示器可以显示任意一页的内容，一般情况下
;显示第0页的内容，也就是说通常情况下，B8000H ~ B8F9FH 中的4000个字节的内容将出现
;在显示器上

;在一页显示缓冲区中:
;偏移000 ~ 09F 对应显示上的第i行(80个字符占160个字节)
;偏移0A0 ~ 13F 对应显示器上的第2行
;偏移140 ~ 1DF 对应显示器上的第3行

;依次类推，可知，偏移F00 ~ F9F 对应显示器上的第25行

;在一行中，一个字符占两个字节的存储空间(一个字),低位字节存储字符的ASCII码，高位
;字节存储字符的属性，一行共有80个字符，占160个字节
;即在一行中:
;00 ~ 01单元对应显示器上的第1列
;02 ~ 03单元对应显示器上的第2列
;04 ~ 05单元对应显示器上的第3列

;依次类推，可知,9E ~ 9F 单元对应显示器上的第80列.

;例：在显示器的0行0列显示黑低绿色的字符串'ABCDEF'
;('A'的ASCII码值为41H,02H表示黑底绿色)

;在显示缓冲区中，偶地址存放字符，奇地址存放字符的颜色属性
;一个在屏幕上显示的字符，具有前景(字符色) 和背景(底色) 两种颜色,字符还可以 以高亮度
;和闪烁的方式显示.前景色,背景色，闪烁，高亮等信息被记录在属性字节中

;属性字节的格式:


;含义: BL   R   G   B   I   R   G   B
;    闪烁      背景    高亮     前景

;R:红色,G:绿色,B:蓝色

;可以按位设置属性字节，从而配出各种不同的前景色和背景色.
;比如：
;红底绿字：0100 0010B    红底闪烁绿字:1100 0010B    红底高亮绿字:0000 0111B
;黑底白字:0000 0111B    白底蓝字:0111 0001B

;例：在显示器的0行0列显示红底高亮闪烁绿色的字符串'ABCDEF'
;(红底高亮闪烁绿色，属性字节为: 11001010B ,CAH)

;显示缓冲区里的内容为:
;                00 01 02 03 04 05 06 07 08 09 0A 0B ... 9E 9F
;   B800:0000    41 CA 42 CA 43 CA 44 CA 45 CA 46 CA ... .. ..
;   :
;   :
;   B800:00A0    .. .. .. .. .. .. .. .. .. .. .. .. ... .. ..

;(注意，闪烁的效果必须在全屏DOS方式下才能看到.)

assume cs:codesg,ss:stack
data segment
    db 'welcome to masm!'
    db 00000010b,00100100b,00010111b
data ends

stack segment
     db 16 dup (0)
stack ends

codesg segment
start:      mov ax,data
            mov ds,ax
            mov ax,0B860H
            mov es,ax
            mov ax,stack
            mov ss,ax
            mov sp,16

            mov cx,3
            mov di,0
            mov bx,0
            mov ax,0

     s2:    push cx
     
            mov cx,16
            mov si,0
       s1:  mov al,ds:byte ptr  [si]
            mov ah,ds:byte ptr 16[bx]
            mov es:word ptr  [di],ax

            add di,2
            inc si
            loop s1
            
            inc bx
            add di,080h
            pop cx
            loop s2
       mov ax,4c00h
       int 21h  
codesg ends
end start





 