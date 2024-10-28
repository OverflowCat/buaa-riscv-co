#show "add": set text(fill: rgb("#d73a49"), weight: "bold")
#show "addi": set text(fill: rgb("#d73a49"), weight: "bold")

```asm
add  x15, x12, x11
lw   x17, 0(x2)
lw   x13, 4(x15)
addi x12, x17, 0
or   x13, x15, x13
nop
sw   x13, 0(x15)
```
