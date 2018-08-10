// This is free and unencumbered software released into the public domain.
//
// Anyone is free to copy, modify, publish, use, compile, sell, or
// distribute this software, either in source code form or as a compiled
// binary, for any purpose, commercial or non-commercial, and by any
// means.

#ifndef FIRMWARE_H
#define FIRMWARE_H

#include <stdint.h>
#include <stdbool.h>

#define SYS_CLK_HZ 100000000

// print.c
void print_chr(char ch);
void print_str(const char *p);
void print_dec(unsigned int val);
void print_hex(unsigned int val, int digits);

// delay.c
int delay(int x);

// leds.c
void write_led(uint32_t led);
uint32_t read_led(void);

#endif
