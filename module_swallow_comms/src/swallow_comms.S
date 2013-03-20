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
.global xmp16Assert.maxtimers
.linkset xmp16Assert.maxtimers, 0
.global xmp16Assert.maxchanends
.linkset xmp16Assert.maxchanends, 0
.global xmp16Assert.maxthreads
.linkset xmp16Assert.maxthreads, 1
.align 4
xmp16Assert:
  ecallf r0
	retsp 0x0
.cc_bottom xmp16Assert.elim

.cc_top getChanend.elim, getChanend
.globl getChanend
.global getChanend.nstackwords
.linkset getChanend.nstackwords, 0
.global getChanend.maxtimers
.linkset getChanend.maxtimers, 0
.global getChanend.maxchanends
.linkset getChanend.maxchanends, 1
.global getChanend.maxthreads
.linkset getChanend.maxthreads, 1
.align 4
getChanend:
	getr r1,2
	bf r1,retGetChanend
	setd res[r1],r0
retGetChanend:
	mov r0,r1
	retsp 0
.cc_bottom getChanend.elim

.cc_top setDestination.elim, setDestination
.globl setDestination
.global setDestination.nstackwords
.linkset setDestination.nstackwords, 0
.global setDestination.maxtimers
.linkset setDestination.maxtimers, 0
.global setDestination.maxchanends
.linkset setDestination.maxchanends, 0
.global setDestination.maxthreads
.linkset setDestination.maxthreads, 1
.align 4
setDestination:
	setd res[r0],r1
	retsp 0
.cc_bottom setDestination.elim

.cc_top getRemoteChanendId.elim, getRemoteChanendId
.globl getRemoteChanendId
.global getRemoteChanendId.nstackwords
.linkset getRemoteChanendId.nstackwords, 0
.global getRemoteChanendId.maxtimers
.linkset getRemoteChanendId.maxtimers, 0
.global getRemoteChanendId.maxchanends
.linkset getRemoteChanendId.maxchanends, 0
.global getRemoteChanendId.maxthreads
.linkset getRemoteChanendId.maxthreads, 1
.align 4
getRemoteChanendId:
	getd r0,res[r0]
	retsp 0
.cc_bottom getRemoteChanendId.elim

.cc_top getRemoteStreamingChanendId.elim, getRemoteStreamingChanendId
.globl getRemoteStreamingChanendId
.global getRemoteStreamingChanendId.nstackwords
.linkset getRemoteStreamingChanendId.nstackwords, 0
.global getRemoteStreamingChanendId.maxtimers
.linkset getRemoteStreamingChanendId.maxtimers, 0
.global getRemoteStreamingChanendId.maxchanends
.linkset getRemoteStreamingChanendId.maxchanends, 0
.global getRemoteStreamingChanendId.maxthreads
.linkset getRemoteStreamingChanendId.maxthreads, 1
.align 4
getRemoteStreamingChanendId:
	getd r0,res[r0]
	retsp 0
.cc_bottom getRemoteStreamingChanendId.elim

.cc_top getLocalChanendId.elim, getLocalChanendId
.globl getLocalChanendId
.global getLocalChanendId.nstackwords
.linkset getLocalChanendId.nstackwords, 0
.global getLocalChanendId.maxtimers
.linkset getLocalChanendId.maxtimers, 0
.global getLocalChanendId.maxchanends
.linkset getLocalChanendId.maxchanends, 0
.global getLocalChanendId.maxthreads
.linkset getLocalChanendId.maxthreads, 1
.align 4
getLocalChanendId:
	retsp 0
.cc_bottom getLocalChanendId.elim

.cc_top getLocalStreamingChanendId.elim, getLocalStreamingChanendId
.globl getLocalStreamingChanendId
.global getLocalStreamingChanendId.nstackwords
.linkset getLocalStreamingChanendId.nstackwords, 0
.global getLocalStreamingChanendId.maxtimers
.linkset getLocalStreamingChanendId.maxtimers, 0
.global getLocalStreamingChanendId.maxchanends
.linkset getLocalStreamingChanendId.maxchanends, 0
.global getLocalStreamingChanendId.maxthreads
.linkset getLocalStreamingChanendId.maxthreads, 1
.align 4
getLocalStreamingChanendId:
	retsp 0
.cc_bottom getLocalStreamingChanendId.elim

.cc_top outUint.elim, outUint
.globl outUint
.global outUint.nstackwords
.linkset outUint.nstackwords, 0
.global outUint.maxtimers
.linkset outUint.maxtimers, 0
.global outUint.maxchanends
.linkset outUint.maxchanends, 0
.global outUint.maxthreads
.linkset outUint.maxthreads, 1
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
.global outByte.maxtimers
.linkset outByte.maxtimers, 0
.global outByte.maxchanends
.linkset outByte.maxchanends, 0
.global outByte.maxthreads
.linkset outByte.maxthreads, 1
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
.global inUint.maxtimers
.linkset inUint.maxtimers, 0
.global inUint.maxchanends
.linkset inUint.maxchanends, 0
.global inUint.maxthreads
.linkset inUint.maxthreads, 1
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
.global inByte.maxtimers
.linkset inByte.maxtimers, 0
.global inByte.maxchanends
.linkset inByte.maxchanends, 0
.global inByte.maxthreads
.linkset inByte.maxthreads, 1
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
.global closeChanend.maxtimers
.linkset closeChanend.maxtimers, 0
.global closeChanend.maxchanends
.linkset closeChanend.maxchanends, 0
.global closeChanend.maxthreads
.linkset closeChanend.maxthreads, 1
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
.global getLocalAnonChanend.maxtimers
.linkset getLocalAnonChanend.maxtimers, 0
.global getLocalAnonChanend.maxchanends
.linkset getLocalAnonChanend.maxchanends, 0
.global getLocalAnonChanend.maxthreads
.linkset getLocalAnonChanend.maxthreads, 1
.align 4
getLocalAnonChanend:
	getr r0,0x2
	retsp 0x0
