.data
SUCCESS: .string "success"
FAIL: .string "fail"
NEW_LINE: .string "\n"
BASIC_CONVERTION: .string "Testing basic conversions...\n"
F32: .string "f32: "
B16: .string "b16: "

.text
main:
    li a0, 0
    jal ra,test_basic_conversions
    li a7, 10
    ecall
###################
printString:
    li a7,4
    ecall
    ret
###################
printNumber:
    li a7,1
    ecall
    ret
######## bf16_isnan ########
bf16_isnan:
    li a1, 0x7F80
    and a2, a0, a1
    beq a2, a1, beq1
    li a0, 0
    ret
beq1:
    li a1, 0x007F
    and a0, a0, a1
    ret 
######## bf16_isinf ########
bf16_isinf:
    li a1, 0x7F80
    and a2, a0, a1
    beq a2, a1, beq2
    li a0, 0
    ret
beq2:
    li a1, 0x007F
    and a1, a0, a1
    li a0, 1
    beq a1, x0, beq3
    li a0, 0
beq3:
    ret
######## bf16_iszero ########
bf16_iszero:
    li a1, 0x7FFF
    and a1, a0, a1
    li a0, 1
    beq a1, x0, beq4
    li a0, 0
beq4:
    ret
######## f32_to_bf16 ########
f32_to_bf16:
    srli a1, a0, 23
    andi a1, a1, 0xFF
    li a2, 0xFF
    beq a1, a2, beq5
    srli a1, a0, 16
    andi a1, a1, 1
    li a2, 0x7FFF
    add a1, a1, a2
    add, a0, a0, a1
    ret
beq5:
    srli a1, a0, 16
    li a0, 0xFFFF
    and a0, a1, a0
    ret
######## bf16_to_f32 ########
bf16_to_f32:
    slli a0, a0, 16
    ret
######## bf16_add ########
bf16_add:
    addi sp, sp, -40
    srli a2, a0, 15
    andi a2, a2, 1
    sw a2 0(sp) #sign_a = (a.bits >> 15) & 1;
    srli a2, a1, 15
    andi a2, a2, 1
    sw a2 4(sp) #sign_b = (b.bits >> 15) & 1;
    srli a2, a0, 7
    andi a2, a2, 0xFF
    sw a2 8(sp) #exp_a = ((a.bits >> 7) & 0xFF);
    srli a2, a1, 7
    andi a2, a2, 0xFF
    sw a2 12(sp) #exp_b = ((b.bits >> 7) & 0xFF);
    andi a2, a0, 0x7F
    sw a2 16(sp) #mant_a = a.bits & 0x7F;
    andi a2, a1, 0x7F
    sw a2 20(sp) #mant_b = b.bits & 0x7F;
    
    lw a2 8(sp) #exp_a
    lw a5 12(sp) #exp_b
    li a3 0xFF
    lw a4 16(sp) #mant_a
    lw a6 20(sp) #mant_b
    
    bne a2, a3, bne1  #if (exp_a == 0xFF)
    bne x0, a4, bne3  #if(mant_a != 0) return a;

    bne a5, a3, bne3  #if(exp_b != 0xFF) return a;
    lw a2 20(sp) #mant_b
    lw a3 0(sp)  #sign_a
    lw a4 4(sp)  #sign_b
    
    bne x0, a2, bne4 #if(mant_b)
    beq a3, a4, bne4 #if(sign_a==sign_b)
ben2:
    mv a0, a1
    ret           #return b;
bne4:
    li a0, 0x7FC0 #return BF16_NAN();
    ret
bne3:
    ret           #return a;
bne1:
    beq a5, a3, ben2 #if (exp_b == 0xFF) return b;
    bne a2, x0, bne5 #if (exp_a!=0) continue
    bne a4, x0, bne5 #if (mant_a!=0) continue
    j ben2           #if (!exp_a&&!mant_a) return b;
bne5:
    bne a5, x0, bne6 #if (exp_b!=0) continue
    bne a6, x0, bne6 #if (mant_b!=0) continue
    j bne3           #if (!exp_b&&!mant_b) return a;
bne6:
    beq a2, x0, bne7 #if (exp_a)
    ori a4, a4, 0x80 #mant_a |= 0x80;
    sw a4, 16(sp)
bne7:
    beq a2, x0, bne8 #if (exp_a)
    ori a6, a6, 0x80 #mant_b |= 0x80;
    sw a4, 20(sp)
bne8:
    addi sp, sp, 40

######## test_basic_conversions ########
test_basic_conversions:
    la a0, BASIC_CONVERTION
    addi sp, sp, -56
    li a1, 0x0
    sw a1 0(sp) #0.0f
    li a1, 0x3F800000
    sw a1 4(sp) #1.0f
    li a1, 0xBF800000
    sw a1 8(sp) #-1.0f
    li a1, 0x40000000
    sw a1 12(sp) #2.0f
    li a1, 0xC0000000
    sw a1 16(sp) #-2.0f
    li a1, 0x3F000000
    sw a1 20(sp) #0.5f
    li a1, 0xBF000000
    sw a1 24(sp) #-0.5f
    li a1, 0x40490fd0
    sw a1 28(sp) #3.14159f
    li a1, 0xc0490fd0
    sw a1 32(sp) #-3.14159f
    li a1, 0x501502f9
    sw a1 36(sp) #1e10f
    li a1, 0xd01502f9
    sw a1 40(sp) #-1e10f
    sw ra, 44(sp)
    
    jal ra, printString
    #for loop
    li a1, 0
    li a2, 44
for_start1:
    sw a1, 48(sp) #store a1
    sw a2, 52(sp) #store a2
    add a3, sp, a1
    
    lw a0, 0(a3)
    jal ra, f32_to_bf16
    jal ra, bf16_to_f32
    
    lw a1, 48(sp) #restore a1
    lw a2, 52(sp) #restore a2
    # Check if the diff is in tolerate range
    add a3, sp, a1
    lw a4, 0(a3)
    # Compare bit31 ~ bit19
    srli a5, a4, 18
    srli a6, a0, 18
    beq a5, a6, bne100
    la a0, F32
    jal ra, printString
    mv a0, a5 
    jal ra, printNumber
    la a0, NEW_LINE
    jal ra, printString
    
    la a0, B16
    jal ra, printString
    mv a0, a4
    jal ra, printNumber
    la a0, NEW_LINE
    jal ra, printString
    
bne100:
    addi a1, a1, 4
    blt a1, a2, for_start1
    lw ra, 44(sp)
    addi sp, sp, 56
    ret