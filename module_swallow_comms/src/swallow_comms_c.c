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
#include <xccompat.h>
#include "swallow_comms.h"

/* Something weird happens with channel allocation here */
unsigned write_sswitch_reg_no_ack_clean(unsigned node, unsigned reg, unsigned val)
{
	unsigned ret = 0, c = getLocalAnonChanend(), d;
	freeChanend(c);
	ret = write_sswitch_reg_no_ack(node, reg, val);
	d = getLocalAnonChanend();
	if (d != c)
	{
		freeChanend(c);
	}
	freeChanend(d);
	return ret;
}

/* Something weird happens with channel allocation here*/
unsigned write_sswitch_reg_clean(unsigned node, unsigned reg, unsigned val)
{
	unsigned ret = 0, c = getLocalAnonChanend(), d;
	freeChanend(c);
	ret = write_sswitch_reg(node, reg, val);
	d = getLocalAnonChanend();
	if (d != c)
	{
		freeChanend(c);
	}
	freeChanend(d);
	return ret;
}

void freeChanend(unsigned c)
{
  if (c)
  {
	  asm("freer res[%0]"::"r"(c));
	}
}
