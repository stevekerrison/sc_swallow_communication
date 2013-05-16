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

#include <xs1.h>
#include "swallow_comms.h"

unsigned sw_nrows, sw_ncols;

#pragma unsafe arrays
unsigned _write_intercept(streaming chanend tx, char buf[], unsigned len)
{
  unsigned offset = 0, dst = 0x80010302;
  int i;
  asm("getr %0,0x2"::"r"(tx));
  while (len)
  {
    startTransactionClient(tx,dst,1,len > IO_REDIRECT_BUF ? IO_REDIRECT_BUF : len);
    for (i = 0; i < IO_REDIRECT_BUF && len; i += 1, len--)
    {
      tx <: buf[i + offset];
    }
    offset = i;
    endTransactionClient(tx);
  }
  asm("freer res[%0]"::"r"(tx));
  return 0;
}

void io_redirect(void)
{
  unsigned tgt,rpl;
  unsigned instr;
  int offset;
  asm("ldap r11,_write\n"
    "mov %0,r11\n"
    "ldap r11,_write_intercept\n"
    "mov %1,r11\n"
    :"=r"(tgt),"=r"(rpl)::"r11");
  offset = rpl - tgt - 4;
  if (offset > 0)
  {
    offset >>= 1;
    instr = 0xf0007300;
  }
  else
  {
    offset = -offset;
    offset >>= 1;
    instr = 0xf0007700;
  }
  instr |=  ((offset << 10) & 0x03ff0000) | (offset & 0x3f);
  asm("st16 %0,%1[%2]\n"
    "st16 %3,%1[%4]\n"::"r"(instr >> 16),"r"(tgt),"r"(0),"r"(instr),"r"(1));
  return;
}


void fixupChanNode(chanend c)
{
  unsigned oldid = getLocalChanendId(c);
  unsigned newid = get_local_tile_id();
  if (oldid >> 16 != newid >> 16)
  {
    unsigned dst;
    asm("getd %0,res[%1]":"=r"(dst):"r"(c));
    if (dst >> 16 == oldid >> 16) //Only fixup local chanends
    {
      dst = (dst & 0xffff) | (newid & 0xffff0000);
      asm("setd res[%0],%1"::"r"(c),"r"(dst));
    }
  }
}

void fixupStreamingChanNode(streaming chanend c)
{
  unsigned oldid = getLocalStreamingChanendId(c);
  unsigned newid = get_local_tile_id();
  if (oldid >> 16 != newid >> 16)
  {
    unsigned dst;
    asm("getd %0,res[%1]":"=r"(dst):"r"(c));
    if (dst >> 16 == oldid >> 16) //Only fixup local chanends
    {
      dst = (dst & 0xffff) | (newid & 0xffff0000);
      asm("setd res[%0],%1"::"r"(c),"r"(dst));
    }
  }
}
