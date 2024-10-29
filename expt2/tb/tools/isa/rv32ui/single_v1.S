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
test_loop0:
    lw x5,0(x0)
    add x6,x5,x5
    or x10,x5,x6
    add x10,x10,x5
    add x12,x6,x6
    and x11,x5,x6
    sw x10,4(x10)
    add x11,x11,x6
    sub x6,x6,x0
    lw x13,12(x12)
    sub x13,x13,x6
    beq x13,x11,test_loop0
    add x11,x11,x6
    sub x13,x13,x6
    beq x13,x11,test_loop1
    sw x6,4(x6)
test_loop1:
    and x11,x11,x0
    add x6,x6,x5
    sw x6,4(x12)
test_pass:
    beq x0,x0,test_pass

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
