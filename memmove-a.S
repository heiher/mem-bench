/* SPDX-License-Identifier: GPL-2.0 */
/*
 * Copyright (C) 2020-2021 Loongson Technology Corporation Limited
 */

#include "regdef.h"

	.text

/*
 * void *__rmemcpy_fast(void *dst, const void *src, size_t n)
 *
 * a0: dst
 * a1: src
 * a2: n
 */
	.global memmove
memmove:
	sltui	t0, a2, 9
	bnez	t0, __memcpy_small

	add.d	a3, a1, a2
	add.d	a2, a0, a2
	ld.d	a6, a1, 0
	ld.d	a7, a3, -8

	/* align up destination address */
	andi	t1, a2, 7
	sub.d	a3, a3, t1
	sub.d	a5, a2, t1

	addi.d	a4, a1, 64
	bgeu	a4, a3, .Llt64

	/* copy 64 bytes at a time */
.Lloop64:
	ld.d	t0, a3, -8
	ld.d	t1, a3, -16
	ld.d	t2, a3, -24
	ld.d	t3, a3, -32
	ld.d	t4, a3, -40
	ld.d	t5, a3, -48
	ld.d	t6, a3, -56
	ld.d	t7, a3, -64
	addi.d	a3, a3, -64
	st.d	t0, a5, -8
	st.d	t1, a5, -16
	st.d	t2, a5, -24
	st.d	t3, a5, -32
	st.d	t4, a5, -40
	st.d	t5, a5, -48
	st.d	t6, a5, -56
	st.d	t7, a5, -64
	addi.d	a5, a5, -64
	bltu	a4, a3, .Lloop64

	/* copy the remaining bytes */
.Llt64:
	addi.d	a4, a1, 32
	bgeu	a4, a3, .Llt32
	ld.d	t0, a3, -8
	ld.d	t1, a3, -16
	ld.d	t2, a3, -24
	ld.d	t3, a3, -32
	addi.d	a3, a3, -32
	st.d	t0, a5, -8
	st.d	t1, a5, -16
	st.d	t2, a5, -24
	st.d	t3, a5, -32
	addi.d	a5, a5, -32

.Llt32:
	addi.d	a4, a1, 16
	bgeu	a4, a3, .Llt16
	ld.d	t0, a3, -8
	ld.d	t1, a3, -16
	addi.d	a3, a3, -16
	st.d	t0, a5, -8
	st.d	t1, a5, -16
	addi.d	a5, a5, -16

.Llt16:
	addi.d	a4, a1, 8
	bgeu	a4, a3, .Llt8
	ld.d	t0, a3, -8
	st.d	t0, a5, -8

.Llt8:
	st.d	a6, a0, 0
	st.d	a7, a2, -8

	/* return */
	jr	ra
