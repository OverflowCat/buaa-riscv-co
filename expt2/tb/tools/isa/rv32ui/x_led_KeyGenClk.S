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

        lui sp,0xffffe                                               
        sw  x27,0(sp)                                                 
        lui sp,0x10000                                               
        addi t2,x0,0x1
        sw  t2,4(sp)                                                                                           
        addi t4,x0,0x80                                            
led_pass:                                                                                                                                               
        add  t2,t2,t2                                                  
        sw  t2,4(sp)                                                      
        beq t2,t4,pass 
        j   led_pass                                       
        beq x0,x0,fail
        
  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
