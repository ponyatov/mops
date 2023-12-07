module video;

import std.stdio;
import std.conv;

import bindbc.sdl;
import bindbc.sdl.image;

SDL_Window* window = null;
SDL_Renderer* renderer = null;
SDL_Surface* logo = null;
SDL_Texture* logo_t = null;
SDL_Rect logo_rect;
SDL_DisplayMode display_mode;
int W = 0, H = 0;

SDL_Event event;

void init() {
    assert(SDL_Init(SDL_INIT_VIDEO) == 0);
    assert(SDL_GetCurrentDisplayMode(0, &display_mode) == 0);
    W = display_mode.w;
    H = display_mode.h;
    // 
    mouse;
    winrender;
    image;
    mklogo;
}

void mouse() {
    SDL_ShowCursor(SDL_DISABLE);
}

void winrender() {
    assert(SDL_CreateWindowAndRenderer(W, H,
            SDL_WINDOW_SHOWN | SDL_WINDOW_FULLSCREEN_DESKTOP | SDL_WINDOW_BORDERLESS,
            &window, &renderer) == 0);
    assert(window !is null);
    assert(renderer !is null);
}

void image() {
    assert(IMG_Init(IMG_INIT_PNG) == IMG_INIT_PNG);
}

void mklogo() {
    logo = IMG_Load("static/logo.png");
    assert(logo !is null);
    // 
    logo_t = SDL_CreateTextureFromSurface(renderer, logo);
    assert(logo_t !is null);
    // 
    logo_rect = SDL_Rect(0x11, 0x11, logo.w, logo.h);
}

void fini() {
    SDL_FreeSurface(logo);
    SDL_DestroyTexture(logo_t);
    IMG_Quit();
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();
}

void draw() {
    SDL_SetRenderDrawColor(renderer, 0x11, 0x11, 0x11, 0x00);
    SDL_RenderClear(renderer);
    SDL_RenderCopy(renderer, logo_t, null, &logo_rect);
    SDL_RenderPresent(renderer);
}

void loop() {
    init;
    bool quit = false;
    while (!quit) {
        // SDL_Delay(222);
        draw;
        SDL_PumpEvents;
        while (SDL_PollEvent(&event)) {
            switch (event.type) {
            case SDL_QUIT:
            case SDL_KEYDOWN:
            case SDL_MOUSEBUTTONDOWN:
                quit = true;
                break;
            default:
            }
        }
    }

}
