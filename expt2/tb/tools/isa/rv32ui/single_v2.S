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

    lui  x2, 0x12345    
    addi x2, x2, 0x678  
    addi x1,x0,8
    sw   x2,0(x1)
    add  x3,x0,x1
    addi x4,x0,0x4
    or   x5,x0,x4
    lw   x6,4(x5)
    addi x7,x0,0x1
test_loop0:
    add  x5,x5,x7
    sub  x3,x3,x7
    and  x1,x3,x5
    beq  x3,x5,test_loop1
    jal  x0, test_loop0
test_loop1:
    addi x1,x1,0x6
    sw   x6,0(x1)
    lw   x8,8(x4)
    beq  x2,x8,pass
    jal  x0,fail
    
  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
