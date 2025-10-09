.data
SUCCESS: .string "success"
FAIL: .string "fail"

.text
main:
    li a0, 0
    jal ra,bf16_iszero
    mv a1, a0
    la a0, FAIL
    beq a1, x0, fail
    la a0, SUCCESS
fail:
    jal ra, printResult
    li a7, 10
    ecall
###################
printResult:
    li a7,4
    ecall
    ret
###################
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
###################
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
###################
bf16_iszero:
    li a1, 0x7FFF
    and a1, a0, a1
    li a0, 1
    beq a1, x0, beq4
    li a0, 0
beq4:
    ret
###################
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
###################
bf16_to_f32:
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
