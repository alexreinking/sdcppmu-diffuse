#include <SDL.h>
#include <thread>

#include "diffuse/diffuse.h"

int main(int argc, char *argv[])
{
    constexpr int WIDTH = 640;
    constexpr int HEIGHT = 480;

    SDL_Init(SDL_INIT_VIDEO);

    SDL_Window *window = SDL_CreateWindow("Halide demo", SDL_WINDOWPOS_CENTERED,
                                          SDL_WINDOWPOS_CENTERED, WIDTH, HEIGHT, 0);
    SDL_Renderer *renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_PRESENTVSYNC);
    SDL_Texture *tex = SDL_CreateTexture(renderer, SDL_PIXELFORMAT_ARGB8888,
                                         SDL_TEXTUREACCESS_STREAMING, WIDTH, HEIGHT);

    ReactionSimulator sim(WIDTH, HEIGHT);

    // Lambda to replace goto with return-from-loop
    [&]() {
        for (int frame = 0;; frame++) {
            SDL_Event e;
            while (SDL_PollEvent(&e) != 0) {
                if (e.type == SDL_QUIT) {
                    return;
                }
            }

            int mx = WIDTH / 2;
            int my = HEIGHT / 2;
            SDL_GetMouseState(&mx, &my);

            sim.update(mx, my, frame);

            uint32_t *pixels;
            int pitch;
            SDL_LockTexture(tex, nullptr, (void **) &pixels, &pitch);
            sim.render(pixels, pitch);
            SDL_UnlockTexture(tex);

            SDL_RenderClear(renderer);
            SDL_RenderCopy(renderer, tex, nullptr, nullptr);
            SDL_RenderPresent(renderer);
        }
    }();

    SDL_DestroyTexture(tex);
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();

    return EXIT_SUCCESS;
}
