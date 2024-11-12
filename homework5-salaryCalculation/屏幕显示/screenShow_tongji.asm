assume cs:code, ds:data

data segment
         db 'HELLO TONGJI UNIVERSITY !'    ; 要显示的字符串
data ends

code segment
    start:         
    ; 设置显示缓冲区地址
                   mov  ax, 0B800H        ; 设置 es 段地址，指向显示缓冲区
                   mov  es, ax
                   mov  ax, data          ; 设置 ds 段地址，指向 data 段
                   mov  ds, ax

    ; 清屏操作
                   mov  cx, 2000          ; 80x25 字符单元，共 2000 个字符
                   mov  di, 0             ; 显存起始偏移地址
                   mov  ax, 0720H         ; 黑底白字空格 (' ' 的 ASCII 码是 20H，07H 是属性字节)
    clear_screen:  
                   mov  es:[di], ax       ; 将空格写入显存
                   add  di, 2             ; 移动到下一个字符单元
                   loop clear_screen      ; 循环 2000 次，清除屏幕

    ; 设置字符串显示位置
                   mov  bx, 0             ; data 段中字符串的偏移地址
                   mov  si, 07C0H         ; es 段中显示缓冲区的偏移地址
                   mov  cx, 25            ; 显示 16 个字符

    display_string:
                   mov  al, ds:[bx]       ; 从 data 段中获取字符
                   mov  es:[si], al       ; 将字符写入显存
                   inc  si                ; 偏移到属性字节位置
                   mov  al, 02H           ; 设置属性字节为绿色
                   mov  es:[si], al       ; 将属性字节写入显存
                   inc  bx                ; 指向 data 段中下一个字符
                   inc  si                ; 偏移到显存的下一个字符单元
                   loop display_string    ; 循环显示字符串

    ; 程序结束
                   mov  ax, 4C00H         ; 程序返回
                   int  21H

code ends
end start
