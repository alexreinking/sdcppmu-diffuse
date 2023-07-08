#include "diffuse/diffuse.h"

#include <HalideBuffer.h>

#include "reaction_diffusion_init.h"
#include "reaction_diffusion_render.h"
#include "reaction_diffusion_update.h"

#include <thread>

using namespace Halide::Runtime;

class ReactionSimulatorImpl {
    int width;
    int height;
    Buffer<float> buf1;
    Buffer<float> buf2;

public:
    ReactionSimulatorImpl(int width, int height)
        : width(width), height(height), buf1(Buffer<float>{width, height, 3}),
          buf2(Buffer<float>{width, height, 3})
    {
        halide_set_num_threads(static_cast<int>(std::thread::hardware_concurrency()));
        reaction_diffusion_init(buf1);
    }

    void update(int mouse_x, int mouse_y, int frame)
    {
        reaction_diffusion_update(buf1, mouse_x, mouse_y, frame, buf2);
    }

    void render(uint32_t *pixels, int pitch)
    {
        int stride = pitch / (int) sizeof(uint32_t);
        Buffer<uint32_t> pixel_buf(pixels, {{0, width, 1}, {0, height, stride}});
        reaction_diffusion_render(buf2, pixel_buf);
        std::swap(buf1, buf2);
    }
};

ReactionSimulator::ReactionSimulator(int width, int height)
    : impl(new ReactionSimulatorImpl(width, height))
{
}

ReactionSimulator::~ReactionSimulator()
{
    delete impl;
}

void ReactionSimulator::update(int mouse_x, int mouse_y, int frame)
{
    impl->update(mouse_x, mouse_y, frame);
}

void ReactionSimulator::render(uint32_t *pixels, int pitch)
{
    impl->render(pixels, pitch);
}
