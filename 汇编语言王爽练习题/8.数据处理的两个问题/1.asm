;下面通过一个问题来讨论各种寻址方式的作用

;关于DEC公司的一条记录(1982年)如下
;公司名称:DEC               ;起始地址: seg:60
;总裁姓名:Ken Olsen         ;起始地址: seg:60+03H
;排名:137                   ;起始地址: seg:60+0CH
;收入:40                    ;起始地址: seg:60+0EH
;著名产品:PDP               ;起始地址: seg:60+10H

;1988年DEC公司的信息有了如下变化:
;排名上升为38位
;DEC的收入增加了70
;著名产品已变为VAX系列计算机

;我们提出的任务是,编程修改内存中的过时数据
;要修改的内容是:
;1.(DEC公司记录)的(排名字段)
;2.(DEC公司记录)的(收入字段)
;3.(DEC公司记录)的(产品字段)的(第一个字符),(第二个字符),(第三个字符)

;我用的写法：用ASCII显示出来
assume cs:codesg,ds:datasg
datasg segment
    db 'DEC'
    db 'Ken Oslen'      ;另一种写法(书上的写法)：直接改数值，不容易溢出，但不直观
    db '137'            ;dw 137                        
    db '40 '            ;dw 40
    db 'PDP'
datasg ends

codesg segment
start:      mov ax,datasg
            mov ds,ax
            mov bx,0

            mov byte ptr [bx+0ch],20h       ;mov word ptr [bx+0ch],38
            mov byte ptr [bx+0dh],34h       ;add word ptr [bx+0eh],70
            mov byte ptr [bx+0eh],30h

            mov byte ptr [bx+0fh],31h
            mov byte ptr [bx+10h],33h
            mov byte ptr [bx+11h],30h

            mov si,0
            mov byte ptr [bx+12h+si],'V'    ;mov byte ptr [bx+10h+si],'V'
            inc si
            mov byte ptr [bx+12h+si],'A'    ;mov byte ptr [bx+10h+si],'V'
            inc si
            mov byte ptr [bx+12h+si],'X'    ;mov byte ptr [bx+10h+si],'V'

            mov ax,4c00h
            int 21h
codesg ends
end start


