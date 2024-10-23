# 作业三

## 求和：

- 将 `num` 和 `total` 改为双字节（`dw`），以支持更大的数值范围。
- 在 `SUM_RESULT` 中预留足够的空间来存储结果数字和结束符。

**累加循环：**

- 使用循环指令 `loop` 来重复累加操作，直到 `cx` 减至 0。
- 每次循环将当前数字 `num` 加到总和 `total` 中，然后递增 `num`。

**数字转换为字符串：**

- 使用循环将总和 `total` 转换为ASCII字符串。
- 从结果字符串的末尾开始存储数字字符，实现正确的数字顺序。
- 使用除法和取余数的方法，将每一位数字转换为对应的字符。

**输出结果：**

- 使用 DOS 中断 `int 21h` 的功能号 `09h` 来输出字符串。

<img src="D:\desktop_file\大学\大三上\汇编语言\hhw-assembly-homework\img\作业三\屏幕截图 2024-10-08 203259.png" style="zoom: 33%;" />

## C语言反汇编：

C语言实现：

<img src="D:\desktop_file\大学\大三上\汇编语言\hhw-assembly-homework\img\作业三\屏幕截图 2024-10-08 203934.png" style="zoom: 67%;" />

反汇编：



```
    .file   "sum.c"
    .section    .rodata
.LC0:
    .string "Sum is: %d\n"
    .text
    .globl  main
    .type   main, @function
main:
    pushq   %rbp
    movq    %rsp, %rbp
    subq    $16, %rsp
    movl    $0, -4(%rbp)       # total = 0
    movl    $1, -8(%rbp)       # i = 1
.L2:
    cmpl    $100, -8(%rbp)     # Compare i with 100
    jg  .L3                    # If i > 100, jump to end
    addl    -8(%rbp), -4(%rbp) # total += i
    addl    $1, -8(%rbp)       # i++
    jmp .L2                    # Repeat loop
.L3:
    movl    -4(%rbp), %esi     # Move total to %esi for printf
    movl    $.LC0, %edi        # Load format string "Sum is: %d\n"
    movl    $0, %eax           # Prepare for function call
    call    printf             # Call printf
    movl    $0, %eax           # Return 0 from main
    leave
    ret

```

结果：`.LC0` 是存储 `"Sum is: %d\n"` 字符串的常量部分。

在 `main` 函数内，堆栈用于存储局部变量 `total` 和 `i`，通过 `movl` 指令将值存入局部变量对应的内存地址。

汇编代码中的 `.L2` 和 `.L3` 是编译器生成的标签，分别对应于 C 语言中的循环开始和结束部分。

最后，调用 `printf` 输出结果