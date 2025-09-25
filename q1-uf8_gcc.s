	.file	"q1-uf8.c"
	.option nopic
	.attribute arch, "rv64i2p1_m2p0_zmmul1p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.type	clz, @function
clz:
	addi	sp,sp,-48
	sd	ra,40(sp)
	sd	s0,32(sp)
	addi	s0,sp,48
	mv	a5,a0
	sw	a5,-36(s0)
	li	a5,32
	sw	a5,-20(s0)
	li	a5,16
	sw	a5,-24(s0)
.L3:
	lw	a5,-24(s0)
	lw	a4,-36(s0)
	srlw	a5,a4,a5
	sw	a5,-28(s0)
	lw	a5,-28(s0)
	sext.w	a5,a5
	beq	a5,zero,.L2
	lw	a5,-20(s0)
	mv	a4,a5
	lw	a5,-24(s0)
	subw	a5,a4,a5
	sw	a5,-20(s0)
	lw	a5,-28(s0)
	sw	a5,-36(s0)
.L2:
	lw	a5,-24(s0)
	sraiw	a5,a5,1
	sw	a5,-24(s0)
	lw	a5,-24(s0)
	sext.w	a5,a5
	bne	a5,zero,.L3
	lw	a5,-20(s0)
	lw	a4,-36(s0)
	subw	a5,a5,a4
	sext.w	a5,a5
	mv	a0,a5
	ld	ra,40(sp)
	ld	s0,32(sp)
	addi	sp,sp,48
	jr	ra
	.size	clz, .-clz
	.section	.rodata
	.align	3
.LC0:
	.string	"mantissa %d\n"
	.align	3
.LC1:
	.string	"exponent %d\n"
	.align	3
.LC2:
	.string	"offset %d\n"
	.text
	.align	2
	.globl	uf8_decode
	.type	uf8_decode, @function
uf8_decode:
	addi	sp,sp,-48
	sd	ra,40(sp)
	sd	s0,32(sp)
	addi	s0,sp,48
	mv	a5,a0
	sb	a5,-33(s0)
	lbu	a5,-33(s0)
	sext.w	a5,a5
	andi	a5,a5,15
	sw	a5,-20(s0)
	lbu	a5,-33(s0)
	srliw	a5,a5,4
	sb	a5,-21(s0)
	lbu	a5,-21(s0)
	sext.w	a5,a5
	li	a4,15
	subw	a5,a4,a5
	sext.w	a5,a5
	li	a4,32768
	addiw	a4,a4,-1
	sraw	a5,a4,a5
	sext.w	a5,a5
	slliw	a5,a5,4
	sw	a5,-28(s0)
	lw	a5,-20(s0)
	mv	a1,a5
	lui	a5,%hi(.LC0)
	addi	a0,a5,%lo(.LC0)
	call	printf
	lbu	a5,-21(s0)
	sext.w	a5,a5
	mv	a1,a5
	lui	a5,%hi(.LC1)
	addi	a0,a5,%lo(.LC1)
	call	printf
	lw	a5,-28(s0)
	mv	a1,a5
	lui	a5,%hi(.LC2)
	addi	a0,a5,%lo(.LC2)
	call	printf
	lbu	a5,-21(s0)
	sext.w	a5,a5
	lw	a4,-20(s0)
	sllw	a5,a4,a5
	sext.w	a5,a5
	lw	a4,-28(s0)
	addw	a5,a4,a5
	sext.w	a5,a5
	mv	a0,a5
	ld	ra,40(sp)
	ld	s0,32(sp)
	addi	sp,sp,48
	jr	ra
	.size	uf8_decode, .-uf8_decode
	.align	2
	.globl	uf8_encode
	.type	uf8_encode, @function
uf8_encode:
	addi	sp,sp,-64
	sd	ra,56(sp)
	sd	s0,48(sp)
	addi	s0,sp,64
	mv	a5,a0
	sw	a5,-52(s0)
	lw	a5,-52(s0)
	sext.w	a4,a5
	li	a5,15
	bgtu	a4,a5,.L8
	lw	a5,-52(s0)
	andi	a5,a5,0xff
	j	.L9
