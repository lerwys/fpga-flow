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
    while (1) {
        for (i = 0, leds = 1; i < 5; ++i) {
            write_led (leds);
            leds <<= 1;
            // These are on avarage 4 instructions, each taking
            // 3-4 cycles to complete. So, divide the delay in
            // seconds by 16
            delay(SYS_CLK_HZ/5/16);
            // sleep () so your eyes can see the leds moving ...
        }
    }

    return 0;
}
