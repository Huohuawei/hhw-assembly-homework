; main.asm
; 主程序模块：加载数据并调用 PrintNumber 子程序来打印年份、收入、雇员数和人均收入

assume cs:codesg, ds:datasg, es:table

datasg segment
    ; 年份数据（每项占4字节）
           db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
           db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
           db '1993','1994','1995'
    ; 收入数据（每项占4字节）
           dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
           dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
    ; 雇员人数数据（每项占2字节）
           dw 3,7,9,13,28,38,130,220H,476,778,1001,1442,2258,2793,4037,5635,8226
           dw 11542,14430,15257,17800
datasg ends

codesg segment

               extrn PrintNumber:proc        ; 声明外部子程序

    start:     
               mov   cx, 21                  ; 数据循环21次
               mov   si, 0                   ; 用于年份和收入的索引
               mov   di, 0                   ; 用于雇员人数的索引

    ; 设置数据段寄存器
               mov   ax, datasg
               mov   ds, ax
     
    print_loop:
    ; 1. 打印年份
               mov   ax, ds:[si]             ; 读取年份低2字节
               call  PrintNumber             ; 打印年份
               mov   ax, ds:[si+2]           ; 读取年份高2字节
               call  PrintNumber

    ; 插入空格
               mov   dl, ' '
               mov   ah, 2
               int   21h

    ; 2. 打印收入
               mov   ax, ds:[84 + si]        ; 读取收入低2字节
               call  PrintNumber             ; 打印收入
               mov   dx, ds:[84 + si + 2]    ; 读取收入高2字节
               call  PrintNumber

    ; 插入空格
               mov   dl, ' '
               mov   ah, 2
               int   21h

    ; 3. 打印雇员人数
               mov   ax, ds:[168 + di]       ; 读取雇员人数
               call  PrintNumber             ; 打印雇员人数

    ; 插入空格
               mov   dl, ' '
               mov   ah, 2
               int   21h

    ; 4. 计算并打印人均收入
               mov   ax, ds:[84 + si]        ; 读取收入低2字节
               mov   dx, ds:[84 + si + 2]    ; 读取收入高2字节
               mov   bx, ds:[168 + di]       ; 读取雇员人数
               div   bx                      ; ax中商为人均收入
               call  PrintNumber             ; 打印人均收入

    ; 换行
               mov   dl, 13                  ; 回车
               mov   ah, 2
               int   21h
               mov   dl, 10                  ; 换行
               int   21h

    ; 更新索引，准备下一个年份数据
               add   si, 4                   ; 年份和收入索引前进4字节
               add   di, 2                   ; 雇员人数索引前进2字节
               loop  print_loop              ; 循环处理21组数据
		
    ; 程序结束
               mov   ax, 4c00h
               int   21h

codesg ends
end start
