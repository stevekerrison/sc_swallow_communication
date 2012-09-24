/*
 * swallow_comms - Channel tools for XMP16 multicore->single-core compilation
 *
 * Provides a compatibility layer when needed, some stuff for initialisation,
 * and enables hybrid streaming channels that replace the "streaming chanend"
 * concept by allowing regular channels to be temporarily used for streaming.
 * 
 * Copyright (C) 2012 Steve Kerrison <github@stevekerrison.com>
 *
 * This software is freely distributable under a derivative of the
 * University of Illinois/NCSA Open Source License posted in
 * LICENSE.txt and at <http://github.xcore.com/>
 */

.section .text

.cc_top xmp16Assert.elim, xmp16Assert
.globl xmp16Assert
.global xmp16Assert.nstackwords
.linkset xmp16Assert.nstackwords, 0
.align 4
xmp16Assert:
  ecallf r0
	retsp 0x0
.cc_bottom xmp16Assert.elim

.cc_top getChanend.elim, getChanend
.globl getChanend
.global getChanend.nstackwords
.linkset getChanend.nstackwords, 0
.align 4
getChanend:
	getr r1,2
	bf r1,retGetChanend
	setd res[r1],r0
retGetChanend:
	mov r0,r1
	retsp 0
.cc_bottom getChanend.elim

.cc_top getRemoteChanendId.elim, getRemoteChanendId
.globl getRemoteChanendId
.global getRemoteChanendId.nstackwords
.linkset getRemoteChanendId.nstackwords, 0
.align 4
getRemoteChanendId:
	getd r0,res[r0]
	retsp 0
.cc_bottom getRemoteChanendId.elim

.cc_top getLocalChanendId.elim, getLocalChanendId
.globl getLocalChanendId
.global getLocalChanendId.nstackwords
.linkset getLocalChanendId.nstackwords, 0
.align 4
getLocalChanendId:
	retsp 0
.cc_bottom getLocalChanendId.elim

.cc_top outUint.elim, outUint
.globl outUint
.global outUint.nstackwords
.linkset outUint.nstackwords, 0
.align 4
outUint:
	//bl closeChanend
//	outct res[r0],2
//	chkct res[r0],1
	out res[r0],r1
	outct res[r0],2
//	outct res[r0],1
//	outct res[r0],1
//	chkct res[r0],1
	retsp 0x0
.cc_bottom outUint.elim

.cc_top outByte.elim, outByte
.globl outByte
.global outByte.nstackwords
.linkset outByte.nstackwords, 0
.align 4
outByte:
	//bl closeChanend
//	outct res[r0],1
//	chkct res[r0],1
	outt res[r0],r1
//	outct res[r0],2
//	outct res[r0],1
//	chkct res[r0],1
	retsp 0x0
.cc_bottom outByte.elim

.cc_top inUint.elim, inUint
.globl inUint
.global inUint.nstackwords
.linkset inUint.nstackwords, 0
.align 4
inUint:
//	chkct res[r0],1
//	outct res[r0],1
	in r1,res[r0]
//	chkct res[r0],1
//	outct res[r0],1
	mov r0,r1
	retsp 0x0
.cc_bottom inUint.elim

.cc_top inByte.elim, inByte
.globl inByte
.global inByte.nstackwords
.linkset inByte.nstackwords, 0
.align 4
inByte:
//	chkct res[r0],1
//	outct res[r0],1
	int r1,res[r0]
//	chkct res[r0],1
//	outct res[r0],1
	mov r0,r1
	retsp 0x0
.cc_bottom inByte.elim

.cc_top closeChanend.elim, closeChanend
.globl closeChanend
.global closeChanend.nstackwords
.linkset closeChanend.nstackwords, 0
.align 4
/* Tear down a channel, highest channel identifier goes first */
closeChanend:
	getd r1,res[r0]
	lsu r2,r1,r0
	bt r2,closeMeSecond
	outct res[r0],1
	chkct res[r0],1
	bu closeEnd
closeMeSecond:
	chkct res[r0],1
	outct res[r0],1
closeEnd:
	retsp 0x0
.cc_bottom closeChanend.elim

.cc_top getLocalAnonChanend.elim, getLocalAnonChanend
.globl getLocalAnonChanend
.global getLocalAnonChanend.nstackwords
.linkset getLocalAnonChanend.nstackwords, 0
.align 4
getLocalAnonChanend:
	getr r0,0x2
	retsp 0x0
.cc_bottom getLocalAnonChanend.elim

