//
// Created by Shidfar Hodizoda on 14/04/2018.
//

#ifndef LIBERTY1_UART_H
#define LIBERTY1_UART_H

#include <avr/io.h>
#include <stdio.h>

#define F_CPU 16000000UL
#define BAUD 9600

#include <util/setbaud.h>

void initialize_uart();
int uart_putchar(char c, FILE *stream);
int uart_getchar(FILE *stream);

FILE uart_output = FDEV_SETUP_STREAM(uart_putchar, NULL, _FDEV_SETUP_WRITE);
FILE uart_input = FDEV_SETUP_STREAM(NULL, uart_getchar, _FDEV_SETUP_READ);

#endif //LIBERTY1_UART_H