.L8:
	lw	a5,-52(s0)
	mv	a0,a5
	call	clz
	mv	a5,a0
	sw	a5,-32(s0)
	li	a5,31
	lw	a4,-32(s0)
	subw	a5,a5,a4
	sw	a5,-36(s0)
	sb	zero,-17(s0)
	sw	zero,-24(s0)
	lw	a5,-36(s0)
	sext.w	a4,a5
	li	a5,4
	ble	a4,a5,.L16
	lw	a5,-36(s0)
	andi	a5,a5,0xff
	addiw	a5,a5,-4
	sb	a5,-17(s0)
	lbu	a5,-17(s0)
	andi	a4,a5,0xff
	li	a5,15
	bleu	a4,a5,.L11
	li	a5,15
	sb	a5,-17(s0)
.L11:
	sb	zero,-25(s0)
	j	.L12
.L13:
	lw	a5,-24(s0)
	slliw	a5,a5,1
	sext.w	a5,a5
	addiw	a5,a5,16
	sw	a5,-24(s0)
	lbu	a5,-25(s0)
	addiw	a5,a5,1
	sb	a5,-25(s0)
.L12:
	lbu	a5,-25(s0)
	mv	a4,a5
	lbu	a5,-17(s0)
	andi	a4,a4,0xff
	andi	a5,a5,0xff
	bltu	a4,a5,.L13
	j	.L14
.L15:
	lw	a5,-24(s0)
	addiw	a5,a5,-16
	sext.w	a5,a5
	srliw	a5,a5,1
	sw	a5,-24(s0)
	lbu	a5,-17(s0)
	addiw	a5,a5,-1
	sb	a5,-17(s0)
.L14:
	lbu	a5,-17(s0)
	andi	a5,a5,0xff
	beq	a5,zero,.L16
	lw	a5,-52(s0)
	mv	a4,a5
	lw	a5,-24(s0)
	sext.w	a4,a4
	sext.w	a5,a5
	bltu	a4,a5,.L15
	j	.L16
.L19:
	lw	a5,-24(s0)
	slliw	a5,a5,1
	sext.w	a5,a5
	addiw	a5,a5,16
	sw	a5,-40(s0)
	lw	a5,-52(s0)
	mv	a4,a5
	lw	a5,-40(s0)
	sext.w	a4,a4
	sext.w	a5,a5
	bltu	a4,a5,.L20
	lw	a5,-40(s0)
	sw	a5,-24(s0)
	lbu	a5,-17(s0)
	addiw	a5,a5,1
	sb	a5,-17(s0)
.L16:
	lbu	a5,-17(s0)
	andi	a4,a5,0xff
	li	a5,14
	bleu	a4,a5,.L19
	j	.L18
.L20:
	nop
.L18:
	lw	a5,-52(s0)
	mv	a4,a5
	lw	a5,-24(s0)
	subw	a5,a4,a5
	sext.w	a5,a5
	lbu	a4,-17(s0)
	sext.w	a4,a4
	srlw	a5,a5,a4
	sext.w	a5,a5
	sb	a5,-41(s0)
	lb	a5,-17(s0)
	slliw	a5,a5,4
	slliw	a4,a5,24
	sraiw	a4,a4,24
	lb	a5,-41(s0)
	or	a5,a4,a5
	slliw	a5,a5,24
	sraiw	a5,a5,24
	andi	a5,a5,0xff
.L9:
	mv	a0,a5
	ld	ra,56(sp)
	ld	s0,48(sp)
	addi	sp,sp,64
	jr	ra
	.size	uf8_encode, .-uf8_encode
	.section	.rodata
	.align	3
.LC3:
	.string	"============="
	.align	3
.LC4:
	.string	"i=%d\n"
	.align	3
.LC5:
	.string	"value: %d\n"
	.align	3
