; 数据段，用于定义数据常量
datas segment
      MSG2    db 'a'      ; 定义单个字符常量'a'，用于后续的字符递增输出
      NEWLINE db 0Ah      ; 定义换行字符
datas ends

; 代码段，包含程序的执行代码
code segment

            assume cs:code,ds:datas

      ; 程序入口点
      start:
            mov    ax,datas              ; 将数据段地址送入AX，准备将其设置为数据段寄存器DS
            mov    ds,ax                 ; 将AX中的数据段地址设置为当前数据段寄存器DS的值

            mov    cx,26                 ; 设置循环计数器CX，循环将执行26次，对应字母表的长度
            mov    AH,2                  ; 设置AH寄存器为2，准备使用DOS中断服务，输出字符到屏幕

            mov    bx,0                  ; 初始化BX寄存器，用于计数每行的字符数量
            mov    dx,13
            
      L:    
            mov    al,[MSG2]             ; 将MSG2处的字符'a'加载到AL寄存器
            mov    dl,al                 ; 将AL寄存器的值移动到DL寄存器，准备输出
            int    21h                   ; 调用DOS中断服务，输出DL寄存器中的字符

            inc    al                    ; 对AL寄存器中的字符进行递增，实现字母的循环递增
            mov    [MSG2],al             ; 将递增后的字符值存回MSG2，为下一次输出做准备

            mov    dl,' '
            int    21h                   ;打印空格

            inc    bx                    ; 增加BX寄存器，用于计数每行的字符数量
            cmp    bx,13                 ; 检查是否已经输出了13个字符
            jne    L                     ; 如果还没有输出13个字符，则继续执行
                 


       ; 输出换行符
            mov    dl, [NEWLINE]
            int    21h                   ; 调用DOS中断服务，输出换行符
            dec    cx                    ; 减少CX寄存器，继续输出剩余的字符
            jnz    L                     ; 如果还有字符要输出，则继续执行

            mov    ax,4c00h              ; 设置AX寄存器为4C00H，准备退出程序
            int    21h                   ; 调用DOS中断服务，结束程序执行

code ends

; 程序结束，告诉编译器到达代码段的终点
end start
