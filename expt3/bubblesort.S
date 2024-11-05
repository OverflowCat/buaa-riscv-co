

# See LICENSE for license details.

#*****************************************************************************
# simple.S
#-----------------------------------------------------------------------------
#
# This is the most basic self checking test. If your simulator does not
# pass thiss then there is little chance that it will pass any of the
# more complicated self checking tests.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

        lw x9,32(x22)
        lui s0,0x0    //每条指令下插入一条跳转指令，跳转到延时子过程，子过程执行完成后返回待执行的下一条指令
        jal delay_loop1
        addi s6,x0,16
        addi s1,x0,8
        jal delay_loop2
        addi s2,x0,0x0
        jal delay_loop3
        addi s3,x0,0x0
        jal delay_loop4
        addi s4,x0,8
        jal delay_loop5  //12

loop_i:
        beq  s2,s1,pass
        jal delay_loop6
        addi s3,x0,0
        jal delay_loop7   //4

loop_j:
        addi t0,s3,1
        jal delay_loop8
        bne t0,s4,continue_j
        jal delay_loop9
        addi s2,s2,1
        jal delay_loop10
        addi s4,s4,-1
        jal delay_loop11
        j loop_i

continue_j:
        add t4,s3,s3
        jal delay_loop12
        add t1,t4,t4
        jal delay_loop13
        add t1,s0,t1
        jal delay_loop14
        lw t2,0(t1)
        jal delay_loop15
        lw t3,4(t1)
        jal delay_loop16
        blt t3,t2,swap
        jal delay_loop17
        addi s3,s3,1
        jal delay_loop18
        j loop_j

swap:
        sw t3,0(t1)
        jal delay_loop19
        sw t2,4(t1)
        jal delay_loop20
        addi s3,s3,1
        jal delay_loop21
        j loop_j

delay_loop1:
        li s5,5000000  //延时部分，延时时间为5000000个指令周期，通过ret指令返回待执行的下一条指令

inner_delay_loop1:
        addi s5,s5,-1  //计数器减1
        bne s5,x0,inner_delay_loop1 //判断是否计数完成
        j 0x14

delay_loop2:
        li s5,5000000  //延时部分，延时时间为5000000个指令周期，通过ret指令返回待执行的下一条指令

inner_delay_loop2:
        addi s5,s5,-1  //计数器减1
        bne s5,x0,inner_delay_loop2 //判断是否计数完成
        j 0x20

delay_loop3:
        li s5,5000000  //延时部分，延时时间为5000000个指令周期，通过ret指令返回待执行的下一条指令

inner_delay_loop3:
        addi s5,s5,-1  //计数器减1
        bne s5,x0,inner_delay_loop3 //判断是否计数完成
        j 0x28

delay_loop4:
        li s5,5000000  //延时部分，延时时间为5000000个指令周期，通过ret指令返回待执行的下一条指令

inner_delay_loop4:
        addi s5,s5,-1  //计数器减1
        bne s5,x0,inner_delay_loop4 //判断是否计数完成
        j 0x30

delay_loop5:
        li s5,5000000  //延时部分，延时时间为5000000个指令周期，通过ret指令返回待执行的下一条指令

inner_delay_loop5:
        addi s5,s5,-1  //计数器减1
        bne s5,x0,inner_delay_loop5 //判断是否计数完成
        j 0x38

delay_loop6:
        li s5,5000000  //延时部分，延时时间为5000000个指令周期，通过ret指令返回待执行的下一条指令

inner_delay_loop6:
        addi s5,s5,-1  //计数器减1
        bne s5,x0,inner_delay_loop6 //判断是否计数完成
        j 0x40

delay_loop7:
        li s5,5000000  //延时部分，延时时间为5000000个指令周期，通过ret指令返回待执行的下一条指令

inner_delay_loop7:
        addi s5,s5,-1  //计数器减1
        bne s5,x0,inner_delay_loop7 //判断是否计数完成
        j 0x48

delay_loop8:
        li s5,5000000  //延时部分，延时时间为5000000个指令周期，通过ret指令返回待执行的下一条指令