.LC6:
	.string	"fl2: %d\n"
	.align	3
.LC7:
	.string	"%02x: produces value %d but encodes back to %02x\n"
	.align	3
.LC8:
	.string	"%02x: value %d <= previous_value %d\n"
	.text
	.align	2
	.type	test, @function
test:
	addi	sp,sp,-48
	sd	ra,40(sp)
	sd	s0,32(sp)
	addi	s0,sp,48
	li	a5,-1
	sw	a5,-20(s0)
	li	a5,1
	sb	a5,-21(s0)
	li	a5,47
	sw	a5,-28(s0)
	j	.L22
.L25:
	lui	a5,%hi(.LC3)
	addi	a0,a5,%lo(.LC3)
	call	puts
	lw	a5,-28(s0)
	mv	a1,a5
	lui	a5,%hi(.LC4)
	addi	a0,a5,%lo(.LC4)
	call	printf
	lw	a5,-28(s0)
	sb	a5,-29(s0)
	lbu	a5,-29(s0)
	mv	a0,a5
	call	uf8_decode
	mv	a5,a0
	sw	a5,-36(s0)
	lw	a5,-36(s0)
	mv	a1,a5
	lui	a5,%hi(.LC5)
	addi	a0,a5,%lo(.LC5)
	call	printf
	lw	a5,-36(s0)
	mv	a0,a5
	call	uf8_encode
	mv	a5,a0
	sb	a5,-37(s0)
	lbu	a5,-37(s0)
	sext.w	a5,a5
	mv	a1,a5
	lui	a5,%hi(.LC6)
	addi	a0,a5,%lo(.LC6)
	call	printf
	lbu	a5,-29(s0)
	mv	a4,a5
	lbu	a5,-37(s0)
	andi	a4,a4,0xff
	andi	a5,a5,0xff
	beq	a4,a5,.L23
	lbu	a5,-29(s0)
	sext.w	a5,a5
	lbu	a4,-37(s0)
	sext.w	a3,a4
	lw	a4,-36(s0)
	mv	a2,a4
	mv	a1,a5
	lui	a5,%hi(.LC7)
	addi	a0,a5,%lo(.LC7)
	call	printf
	sb	zero,-21(s0)
.L23:
	lw	a5,-36(s0)
	mv	a4,a5
	lw	a5,-20(s0)
	sext.w	a4,a4
	sext.w	a5,a5
	bgt	a4,a5,.L24
	lbu	a5,-29(s0)
	sext.w	a5,a5
	lw	a3,-20(s0)
	lw	a4,-36(s0)
	mv	a2,a4
	mv	a1,a5
	lui	a5,%hi(.LC8)
	addi	a0,a5,%lo(.LC8)
	call	printf
	sb	zero,-21(s0)
.L24:
	lw	a5,-36(s0)
	sw	a5,-20(s0)
	lw	a5,-28(s0)
	addiw	a5,a5,1
	sw	a5,-28(s0)
.L22:
	lw	a5,-28(s0)
	sext.w	a4,a5
	li	a5,47
	ble	a4,a5,.L25
	lbu	a5,-21(s0)
	mv	a0,a5
	ld	ra,40(sp)
	ld	s0,32(sp)
	addi	sp,sp,48
	jr	ra
	.size	test, .-test
	.section	.rodata
	.align	3
.LC9:
	.string	"All tests passed."
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-16
	sd	ra,8(sp)
	sd	s0,0(sp)
	addi	s0,sp,16
	call	test
	mv	a5,a0
	beq	a5,zero,.L28
	lui	a5,%hi(.LC9)
	addi	a0,a5,%lo(.LC9)
	call	puts
	li	a5,0
	j	.L29
.L28:
	li	a5,1
.L29:
	mv	a0,a5
	ld	ra,8(sp)
	ld	s0,0(sp)
	addi	sp,sp,16
	jr	ra
	.size	main, .-main
	.ident	"GCC: (g1b306039a) 15.1.0"
	.section	.note.GNU-stack,"",@progbits
