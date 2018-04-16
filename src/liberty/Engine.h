//
// Created by Shidfar Hodizoda on 14/04/2018.
//

#ifndef LIBERTY1_ENGINE_H
#define LIBERTY1_ENGINE_H

extern "C" {
#include "../common/uart.h"
}

namespace liberty1 {
    class Engine {
    public:
        Engine(void (*routineCb)());
        void Routine();
    private:
        void (*_mpRoutineCb)();
    };
}


#endif //LIBERTY1_ENGINE_H
