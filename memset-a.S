/* SPDX-License-Identifier: GPL-2.0 */
/*
 * Copyright (C) 2020-2021 Loongson Technology Corporation Limited
 */

#include "regdef.h"

	.text

.macro fill_to_64 r0
	bstrins.d \r0, \r0, 15, 8
	bstrins.d \r0, \r0, 31, 16
	bstrins.d \r0, \r0, 63, 32
.endm

/*
 * void *__memset_fast(void *s, int c, size_t n)
 *
 * a0: s
 * a1: c
 * a2: n
 */
	.global memset
memset:
	/* fill a1 to 64 bits */
	fill_to_64 a1

	sltui	t0, a2, 9
	bnez	t0, .Lsmall

	add.d	a2, a0, a2
	st.d	a1, a0, 0

	/* align up address */
	andi	t1, a0, 7
	sub.d	a3, a0, t1
	addi.d	a3, a3, 8

	addi.d	a4, a2, -64
	bgeu	a3, a4, .Llt64

	/* set 64 bytes at a time */
.Lloop64:
	st.d	a1, a3, 0
	st.d	a1, a3, 8
	st.d	a1, a3, 16
	st.d	a1, a3, 24
	st.d	a1, a3, 32
	st.d	a1, a3, 40
	st.d	a1, a3, 48
	st.d	a1, a3, 56
	addi.d	a3, a3, 64
	bltu	a3, a4, .Lloop64

	/* set the remaining bytes */
.Llt64:
	addi.d	a4, a2, -32
	bgeu	a3, a4, .Llt32
	st.d	a1, a3, 0
	st.d	a1, a3, 8
	st.d	a1, a3, 16
	st.d	a1, a3, 24
	addi.d	a3, a3, 32

.Llt32:
	addi.d	a4, a2, -16
	bgeu	a3, a4, .Llt16
	st.d	a1, a3, 0
	st.d	a1, a3, 8
	addi.d	a3, a3, 16

.Llt16:
	addi.d	a4, a2, -8
	bgeu	a3, a4, .Llt8
	st.d	a1, a3, 0

.Llt8:
	st.d	a1, a2, -8

	/* return */
	jr	ra

	.align	4
.Lsmall:
	pcaddi	t0, 4
	slli.d	a2, a2, 4
	add.d	t0, t0, a2
	jr	t0

	.align	4
0:	jr	ra

	.align	4
1:	st.b	a1, a0, 0
	jr	ra

	.align	4
2:	st.h	a1, a0, 0
	jr	ra

	.align	4
3:	st.h	a1, a0, 0
	st.b	a1, a0, 2
	jr	ra

	.align	4
4:	st.w	a1, a0, 0
	jr	ra

	.align	4
5:	st.w	a1, a0, 0
	st.b	a1, a0, 4
	jr	ra

	.align	4
6:	st.w	a1, a0, 0
	st.h	a1, a0, 4
	jr	ra

	.align	4
7:	st.w	a1, a0, 0
	st.w	a1, a0, 3
	jr	ra

	.align	4
8:	st.d	a1, a0, 0
	jr	ra
