; 使用bx，cx来控制循环进度
; 数据段
datas segment
      MSG2  db 'a'      ; 定义消息变量MSG2，初始值为'a'
datas ends

; 代码段
code segment
                 assume cs:code, ds:datas

      start:     
                 mov    ax, datas
                 mov    ds, ax

                 mov    bx, 1                  ; 外层循环计数器，控制打印两行
                 mov    al, [MSG2]             ; 初始化AL寄存器，用于打印字符

      outer_loop:
                 mov    cx, 13                 ; 内层循环计数器，控制打印13个字母
                 mov    ah, 2                  ; DOS功能号，用于显示字符

      inner_loop:
                 mov    al, [MSG2]             ; 将MSG2的值移动到AL寄存器
                 mov    dl, al                 ; 将AL寄存器的值移动到DL寄存器，准备显示
                 int    21h                    ; 调用DOS中断服务，输出DL寄存器中的字符
                 inc    al                     ; 将AL寄存器的值加1，用于打印下一个字母
                 mov    [MSG2],al              ; 将新的字母值存回MSG2，记录要打印的字母
                 mov    dl, ' '                ; 设置DL寄存器为一个空格字符
                 int    21h                    ; 调用DOS中断服务，输出一个空格
                 loop   inner_loop             ; 内层循环，当CX不为零时重复执行

     
                 mov    dl, 0Dh                ; 设置DL寄存器为回车字符
                 int    21h                    ; 调用DOS中断服务，执行回车
                 mov    dl, 0Ah                ; 设置DL寄存器为换行字符
                 int    21h                    ; 调用DOS中断服务，执行换行
                 dec    bx                     ; 减少外层循环计数器
                 jns    outer_loop             ; 如果BX大于等于0，则跳转到outer_loop继续外层循环

                 mov    ax, 4c00h              ; 设置AX寄存器为结束程序的功能码
                 int    21h                    ; 调用DOS中断服务，结束程序

code ends
end start