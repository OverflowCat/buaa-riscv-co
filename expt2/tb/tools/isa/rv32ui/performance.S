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
        addi t0,x0,0x60                                          
        addi t4,x0,0xFF   
        addi x10,x0,1
        addi x11,x0,2
        addi x12,x0,3
        addi x13,x0,4
        addi x14,x0,5
        addi x15,x0,6                                          
led_pass:                                                             
        lui t1,0x00000                                             
add_loop:                                                             
        addi t1,t1,0x1   
        lui  x11,0xffffe
        sw   x1,0(x13)
        add  x16,x10,x12
        sub  x18,x12,x13
        and  x19,x14,x15 
        lw   x20,0(x13)
        and  x20,x11,x16  
        beq t1,t0, light_led 
        j    add_loop
light_led:        
        addi x13,x0,0                              
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
