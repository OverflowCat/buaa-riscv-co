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
    addi x1,x0,1
    addi x2,x0,2
    addi x3,x0,3
    addi x4,x0,4
    addi x5,x0,5
    addi x6,x0,6
    addi x7,x0,0
    addi x15,x0,0
    addi x29,x0,0
    add  x1,x1,x2
    sub  x1,x1,x3
    and  x1,x1,x4
    beq  x1,x0,test2
    j    fail
test2:
    addi x29,x29,1
    sub  x2,x1,x3
    and  x12,x2,x5
    or   x13,x6,x2
    add  x14,x2,x2
    lui  sp,0x00000
    sw   x4,0(x0)
    and  x4,x2,x5
    or   x8,x2,x6
    lw   x2,0(sp)
    add  x4,x2,x5
    or   x4,x2,x5
    or   x8,x2,x6
    add  x9,x4,x2
    beq  x4,x9,fail
    addi x29,x29,1
    add  x4,x4,x13
    sw   x4,0(x0)
    and  x4,x2,x5
    or   x8,x2,x6
    lw   x2,0(x0)
    add  x4,x2,x5
    or   x4,x2,x5
    or   x8,x2,x6
    add  x9,x4,x2
    lw   x5,0(x0)
    beq  x5,x9,fail
    addi x29,x29,1
    or   x8,x5,x6
test_loop1:
    addi  x7,x7,1
    add  x11,x4,x0
    sub  x8,x11,x1
    and  x9,x3,x8
    or   x10,x4,x9
    sw   x7,0(x11)
    beq  x7,x3,out_loop1
    addi  x15,x15,4
    j    test_loop1
    addi  x15,x15,4
out_loop1:
    addi x15,x15,-4
    lw   x3,0(x0)
    beq  x3,x15,pass

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
