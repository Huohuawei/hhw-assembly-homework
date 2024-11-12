; printnum.asm
; 打印模块：将AX中的数字转换成字符并输出

assume cs:codesg

codesg segment

PrintNumber proc
        ; 子程序：将AX中数值逐位转换为字符并打印

                    push ax                 ; 保存ax的值
                    mov  cx, 0              ; 位数计数器清零
                    mov  bx, 10             ; 设置除数为10

        ConvertLoop:
                    xor  dx, dx             ; 清空dx
                    div  bx                 ; ax / 10，商在ax，余数在dx
                    push dx                 ; 将余数（当前位数字）压入栈
                    inc  cx                 ; 位数计数加1
                    test ax, ax             ; 检查商是否为0
                    jnz  ConvertLoop        ; 如果商不为0，继续循环

        PrintLoop:  
                    pop  dx                 ; 弹出余数（个位数字）
                    add  dl, '0'            ; 转换成ASCII字符
                    mov  ah, 2              ; DOS打印字符功能号
                    int  21h                ; 显示字符
                    loop PrintLoop          ; 循环打印所有位
                    pop  ax                 ; 恢复ax初值
                    ret
PrintNumber endp

codesg ends
end
