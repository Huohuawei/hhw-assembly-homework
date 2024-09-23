; 数据段，用于定义数据常量
datas segment
    string db 'Hello,World!$'    ; 定义字符串常量
datas ends

; 代码段，包含程序的执行代码
code segment
          assume cs:code,ds:datas

    ; 程序入口点
    start:
          mov    ax,datas            ; 将数据段的段基址移入AX寄存器
          mov    ds,ax               ; 将AX中的段基址送入DS寄存器，使DS指向数据段
          mov    dx,offset string    ; 将字符串的偏移地址移入DX寄存器
          mov    ah,9                ; 设置AH寄存器为9，准备调用DOS中断服务打印字符串
          int    21h                 ; 调用DOS中断服务，打印字符串
          mov    ah,4ch              ; 设置AH寄存器为4CH，准备调用DOS中断服务退出程序
          int    21h                 ; 调用DOS中断服务，退出程序
code ends
; 程序结束，告诉编译器到达代码段的终点
end start