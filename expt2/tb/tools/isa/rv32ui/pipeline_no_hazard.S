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
    lui  x11,0xffffe
    sw   x1,0(x0)
    add  x7,x1,x1
    sub  x8,x2,x1
    and  x9,x3,x2
    or   x10,x4,x3
    lw   x16,0(x0)
    add  x12,x7,x5
    sub  x13,x2,x5
    and  x14,x3,x2
    or   x15,x6,x3
    lui  sp,0xffffe
    nop
    nop
    nop
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
    beq x16,x1,test_pass
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
