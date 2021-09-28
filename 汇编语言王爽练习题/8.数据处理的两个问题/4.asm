;实验7 寻址方式在结构化数据访问中的应用
;(难)

;PS:想用着大循环来完成的，结果死活不对,后面看别人写的代码豁然开朗,一看我自己写的代码。
;好家伙，每次跳跃都不能对齐，怪不得死活不对
;(该程序是错误的，看看你能不能发现错误在哪，调试错误的代码也能提高技术)

;Power idea 公司从1975年成立一直到1995年的基本情况如下.
;年份       收入        雇员        人均收入
;1975       16          3           ?
;1976       22          7           ?
;1977       382         9           ?
;1978       1356        13          ?
;1979       2390        28          ?
;1980       8000        38          ?

assume cs:codesg,ss:stack
data segment
    db '1975','1976','1977','1978','1979','1980'    ;年份  起始地址：0    末：17h   23 = 17h
    dd 16,22,382,1356,2390,8000                     ;总收入 起:18h    末:2eh       24+24=48 = 30h
    dw 3,7,9,13,28,38                               ;雇员人数 起:31h    末：39h     48+11=59 = 3bh
data ends

table segment ;year summ ne ??
    db 6 dup ('year sumn ne ?? ')    
table ends

stack segment
    dw 8 dup(0)
stack ends

codesg segment 
start:      mov ax,data
            mov ds,ax
            
            mov ax,table
            mov es,ax

            mov ax,stack
            mov ss,ax
            mov sp,16

            mov dx,0
            mov bx,0
            mov cx,6
            mov bp,0            ;控制段地址

        s0:     push cx         ;主循环
                mov si,0
               
                mov cx,4
        s1:     mov ax,ds:[bx+si]
                mov es:[bp+si],ax       ;年份
                inc si
                loop s1
  
                mov es:byte ptr [bp+4],20h ;空格的Ascii码
                
                inc si
                mov ax,ds:[bx+24]
                mov es:[bp+5],ax               ;收入
                mov ax,ds:[bx+24+2]
                mov es:[bp+7],ax

                add si,4
                mov es:byte ptr [bp+9],20h ;空格的Ascii码

                add si,1
                mov ax,ds:[bx+24+24] 
                mov es:[bp+0ah],ax               ;雇员
                
                add si,2
                mov es:byte ptr [bp+0ch],20h ;空格的Ascii码
                                
                add si,1                            ;人均收入
                mov dx,es:[bp+7]       ;高位        [bp+si-6]si-6
                mov ax,es:[bp+5]       ;低位         [bp+si-8]si-8

                ;;;bug
                div word ptr es:[bp+0ah]      ;定义除数    [bp+si-3]

                mov es:[bp+0dh],ax
                
                mov es:byte ptr [bp+0fh],20h ;空格的Ascii码

                add bp,10H

                add bx,4
                mov si,0
                pop cx
                loop s0

            mov ax,4c00h
            int 21h

codesg ends
end start

;答案：add bx,4			各项数据类型不同，无法对齐