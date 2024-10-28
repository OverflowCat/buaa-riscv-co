#set page(flipped: false, numbering: "1")
#set text(font: ("Libertinus Serif", "Noto Serif CJK SC"), lang: "zh", cjk-latin-spacing: auto)
#set quote(block: true)
#show quote: set pad(x: 0em)
#show quote: c => box(pad(c, x: 1em, y: 1em), fill: white.darken(4%), width: 1fr)
#show heading: set text(size: 1.3em)
#show "。": "．"

*计算机组成与系统结构*
#h(1fr)
#line(length: 100%, stroke: rgb(200, 200, 200))
= 第二次作业
#v(1em)

#show raw: set text(font: "JetBrainsMono NF", size: 1.14em)
#show quote: set text(font: "Noto Sans CJK SC", fill: rgb(20, 40, 40))

#show "lw": set text(fill: orange)
#show "sw": set text(fill: orange)
#show "or": set text(fill: orange)
#show "addi": set text(fill: orange)
#show "sra": set text(fill: orange)
#show "srl": set text(fill: orange)

=== 1

#quote[若有一个RISC-V机器指令为`0100000 00010 00001 101 00011 0110011`，请写出其对应的汇编指令，并阐述其功能。]

对于指令 `0100000 00010 00001 101 00011 0110011`，

- 其 opcode 为 `0b0110011`，说明为 R 型指令；
- funct3 为 `0b101`，funct7 为 `0x20`，说明为 `sra` 指令（寄存器算数右移）；
- rs2 为 2，rs1 为 1，rd 为 3。

`sra` 指令的格式为 ```asm sra rd, rs1, rs2```，即将寄存器 `rs1` 的值右移 `rs2` 位后存入寄存器 `rd`。因此，该指令的汇编形式为 *```asm sra x3, x1, x2```*，功能为*将寄存器 `x1` 的值右移 2 位后存入寄存器 `x3`*。

=== 2

#quote[给定RISC-V汇编指令 ```asm addi x3, x1, -10```，请编写其对应的机器指令，包括二进制编码和十六进制编码。]

// addi ADD Immediate I 0010011 0x0 rd = rs1 + imm

- `addi` 为 I 型指令，opcode 为 `0b0010011`，funct3 为 `0b000`，funct7 为 `0x0000000`；
- 格式为 `addi rd, rs1, imm`，其中 `rd` 为 3，`rs1` 为 1，`imm` 为 -10；
- 10 的 12 位二进制表示为 `00000000 1010`，对每一位取反得到 `11111111 0101`，再加 1 得到 `11111111 0110`；其十六进制编码为 `0xFF6`。

故该机器指令*二进制编码为 `1111111 10110 00001 000 00011 0010011`，十六进制编码为 `0xFF608193`*。

=== 3

#quote[给定RISC-V汇编指令 ```asm lw x9, 32(x22)``` ，请编写其对应的机器指令，包括二进制编码和十六进制编码，并解释它的作用以及如何计算内存有效地址。]

- `lw` 为 I 型指令，opcode 为 `0b0000011`，funct3 为 `0b010`，`rd = M[rs1+imm][0:31]`
- rs1 $= 22 = 010110_(2)$，imm $= 32 = 00000100000_(2)$，rd $= 9 = 1001_(2)$。

故该机器指令*二进制编码为 `00000100000 010110 010 01001 0000011`，十六进制编码为 `0x040b2483`*。

=== 4

#quote[对于RISC-V中的寄存器 `X5`，编写一条汇编指令，将其值增加 $100$，并将结果存储回同一寄存器。]

#strong[
```asm
addi x5, x5, 100
```
]

== 2

#show raw.where(block: true): c => align(center, c)
#show "nop": strong

假设以下指令序列在一个五级流水的数据通路中执行：

```asm
add x15, x12, x11
lw  x13, 4(x15)
lw  x12, 0(x2)
or  x13, x15, x13
sw  x13, 0(x15)
```

+ #quote[如果没有前递逻辑或者冒险检测支持，请插入NOP指令保证程序正确执行。]
  #include "2-1.typ"
+ #quote[对代码进行重排，插入最少的NOP指令。假设寄存器 `x17` 可用来做临时寄存器。]
  #include "2-2.typ"
+ #quote[如果处理器中支持前递，但未实现冒险检测单元，上述代码段的执行将会发生什么？]
  - ```asm lw x13, 4(x15)``` 指令依赖于 ```asm add x15, x12, x11``` 的结果 `x15`，在缺少冒险检测单元的情况下，可能会在 `add` WB 未完成时就执行，导致 `x15` 的值未更新，造成加载错误的地址；
  - ```asm or x13, x15, x13``` 指令依赖于 ```asm lw x13, 4(x15)``` 和 ```asm add x15, x12, x11``` 的结果，```asm or x13, x15, x13``` 可能在 ```asm lw x13, 4(x15)``` 尚未完成时就提前执行，导致 `x13` 的值未完全准备好，从而使用了错误的数据；
  - ```asm sw x13, 0(x15)``` 指令依赖于 ```asm or x13, x15, x13``` 的计算结果 `x13`，```asm sw x13, 0(x15)``` 可能会在 ```asm or x13, x15, x13``` 尚未完全完成时尝试存储，导致错误的数据被写入内存。

== 3

#let A = 6
#quote[已知主存地址空间为 #calc.pow(2, A) Byte，块大小为1个字（字长为4 Byte），Cache大小为4个字，请将主存地址进行TIO分解（请简要写明计算过程）。]
#let O = 2
#let I = 2
#let T = A - I - O

- 主存地址空间为 $#calc.pow(2, A) "Bytes" = 2^#A "Bytes"$，至少需要 $#A$ 位地址来表示，故 $A = 6$.
- 每个块大小为 $1$ 个字（$2^2$ Bytes），则 $O = #O$.
- Cache 大小为 $4$ 个字（$4 = 2^2$ 个字），由 $2^I = 4/1$ 得 $I = #I$，即 cache 中有 $4$ 行数据。
- $ T = A - I - O$ = $#A - #I - #O$ = $#T$.
#v(-1.1em)
这样，主存地址可以表示为 #box(move(dy: 1.1em)[
  #set text(font: "IBM Plex Sans", size: .9em)
  #table(columns: (auto, 6em, auto))[#align(right, [#super[31]#h(3.2em) Tag])][#align(center, "Index")][Offset #h(2em)#super[0]][#align(right, [#T bits])][#align(center, [#I bits])][#align(left, [#O bits])]
]) 的 6 位结构。
