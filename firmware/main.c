// This is free and unencumbered software released into the public domain.
//
// Anyone is free to copy, modify, publish, use, compile, sell, or
// distribute this software, either in source code form or as a compiled
// binary, for any purpose, commercial or non-commercial, and by any
// means.

#include "firmware.h"

int main (void)
{
    int i;
    uint32_t leds;
    for (i = 0, leds = 0; i < 10; ++i) {
        write_led (leds);
        leds <<= 1;
    }

    return 0;
}