.cc_bottom getLocalAnonChanend.elim

.cc_top startTransactionClient.elim, startTransactionClient
.globl startTransactionClient
.global startTransactionClient.nstackwords
.linkset startTransactionClient.nstackwords, 0
.global startTransactionClient.maxtimers
.linkset startTransactionClient.maxtimers, 0
.global startTransactionClient.maxchanends
.linkset startTransactionClient.maxchanends, 0
.global startTransactionClient.maxthreads
.linkset startTransactionClient.maxthreads, 1
.align 4
startTransactionClient:
  entsp 0x1
	stw r4,sp[0]
	setd res[r0],r1
	out res[r0],r0
/*	testct r4,res[r0]
	bt r4,transactionClientShouldBackoff*/
	in r4,res[r0]
	eq r1,r4,r1
	ecallf r1
	outt res[r0],r2
	out res[r0],r3
	ldw r4,sp[0]
	ldc r0,1
	retsp 0x1
transactionClientShouldBackoff:
  chkct res[r0],0x1
  outct res[r0],0x1
	ldw r4,sp[0]
	ldc r0,0
	retsp 0x1
.cc_bottom startTransactionClient.elim

.cc_top pauseTransactionClient.elim, pauseTransactionClient
.globl pauseTransactionClient
.global pauseTransactionClient.nstackwords
.linkset pauseTransactionClient.nstackwords, 0
.global pauseTransactionClient.maxtimers
.linkset pauseTransactionClient.maxtimers, 0
.global pauseTransactionClient.maxchanends
.linkset pauseTransactionClient.maxchanends, 0
.global pauseTransactionClient.maxthreads
.linkset pauseTransactionClient.maxthreads, 1
.align 4
pauseTransactionClient:
	outct res[r0],0x1
	chkct res[r0],0x1
	retsp 0x0
.cc_bottom pauseTransactionClient.elim

.cc_top resumeTransactionClient.elim, resumeTransactionClient
.globl resumeTransactionClient
.global resumeTransactionClient.nstackwords
.linkset resumeTransactionClient.nstackwords, 0
.global resumeTransactionClient.maxtimers
.linkset resumeTransactionClient.maxtimers, 0
.global resumeTransactionClient.maxchanends
.linkset resumeTransactionClient.maxchanends, 0
.global resumeTransactionClient.maxthreads
.linkset resumeTransactionClient.maxthreads, 1
.align 4
resumeTransactionClient:
	setd res[r0],r1
	out res[r0],r0
	in r2,res[r0]
	eq r1,r2,r1
	ecallf r1
	retsp 0x0
.cc_bottom resumeTransactionClient.elim

.cc_top endTransactionClient.elim, endTransactionClient
.globl endTransactionClient
.global endTransactionClient.nstackwords
.linkset endTransactionClient.nstackwords, 0
.global endTransactionClient.maxtimers
.linkset endTransactionClient.maxtimers, 0
.global endTransactionClient.maxchanends
.linkset endTransactionClient.maxchanends, 0
.global endTransactionClient.maxthreads
.linkset endTransactionClient.maxthreads, 1
.align 4
endTransactionClient:
	outct res[r0],0x1
	chkct res[r0],0x1
	retsp 0x0
.cc_bottom endTransactionClient.elim

.cc_top startTransactionServer.elim, startTransactionServer
.globl startTransactionServer
.global startTransactionServer.nstackwords
.linkset startTransactionServer.nstackwords, 0
.global startTransactionServer.maxtimers
.linkset startTransactionServer.maxtimers, 0
.global startTransactionServer.maxchanstarts
.linkset startTransactionServer.maxchanstarts, 0
.global startTransactionServer.maxthreads
.linkset startTransactionServer.maxthreads, 1
.align 4
startTransactionServer:
  entsp 0x1
  stw r4,sp[0]
  in r4,res[r0]
  setd res[r0],r4
  out res[r0],r0
  stw r4,r1[0]
  int r4,res[r0]
  stw r4,r2[0]
  in r4,res[r0]
  stw r4,r3[0]
  ldw r4,sp[0]
	retsp 0x1
.cc_bottom startTransactionServer.elim


.cc_top endTransactionServer.elim, endTransactionServer
.globl endTransactionServer
.global endTransactionServer.nstackwords
.linkset endTransactionServer.nstackwords, 0
.global endTransactionServer.maxtimers
.linkset endTransactionServer.maxtimers, 0
.global endTransactionServer.maxchanends
.linkset endTransactionServer.maxchanends, 0
.global endTransactionServer.maxthreads
.linkset endTransactionServer.maxthreads, 1
.align 4
endTransactionServer:
	chkct res[r0],0x1
	outct res[r0],0x1
	retsp 0x0
.cc_bottom endTransactionServer.elim

