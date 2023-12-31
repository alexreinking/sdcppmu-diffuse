#ifndef DIFFUSE_H
#define DIFFUSE_H

#include <cstdint>

#include "diffuse/export.h"

class ReactionSimulatorImpl;

class DIFFUSE_EXPORT ReactionSimulator {
    ReactionSimulatorImpl *impl;

public:
    ReactionSimulator(int width, int height);

    ~ReactionSimulator();

    void update(int mouse_x, int mouse_y, int frame);

    void render(uint32_t *pixels, int pitch);
};

#endif  // DIFFUSE_H
