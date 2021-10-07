;解决除法溢出的问题 (未完工)
;问题:
;前面讲过，div指令可以做除法，当进行8位除法的时候，用al存储结果的商，ah存储结果的余数
;进行16位除法的时候，用ax存储结果的商，dx存储结果的余数.
;可是，如果结果的商大于al或ax所能存储的最大值，那么将如何?

;比如，下面的程序段
;mov bh,1
;mov ax,1000
;div bh
;进行的是8位除法，结果的商为1000，而1000在al中放不下.

;又比如，下面的程序段:
;mov ax,1000H
;mov dx,1
;mov bx,1
;div bx
;进行的是16位除法，结果的商为11000H，而11000H在ax中存放不下.

;我们在用div 指令做除法的时候，很可能发生上面的情况:结果的商过大，超出了寄存器所能
;存储的范围.当CPU执行div 等除法指令的时候，如果发生这样的情况，将引发CPU 的一个内部
;错误，这个错误被称为   除法溢出 . 我们可以通过特殊的程序来处理这个错误，但在这里
;我们不讨论这个错误的处理，这是后面的课程中要涉及的内容。下面我们仅仅来看一下除法
;溢出发生时的一些现象

;子程序描述:
;名称:divdw
;功能：进行不会产生溢出的除法运算,被除数为dword型，除数为word型，结果为 dword 型
;参数:(ax)=dword 型数据的低16位
;     (dx)=dword 型数据的高16位
;     (cx)=除数

;返回:(dx)=结果的高16位，(ax)=结果的低16位
;     (cx)=余数

;应用举例：计算1000000/10   (F4240H/0AH)
;mov ax,4240H
;mov dx,000FH       
;mov cx,0AH
;call divdw
;结果:(dx)=0001H , (ax)=86A0H   ,(cx)=0

;提示:
;给出一个公式:
;X  :被除数，范围：[0,FFFFFFFF]
;N  :除数,范围:[0,FFFF]
;H  :X高16位，范围:[0,FFFF]
;L  :X低16位，范围：[0,FFFF]
;int()  :描述性运算符，取商，比如:  int(38/10)=3
;rem()  :描述性运算符，取余数，比如:    rem(38/10)=8

;公式：X/N = [int(H/N) * 65536] + [rem(H/N)*65536+L]/N

;这个公式将可能产生溢出的除法运算:X/N ,转变为多个不会产生溢出的除法运算,
;公式中,等号右边的所有除法运算都可以用div指令来做，肯定不会导致除法溢出.
;(关于这个公式的推导，有兴趣的可以看书上的 附注5)


;公式：X/N = [int(H/N) * 65536] + [rem(H/N)*65536+L]/N
;在此题中相当于:
;     X/N = [int(dx/cx) * 65536] + [rem(dx/cx) * 65536 + ax] / cx
;               商                              余
assume cs:code,ss:stack
stack segment
        dd 0
stack ends

data segment
   db 16 dup (0)
data ends

code segment
start:  mov ax,4240H
        mov dx,000FH
        mov ax,data
        mov ds,ax
        mov ds:word ptr [0],0000H
        mov ds:word ptr [2],0001H       
        mov cx,0AH
        call divdw
        mov ax,4c00h
        int 21h

divdw:  ;下面开始处理商`
        push ax  
        push dx
        push bp
        
        mov bx,cx
        mov bp,16
        
        mov ax,dx 
        mov dx,0
        div bx  ;ax已为商
        mov dx,0
        mul dword ptr ds:[0]
        push ax ;保存低16位的商
        push dx ;保存高16位的商

        ;下面开始处理余数
        mov dx,ss:[bp]
        mov ax,bx

        mov dx,0 
        div cx  ;相当于rem(dx/cx)       ,dx中已为余

        mov ax,dx       ;这三行代码的作用 相当于 余数*65536
        mov dx,0
        mul dword ptr ds:[0]
        mul bx     ;dx中存高，ax中存低(此时ax都为0)

        mov bx,ss:[bp-2]
        add ax,bx       ;相当于 (余数*65536)后 加上 ax
        div cx  ;执行后，dx已为余数，相当于     接着除以了一个cx
        mov cx,dx
        pop dx
        pop ax

        retf

code ends
end start




