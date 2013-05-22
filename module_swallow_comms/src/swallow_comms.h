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

#ifndef _MCSC_CHAN_H
#define _MCSC_CHAN_H

/* Switch registers... */
/* XLINK_X_STW: Speed Timing and Width */
#define XLINK_A_STW XS1_L_SSWITCH_XLINK_2_NUM
#define XLINK_B_STW XS1_L_SSWITCH_XLINK_3_NUM
#define XLINK_C_STW XS1_L_SSWITCH_XLINK_0_NUM
#define XLINK_D_STW XS1_L_SSWITCH_XLINK_1_NUM
#define XLINK_E_STW XS1_L_SSWITCH_XLINK_6_NUM
#define XLINK_F_STW XS1_L_SSWITCH_XLINK_7_NUM
#define XLINK_G_STW XS1_L_SSWITCH_XLINK_4_NUM
#define XLINK_H_STW XS1_L_SSWITCH_XLINK_5_NUM
/* XLINK_X_DN: Direction and Network */
#define XLINK_A_DN XS1_L_SSWITCH_SLINK_2_NUM
#define XLINK_B_DN XS1_L_SSWITCH_SLINK_3_NUM
#define XLINK_C_DN XS1_L_SSWITCH_SLINK_0_NUM
#define XLINK_D_DN XS1_L_SSWITCH_SLINK_1_NUM
#define XLINK_E_DN XS1_L_SSWITCH_SLINK_6_NUM
#define XLINK_F_DN XS1_L_SSWITCH_SLINK_7_NUM
#define XLINK_G_DN XS1_L_SSWITCH_SLINK_4_NUM
#define XLINK_H_DN XS1_L_SSWITCH_SLINK_5_NUM

#define COUNT_FROM_BITS(x)        (1 << x)
#define MASK_FROM_BITS(x)         (COUNT_FROM_BITS(x) - 1)
#define SWXLB_PBITS               1
#define SWXLB_PPOS                0
#define SWXLB_LBITS               1
#define SWXLB_LPOS                (SWXLB_PPOS + SWXLB_PBITS)
#define SWXLB_HBITS               6
#define SWXLB_HPOS                (SWXLB_LPOS + SWXLB_LBITS)
#define SWXLB_VBITS               7
#define SWXLB_VPOS                (SWXLB_HPOS + SWXLB_HBITS)
#define SWXLB_XSCOPE_BITS         1
#define SWXLB_XSCOPE_POS          (SWXLB_VPOS + SWXLB_VBITS)
#define SWXLB_CHIPS_W             2
#define SWXLB_CHIPS_H             4
#define SWXLB_CORES_CHIP          2
#define SWXLB_CORES_BOARD         (SWXLB_CHIPS_W * SWXLB_CHIPS_H * SWXLB_CORES_CHIP)
#define SWXLB_MAX_CORES           COUNT_FROM_BITS(SWXLB_LBITS + SWXLB_HBITS + SWXLB_VBITS)
#define SWXLB_BOOT_ID             0x8001

/* Names change, behaviour doesn't */
#define swallowAssert xmp16Assert

#ifdef MCMAIN
	/* Redefine chanends, because we don't use the XC channel model in mains */
	#define chanend unsigned
#endif

extern unsigned sw_nrows, sw_ncols;

/* We can't have streaming chanends because it would make MC-SC conversion too
 * complicated right now, so instead we provide these helpers. A block of
 * stream{Out,In}{Byte,Word} calls should be surrounded by open{In,Out}Stream
 * and close{In,Out}Stream. Bi-directional streams should be opened and closed
 * in oen direction before the other (a closeOut should be matched by a closeIn
 * at the other end of the channel). */
#define openOutStream(c)	//Routes open themselves when data goes through
#define streamOutByte(c,b) 	asm("outt res[%0],%1"::"r"(c),"r"(b));
#define streamOutWord(c,w)	asm("out res[%0],%1"::"r"(c),"r"(w));
#define closeOutStream(c)	asm("outct res[%0],1\n" \
	"chkct res[%0],1" :: "r"(c));
#define openInStream(c)		//Routes open themselves when data goes through
#define streamInByte(c,b)	asm("int %0,res[%1]":"=r"(b):"r"(c));
#define streamInWord(c,w)	asm("in %0,res[%1]":"=r"(w):"r"(c));
#define closeInStream(c)	asm("chkct res[%0],1\n" \
	"outct res[%0],1" :: "r"(c));
#define streamSetDestination(c,d) asm("setd res[%0],%1"::"r"(c),"r"(d))
#define swallow_lookup(row,col)  ((row << SWXLB_VPOS) | (col << SWXLB_LPOS))
#define swallow_id(ref) swallow_lookup((ref)/(sw_ncols),(ref)%(sw_ncols))
#define swallow_cvt_chanend(ce) ((swallow_id(ce >> 16) << 16) | (ce & 0xffff))
#define IO_REDIRECT_BUF 128

#ifdef __XC__

#ifndef MCMAIN
int startTransactionClient(streaming chanend c, unsigned dst, char format, unsigned length);
void endTransactionClient(streaming chanend c);
#pragma select handler
void startTransactionServer(streaming chanend c, unsigned &dst, unsigned &format, unsigned &length);
void endTransactionServer(streaming chanend c);
void fixupStreamingChanNode(streaming chanend c);


unsigned getLocalStreamingChanendId(streaming chanend c);
unsigned getRemoteStreamingChanendId(streaming chanend c);
#endif
#endif //__XC__

void io_redirect(void);
void xmp16Assert(unsigned assertion);
unsigned getChanend(unsigned dst);
void setDestination(chanend c, unsigned dst);
unsigned getLocalAnonChanend();
unsigned write_sswitch_reg_no_ack_clean(unsigned node, unsigned reg, unsigned val);
unsigned write_sswitch_reg_clean(unsigned node, unsigned reg, unsigned val);
void closeChanend(chanend c);
void freeChanend(unsigned c);
unsigned inUint(unsigned c);
void outUint(unsigned c, unsigned val);
unsigned char inByte(unsigned c);
void outByte(unsigned c, unsigned char val);
void ledOut(unsigned v);
unsigned getRemoteChanendId(chanend c);
unsigned getLocalChanendId(chanend c);
int _write_intercept_asm(unsigned notused, char buf[], unsigned len);

#endif //_MCSC_CHAN_H
