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
    addi x7,x0,0
    addi x2,x0,2
    addi x3,x0,3
    addi x4,x0,4
    addi x5,x0,5
    addi x6,x0,6
    addi x12,x0,0
    addi x16,x0,0
    lui  x11,0xffffe
test_loop1:
    add  x7,x7,x1
    add  x11,x4,x0
    sub  x8,x2,x1
    and  x9,x3,x2
    or   x10,x4,x3
    sw   x7,0(x11)
    beq  x7,x2,test_loop2
    add  x12,x12,x1
    beq  x16,x4,fail
    j    test_loop1
test_loop2:
    lw   x16,0(x4)
    add  x12,x12,x1
    sub  x13,x2,x5
    and  x14,x3,x2
    or   x15,x6,x3
    beq  x7,x12,test_pass
    add  x12,x12,x1
    sub  x13,x2,x5
    and  x14,x3,x2
    or   x15,x6,x3
    nop
    nop
    sw   x1,0(sp)
    nop
    nop
    nop
    nop
    nop
test_pass:
    li  x26,0x01
    li  x27,0x01
    beq x12,x2,test_pass
    nop
    nop
    nop
    nop

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
