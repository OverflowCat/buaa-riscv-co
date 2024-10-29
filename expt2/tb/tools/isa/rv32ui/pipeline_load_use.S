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
    sw   x2,0(x0)
    sw   x3,4(x0)
    sw   x5,8(x0)
    sw   x6,8(x4)
    add  x7,x1,x1
    add  x8,x4,x4
    sub  x10,x4,x4
    nop
    nop
    nop
    nop
    lw   x16,0(x10)
    and  x9,x16,x2
    nop
    nop
    nop
    nop
    nop
    beq  x9,x16,test2
    nop
    nop
    nop
    j    fail
    nop
    nop
    nop   
test2:
    lw   x17,4(x10)
    add  x10,x17,x17
    add  x9,x3,x3
    nop
    nop
    nop
    nop
    nop
    beq  x9,x10,test3
    nop
    nop
    nop
    j    fail
    nop
    nop
    nop  
test3:    
    add  x8,x4,x4
    lw   x18,0(x8)
    addi x18,x18,4
    addi x9,x0,9
    nop
    nop
    nop
    nop
    nop
    beq  x9,x18,test4
    nop
    nop
    nop
    j    fail
    nop
    nop
    nop   
test4:   
    lw   x19,4(x8)
    sub  x13,x19,x5
    and  x14,x3,x2
    sub  x9,x2,x1
    nop
    nop
    nop
    nop
    nop
    beq  x9,x13,test_pass
    nop
    nop
    nop
    j    fail
    nop
    nop
    nop      
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
    beq x0,x0,test_pass
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
