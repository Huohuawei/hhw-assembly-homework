DATAS SEGMENT
    CRLF   db 13,10,'$'        ; 定义回车换行符的字符串
    number dw ?,?,?,?          ; 存放乘数和被乘数，使用4字节空间
    buf    db ?,?,?,?          ; 缓存转换出来的数字，使用4字节空间
DATAS ENDS

CODES SEGMENT
           ASSUME CS:CODES,DS:DATAS
    START: 
           MOV    AX,DATAS     ; 初始化数据段
           MOV    DS,AX        ; 将数据段寄存器指向DATAS段
           
           mov    cx,9         ; 外层循环9次（乘法表到9乘9）
    s1:    
           mov    [number],cx  ; 将当前乘数（外层循环控制的值）存入number
           push   cx           ; 保存外层循环计数器的值
           push   cx           ; 乘数cx入栈，方便后续取用
          
    s2:                        ; 内层循环，计算每个乘数与当前数的乘积
           call   DisplayMultiplication ; 调用显示乘法过程

           loop   s2            ; 内层循环结束，重复乘法计算
           
           lea    dx,crlf       ; 显示换行
           mov    ah,9          ; 调用DOS中断21h功能号9
           int    21h           ; 中断调用

           pop    cx            ; 恢复外层循环计数器
           pop    cx            ; 恢复cx寄存器的乘数
       
           loop   s1            ; 继续外层循环
    
    ; 程序结束，等待用户输入一个字符后退出
           mov    ah,1          ; 调用DOS中断21h功能号1，等待键盘输入
           int    21h           ; 中断调用
    
           MOV    AH,4CH        ; 正常结束程序
           INT    21H           ; 调用DOS中断21h功能号4Ch，返回到DOS

; 显示乘法过程
DisplayMultiplication PROC
    ; 显示乘数
           mov    dx,[number]   ; 取出乘数
           add    dx,30h        ; 将乘数转换为ASCII码
           mov    ah,2          ; 调用DOS中断21h功能号2，显示字符
           int    21h           ; 中断调用

    ; 显示乘号 'x'
           mov    dl,78h        ; 'x' 的ASCII码为78h
           mov    ah,2          ; 调用DOS中断21h功能号2
           int    21h           ; 中断调用

    ; 显示第二个乘数
           mov    [number+1],cx ; 将第二个乘数保存到number+1
           push   cx            ; 第二个乘数入栈，方便后续计算使用
           mov    dx,cx         ; 将第二个乘数放到dx寄存器
           add    dx,30h        ; 转换为ASCII码
           mov    ah,2          ; 调用DOS中断21h功能号2
           int    21h           ; 中断调用

    ; 显示等号 '='
           mov    dl,3dh        ; '=' 的ASCII码为3Dh
           mov    ah,2          ; 调用DOS中断21h功能号2
           int    21h           ; 中断调用
       
    ; 计算两数相乘的结果，并显示
           pop    dx            ; 从栈中取出第二个乘数
           pop    ax            ; 从栈中取出第一个乘数
           push   ax            ; 第一个乘数再次入栈，下一次内层循环使用

           mul    dx            ; 使用乘法，将AX中的数与DX中的第二个乘数相乘，结果存在AX
           call   ConvertToDecimal ; 调用将结果转换为十进制并输出

           ret
DisplayMultiplication ENDP

; 将乘法结果转换为十进制并输出
ConvertToDecimal PROC
           mov    bx,10         ; 准备以10为基数转换成十进制
           mov    si,2          ; 准备循环2次，最大到十位 (乘法表最大乘积是81)

    toDec:                      ; 将乘积结果从AX转换为ASCII字符
           mov    dx,0          ; 清空DX，准备进行除法
           div    bx            ; 用10除AX，结果商保存在AX，余数在DX
           mov    [buf+si],dl   ; 将余数存入buf，表示某个位的数字
           dec    si            ; 指针指向更高位
           cmp    ax,0          ; 检查商是否为0
           ja     toDec         ; 若商不为0，继续循环

    output:                     ; 将转换后的数字输出
           inc    si            ; 恢复si指向的正确位置
           mov    dl,[buf+si]   ; 取出数字
           add    dl,30h        ; 转换为ASCII码
           mov    ah,2          ; 调用DOS中断21h功能号2
           int    21h           ; 中断调用
           cmp    si,2          ; 检查是否已输出所有位
           jb     output        ; 若未输出完，继续输出

    ; 输出空格
           mov    dl,20h        ; ' ' 的ASCII码为20h
           mov    ah,2          ; 调用DOS中断21h功能号2
           int    21h           ; 中断调用

           ret
ConvertToDecimal ENDP
CODES ENDS
    END START
