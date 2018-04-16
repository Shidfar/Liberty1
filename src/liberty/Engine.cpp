//
// Created by Shidfar Hodizoda on 14/04/2018.
//

#include "Engine.h"

namespace liberty1 {
    Engine::Engine(void (*routineCb)()) {
        initialize_uart();
        _mpRoutineCb = routineCb;
    }

    void Engine::Routine() {
        while (true) {
            if(_mpRoutineCb == nullptr) {
                break;
            }
            _mpRoutineCb();
        }
    }
}