#include <SDL.h>
#include <thread>

#ifdef __EMSCRIPTEN__
#include <emscripten.h>
#endif

#include "diffuse/diffuse.h"

constexpr int WIDTH = 640;
constexpr int HEIGHT = 480;

struct Context {
    bool running = true;
    int frame = 0;
    SDL_Renderer *renderer = nullptr;
    SDL_Texture *tex = nullptr;
    ReactionSimulator *sim = nullptr;
};

void render_frame(void *arg_ctx)
{
    Context *ctx = static_cast<Context *>(ctx);

#ifndef __EMSCRIPTEN__
    SDL_Event e;
    while (SDL_PollEvent(&e) != 0) {
        if (e.type == SDL_QUIT) {
            ctx->running = false;
            return;
        }
    }
#endif

    int mx = WIDTH / 2;
    int my = HEIGHT / 2;
    SDL_GetMouseState(&mx, &my);

    ctx->sim->update(mx, my, ctx->frame++);

    uint32_t *pixels;
    int pitch;
    SDL_LockTexture(ctx->tex, nullptr, (void **) &pixels, &pitch);
    ctx->sim->render(pixels, pitch);
    SDL_UnlockTexture(ctx->tex);

    SDL_RenderClear(ctx->renderer);
    SDL_RenderCopy(ctx->renderer, ctx->tex, nullptr, nullptr);
    SDL_RenderPresent(ctx->renderer);
}

int main(int argc, char *argv[])
{
    // SDL needs main() to have this signature.
    (void) argc;
    (void) argv;

    SDL_Init(SDL_INIT_VIDEO);
    SDL_Window *window = SDL_CreateWindow("Diffuse", SDL_WINDOWPOS_CENTERED,
                                          SDL_WINDOWPOS_CENTERED, WIDTH, HEIGHT, 0);

    Context ctx;
    ctx.renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_PRESENTVSYNC);
    ctx.tex = SDL_CreateTexture(ctx.renderer, SDL_PIXELFORMAT_ARGB8888,
                                SDL_TEXTUREACCESS_STREAMING, WIDTH, HEIGHT);

    ReactionSimulator sim(WIDTH, HEIGHT);
    ctx.sim = &sim;

#ifdef __EMSCRIPTEN__
    emscripten_set_main_loop_arg(render_frame, &ctx, -1 /* unlocked fps */,
                                 1 /* simulate infinite loop*/);
#else
    while (ctx->running) {
        render_frame((void *) &ctx);
    }
#endif

    SDL_DestroyTexture(ctx.tex);
    SDL_DestroyRenderer(ctx.renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();

    return EXIT_SUCCESS;
}
