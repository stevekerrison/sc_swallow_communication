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

#include "swallow_comms.h"

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
