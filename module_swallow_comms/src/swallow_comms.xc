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

void startTransactionServer(streaming chanend c, unsigned &dst, unsigned &format, unsigned &length)
{
  asm("in %3,res[%2]\n"
    "setd res[%2],%3\n"
    "out res[%2],%2\n"
    "int %0,res[%2]\n"
    "in %1,res[%2]\n"
    :"=r"(format),"=r"(length):"r"(c),"r"(dst));
  return;
}
