module video;

import bindbc.sdl;
import bindbc.sdl.image;

SDL_Window* window = null;
SDL_Renderer* renderer = null;

void blaster() {
    // init
    assert(SDL_Init(SDL_INIT_VIDEO) == 0);
    scope (exit)
        SDL_Quit();
    // window & render
    assert(SDL_CreateWindowAndRenderer(0, 0,
            SDL_WINDOW_SHOWN, &window, &renderer) == 0);
    assert(window !is null);
    assert(renderer !is null);
    scope (exit) {
        SDL_DestroyRenderer(renderer);
        SDL_DestroyWindow(window);
    }
    // image
    assert(IMG_Init(IMG_INIT_PNG) == IMG_INIT_PNG);
}
