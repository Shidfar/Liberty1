//
// Created by Shidfar Hodizoda on 14/04/2018.
//

#include <stdio.h>
#include "uart.h"

int main(void) {

    initialize_uart();
    stdout = &uart_output;
    stdin  = &uart_input;

    char input[100];

    while(1) {
        printf("Hello world!");
        scanf("%s", input);
        printf("You wrote %s\n", input);
    }

    return 0;
}
