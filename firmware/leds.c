// This is free and unencumbered software released into the public domain.
//
// Anyone is free to copy, modify, publish, use, compile, sell, or
// distribute this software, either in source code form or as a compiled
// binary, for any purpose, commercial or non-commercial, and by any
// means.

#include "firmware.h"

#define LEDS_ADDR 0x10000000

void write_led(uint32_t led)
{
	*((volatile uint32_t*)LEDS_ADDR) = led;
}

uint32_t read_led(void)
{
    return *((volatile uint32_t*)LEDS_ADDR);
}

