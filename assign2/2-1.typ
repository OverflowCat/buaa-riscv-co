```asm
add x15, x12, x11
nop
nop
lw  x13, 4(x15)
lw  x12, 0(x2)
nop
or  x13, x15, x13
nop
nop
sw  x13, 0(x15)
```

#let results = csv("cycles.csv")
#show "MEM": set text(fill: red.darken(30%))
#show table: set text(font: "JetBrainsMono NF", size: .9em)
#show table: t => align(center, box(t, width: 110%))
#table(
  align: center,
  columns: 14+4,
  stroke: (x, y) => if x > 13 {} else {(
    paint: luma(150),
    thickness: 1pt,
  )},
  ..results.flatten(),
)
