//#include <iostream>
#include "liberty/Engine.h"

void routine() {
//    char input;
//    puts("Hello world!");
//    input = static_cast<char>(getchar());
//    printf("You wrote %c\n", input);
}

int main() {
//    std::cout << "Hello, World!" << std::endl;
    auto engine = liberty1::Engine(routine);
    engine.Routine();
}
