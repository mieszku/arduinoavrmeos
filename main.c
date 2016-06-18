/*
 * Copyright (c) 2016 Mieszko Mazurek
 */

#include <core/panic.h>
#include <core/system.h>

int main (void)
{
	system_init ();

	/* write code here */

	thread_kill ();
}

void panic (error_t err)
{
	/* catch panic error */
}
