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
    lui  x11,0xffffe
    sw   x11,0(x0)
    addi x1,x0,1
    add  x7,x1,x1
    addi x2,x0,2
    sub  x8,x2,x1
    nop
    nop
    nop
    nop
    nop
    beq  x1,x8,test2
    nop
    nop
    nop
    j    fail
    nop
    nop
    nop
test2:
    addi x3,x0,3
    and  x9,x3,x2
    addi x4,x0,4
    or   x10,x4,x3
    nop
    nop
    nop
    nop
    nop
    beq  x10,x9,fail
    nop
    nop
    nop
    j    test3
    nop
    nop
    nop    
test3:
    lw   x16,0(x0)
    addi x5,x0,5
    add  x12,x7,x5
    sub  x13,x2,x5
    add  x13,x13,x5
    add  x13,x13,x5
    and  x14,x3,x2
    addi x6,x0,6
    or   x15,x6,x3
    add  x17,x6,x6
    nop
    beq  x12,x13,test4
    nop
    nop
    nop
    j    fail
    nop
    nop
    nop   
test4:  
    sub  x2,x1,x3
    and  x18,x2,x5
    or   x19,x6,x2
    add  x20,x2,x2
    sw   x21,100(x2)
    sub  x4,x1,x3
    and  x18,x4,x5
    or   x23,x4,x2
    add  x20,x4,x4
    sw   x22,100(x4)
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
    beq  x23,x19,test_pass
    nop
    nop
    nop
    j    fail
    nop
    nop
    nop 
test_pass:
    li  x26,0x01
    li  x27,0x01
    beq x16,x11,test_pass
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
