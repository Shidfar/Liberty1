// this has to be already defined during the make process
#ifndef __AVR_ATmega328P__
	#define __AVR_ATmega328P__
#endif

// actual baud has to be defined during the make process
#ifndef BAUD
	#define BAUD  9600 // 115200 
#endif

#include <Arduino.h>
#include <util/delay.h>
#include <avr/io.h>
#include <stdio.h>
#include <util/setbaud.h>

// Declared weak in Arduino.h to allow user redefinitions.
int atexit(void (* /*func*/ )()) { return 0; }

// Weak empty variant initialization function.
// May be redefined by variant files.
void initVariant() __attribute__((weak));
void initVariant() { }

void setupUSB() __attribute__((weak));
void setupUSB() { }
void keepalive(void);
void setup();
void loop();
void initialize_uart(void);
int uart_putchar(char, FILE *);
int uart_getchar(FILE *);

#ifdef __cplusplus
	extern "C"{
		FILE * uart_str;
	}
#endif

int main(void)
{
	init();
	initVariant();
	initialize_uart();

	#if defined(USBCON)
		USBDevice.attach();
	#endif
	
	setup();
    
	for (;;) {
		loop();
		if (serialEventRun) serialEventRun();
	}

	// NEVER LET THE APP TO RETURN.
	keepalive();
	return 0;
}

void initialize_uart(void) {
	UBRR0H = UBRRH_VALUE;
    UBRR0L = UBRRL_VALUE;

	#if USE_2X
		UCSR0A |= _BV(U2X0);
	#else
		UCSR0A &= ~(_BV(U2X0));
	#endif

    UCSR0C = _BV(UCSZ01) | _BV(UCSZ00); /* 8-bit data */
    UCSR0B = _BV(RXEN0) | _BV(TXEN0);   /* Enable RX and TX */

	uart_str = fdevopen(uart_putchar, uart_getchar);
	stdout = stdin = uart_str;
	// FILE uart_out = FDEV_SETUP_STREAM(uart_putchar, NULL, _FDEV_SETUP_WRITE);
    // FILE uart_in = FDEV_SETUP_STREAM(NULL, uart_getchar, _FDEV_SETUP_READ);
}

int uart_putchar(char c, FILE *stream) {
    if (c == '\n') {
        uart_putchar('\r', stream);
    }
    loop_until_bit_is_set(UCSR0A, UDRE0);
    UDR0 = c;
    return 0;
}

int uart_getchar(FILE *stream) {
    loop_until_bit_is_set(UCSR0A, RXC0); /* Wait until data exists. */
    return UDR0;
}

void keepalive(void) {
	while (true) {
		printf("So now I got cut loose! Footloose!");
		_delay_ms(1000);
	}
}

void setup() {
  // initialize digital pin LED_BUILTIN as an output.
  pinMode(LED_BUILTIN, OUTPUT);
  
}

// the loop function runs over and over again forever
void loop() {
  char input[100];
  printf("Hej Hej!\n");
  digitalWrite(LED_BUILTIN, HIGH);   // turn the LED on (HIGH is the voltage level)
  delay(1000);                       // wait for a second
  digitalWrite(LED_BUILTIN, LOW);    // turn the LED off by making the voltage LOW
  delay(1000);                       // wait for a second
}
