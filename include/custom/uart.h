
//
// Created by Shidfar Hodizoda on 14/04/2018.
//

#ifndef LIBERTY1_UART_H
    #define LIBERTY1_UART_H

    void initialize_uart(void);
    int uart_putchar(char c, FILE *stream);
    int uart_getchar(FILE *stream);

    FILE uart_out = FDEV_SETUP_STREAM(uart_putchar, NULL, _FDEV_SETUP_WRITE);
    FILE uart_in = FDEV_SETUP_STREAM(NULL, uart_getchar, _FDEV_SETUP_READ);

#endif //LIBERTY1_UART_H
