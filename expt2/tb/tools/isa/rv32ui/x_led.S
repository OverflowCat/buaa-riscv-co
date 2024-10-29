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
                                                 
        lui sp,0x10000                                               
        lui t2,0x00000                                               
        lui t0,0x00300                                               
        addi t4,x0,0xFF                                             
led_pass:                                                             
        lui t1,0x00000                                             
add_loop:                                                             
        addi t1,t1,0x1                                                  
        beq t1,t0, light_led 
        j    add_loop
light_led:                                      
        addi t2,t2,0x1                                                  
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
