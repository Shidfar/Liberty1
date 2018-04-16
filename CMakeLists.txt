cmake_minimum_required(VERSION 3.10)
project(Liberty1)

set(CMAKE_CXX_STANDARD 11)
add_definitions(-D__AVR_ATmega328P__)
set(CMAKE_CXX_COMPILER avr-g++)
set(CMAKE_C_COMPILER avr-gcc)
#include_directories(/Users/shidfar/judge-13/embedded/avr/avr/include)
include_directories(/usr/local/avr/avr/include)
include_directories(include)
include_directories(spike)
add_executable(Liberty1 src/main.cpp include/pinout.h src/liberty/Engine.cpp src/liberty/Engine.h src/common/uart.c src/common/uart.h
        spike/uart/main.c spike/uart/uart.c)