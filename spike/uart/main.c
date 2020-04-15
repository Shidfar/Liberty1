#ifndef __AVR_ATmega328P__
    #define __AVR_ATmega328P__
#endif
#define F_CPU 16000000UL
#define BAUD  9600// 115200


#include <avr/io.h>
#include <stdio.h>

#include "uart.h"
#include <util/delay.h>
// #include <Arduino.h>

void keepalive(void);

// int atexit(void (* /*func*/ )()) { return 0; }

// void initVariant() __attribute__((weak));
// void initVariant() { }

// void setupUSB() __attribute__((weak));
// void setupUSB() { }

int main(void) {

    // init();

    // initVariant();

    // #if defined(USBCON)
    //     USBDevice.attach();
    // #endif


    initialize_uart();
    stdout = &uart_out;
    stdin  = &uart_in;

    char input[100];

    // pinMode(13, OUTPUT);
    // bool led_switch = 1;
    while(1) {
        printf("Hej Hej!\n");
        // scanf("%s", input);
        // printf("You wrote %s\n", input);
        _delay_ms(1500);
        // digitalWrite(13, led_switch);
        // led_switch = !led_switch;
    }

    keepalive();
    return 0;
}


void keepalive(void) {
    while(1) _delay_ms(1000);
}
