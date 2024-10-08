; 修改后的程序计算从1到100的所有整数之和，并将结果打印出来

; 数据段，用于定义数据常量
datas segment
    MSG1 db 'Sum is: $'         ; 定义输出字符串常量
    SUM_RESULT db '     $'      ; 定义结果字符串，预留5个字符位置（包括结尾的'$'）
    total dw 0                  ; 总和（使用双字节以支持更大的数值）
datas ends

; 代码段，包含程序的执行代码
code segment
    assume cs:code, ds:datas

    start:
        mov ax, datas            ; 将数据段的段基址移入AX寄存器
        mov ds, ax               ; 将AX中的段基址送入DS寄存器，使DS指向数据段

        mov cx, 100              ; 设置循环次数为 100
        mov total, 0             ; 初始化总和为 0
        mov bx, 1                ; 初始化累加起始值为 1

    sum_loop:
        add total, bx            ; 将当前值加到总和
        inc bx                   ; 当前值加 1
        loop sum_loop            ; 循环直到 CX 减到 0

    ; 将总和转换为字符串形式
    lea si, SUM_RESULT+4         ; 指向结果字符串的最后一个数字位置（倒数第二个字符）
    mov ax, total                ; 将总和移入AX
    mov bx, 10                   ; 设置除数为 10

    ; 清空SUM_RESULT中的数字部分，用空格填充
    mov di, offset SUM_RESULT    ; 指向结果字符串的起始位置
    mov cx, 5                    ; 结果字符串长度（包括结尾的'$'）
    mov al, ' '                  ; 空格字符
fill_spaces:
    mov [di], al                 ; 用空格填充
    inc di
    loop fill_spaces

    mov cx, 0                    ; 初始化计数器

convert_loop:
    xor dx, dx                   ; 清除DX，以准备除法
    div bx                       ; AX除以10，商在AX，余数在DX
    add dl, '0'                  ; 将余数转换为ASCII字符
    mov [si], dl                 ; 存储字符到结果字符串
    dec si                       ; 指向前一个位置
    inc cx                       ; 计数位数
    cmp ax, 0
    jne convert_loop             ; 如果商不为0，继续循环

    ; 输出 "Sum is: "
    mov dx, offset MSG1          ; 将MSG1的偏移地址移入DX
    mov ah, 09h                  ; DOS功能号：显示字符串
    int 21h                      ; 调用DOS中断

    ; 输出计算结果
    mov dx, si                   ; SI此时指向第一个有效数字的位置
    inc dx                       ; 调整DX指向正确的位置
    mov ah, 09h                  ; DOS功能号：显示字符串
    int 21h                      ; 调用DOS中断

    ; 程序结束，返回到DOS
    mov ax, 4C00h                ; 设置AX为4C00h，准备退出程序
    int 21h                      ; 调用DOS中断服务，退出程序
code ends

end start