inner_delay_loop8:
        addi s5,s5,-1  //计数器减1
        bne s5,x0,inner_delay_loop8 //判断是否计数完成
        j 0x50

delay_loop9:
        li s5,5000000  //延时部分，延时时间为5000000个指令周期，通过ret指令返回待执行的下一条指令

inner_delay_loop9:
        addi s5,s5,-1  //计数器减1
        bne s5,x0,inner_delay_loop9 //判断是否计数完成
        j 0x58

delay_loop10:
        li s5,5000000  //延时部分，延时时间为5000000个指令周期，通过ret指令返回待执行的下一条指令

inner_delay_loop10:
        addi s5,s5,-1  //计数器减1
        bne s5,x0,inner_delay_loop10 //判断是否计数完成
        j 0x60

delay_loop11:
        li s5,5000000  //延时部分，延时时间为5000000个指令周期，通过ret指令返回待执行的下一条指令

inner_delay_loop11:
        addi s5,s5,-1  //计数器减1
        bne s5,x0,inner_delay_loop11 //判断是否计数完成
        j 0x68

delay_loop12:
        li s5,5000000  //延时部分，延时时间为5000000个指令周期，通过ret指令返回待执行的下一条指令

inner_delay_loop12:
        addi s5,s5,-1  //计数器减1
        bne s5,x0,inner_delay_loop12 //判断是否计数完成
        j 0x74

delay_loop13:
        li s5,5000000  //延时部分，延时时间为5000000个指令周期，通过ret指令返回待执行的下一条指令

inner_delay_loop13:
        addi s5,s5,-1  //计数器减1
        bne s5,x0,inner_delay_loop13 //判断是否计数完成
        j 0x7c

delay_loop14:
        li s5,5000000  //延时部分，延时时间为5000000个指令周期，通过ret指令返回待执行的下一条指令

inner_delay_loop14:
        addi s5,s5,-1  //计数器减1
        bne s5,x0,inner_delay_loop14 //判断是否计数完成
        j 0x84

delay_loop15:
        li s5,5000000  //延时部分，延时时间为5000000个指令周期，通过ret指令返回待执行的下一条指令

inner_delay_loop15:
        addi s5,s5,-1  //计数器减1
        bne s5,x0,inner_delay_loop15 //判断是否计数完成
        j 0x8c

delay_loop16:
        li s5,5000000  //延时部分，延时时间为5000000个指令周期，通过ret指令返回待执行的下一条指令

inner_delay_loop16:
        addi s5,s5,-1  //计数器减1
        bne s5,x0,inner_delay_loop16 //判断是否计数完成
        j 0x94

delay_loop17:
        li s5,5000000  //延时部分，延时时间为5000000个指令周期，通过ret指令返回待执行的下一条指令

inner_delay_loop17:
        addi s5,s5,-1  //计数器减1
        bne s5,x0,inner_delay_loop17 //判断是否计数完成
        j 0x9c

delay_loop18:
        li s5,5000000  //延时部分，延时时间为5000000个指令周期，通过ret指令返回待执行的下一条指令

inner_delay_loop18:
        addi s5,s5,-1  //计数器减1
        bne s5,x0,inner_delay_loop18 //判断是否计数完成
        j 0xa4

delay_loop19:
        li s5,5000000  //延时部分，延时时间为5000000个指令周期，通过ret指令返回待执行的下一条指令

inner_delay_loop19:
        addi s5,s5,-1  //计数器减1
        bne s5,x0,inner_delay_loop19 //判断是否计数完成
        j 0xb0

delay_loop20:
        li s5,5000000  //延时部分，延时时间为5000000个指令周期，通过ret指令返回待执行的下一条指令

inner_delay_loop20:
        addi s5,s5,-1  //计数器减1
        bne s5,x0,inner_delay_loop20 //判断是否计数完成
        j 0xb8

delay_loop21:
        li s5,5000000  //延时部分，延时时间为5000000个指令周期，通过ret指令返回待执行的下一条指令

inner_delay_loop21:
        addi s5,s5,-1  //计数器减1
        bne s5,x0,inner_delay_loop21 //判断是否计数完成
        j 0xc0

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
