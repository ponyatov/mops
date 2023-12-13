module video;

import std.stdio;
import std.conv;
import std.datetime;
import std.string;
import std.format;

import bindbc.sdl;
import bindbc.sdl.image;
import bindbc.sdl.ttf;

SDL_Window* window = null;
SDL_Renderer* renderer = null;
SDL_DisplayMode display_mode;
int W = 0, H = 0;

version (HasLogo) {
    SDL_Surface* logo = null;
    SDL_Texture* logo_t = null;
    SDL_Rect logo_rect;
}

SDL_Event event;

const(char)* mono = "/usr/share/fonts/truetype/noto/NotoMono-Regular.ttf";
TTF_Font* font = null;

void ldfont() {
    TTF_Init;
    font = TTF_OpenFont(mono, H / 22);
    if (font is null)
        writeln(to!string(SDL_GetError));
}

void drawtime() {
    SDL_Color foreground = {0x00, 0x77, 0x77};
    auto n = Clock.currTime();
    auto now = format("%2u.%s.%4u %s %2u:%02u:%02u", n.day,
            n.month, n.year, n.dayOfWeek, n.hour, n.minute, n.second).toStringz;
    SDL_Surface* text_surf = TTF_RenderText_Solid(font, now, foreground);
    assert(text_surf !is null);
    SDL_Texture* text_t = SDL_CreateTextureFromSurface(renderer, text_surf);
    assert(text_t !is null);
    // 
    SDL_Rect dest;
    dest.x = W / 2 - text_surf.w / 2;
    dest.y = H / 2 - text_surf.h / 2;
    dest.w = text_surf.w;
    dest.h = text_surf.h;
    SDL_RenderCopy(renderer, text_t, null, &dest);
    // 
    SDL_DestroyTexture(text_t);
    SDL_FreeSurface(text_surf);

}

void init() {
    assert(SDL_Init(SDL_INIT_VIDEO) == 0);
    assert(SDL_GetCurrentDisplayMode(0, &display_mode) == 0);
    W = display_mode.w;
    H = display_mode.h;
    // 
    mouse;
    winrender;
    image;
    version (HasLogo)
        mklogo;
    ldfont;
}

void nomouse() {
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

version (HasLogo) {
    void mklogo() {
        logo = IMG_Load("static/logo.png");
        assert(logo !is null);
        // 
        logo_t = SDL_CreateTextureFromSurface(renderer, logo);
        assert(logo_t !is null);
        // 
    }
}

version (HasLogo) {
    int logo_x = 12, logo_y = 34, logo_dx = 2, logo_dy = 3;

    void mvlogo() {
        logo_x += logo_dx;
        if (logo_x + logo_rect.w > W || logo_x < 0)
            logo_dx = -logo_dx;
        logo_y += logo_dy;
        if (logo_y + logo_rect.h > H || logo_y < 0)
            logo_dy = -logo_dy;
        logo_rect = SDL_Rect(logo_x, logo_y, logo.w, logo.h);
        SDL_RenderCopy(renderer, logo_t, null, &logo_rect);
    }
}

void fini() {
    TTF_Quit;
    version (HasLogo) {
        SDL_FreeSurface(logo);
        SDL_DestroyTexture(logo_t);
    }
    IMG_Quit();
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();
}

void draw() {
    SDL_SetRenderDrawColor(renderer, 0x11, 0x11, 0x11, 0x00);
    SDL_RenderClear(renderer);
    version (HasLogo)
        mvlogo;
    drawtime;
    SDL_RenderPresent(renderer);
}

void loop() {
    init;
    bool quit = false;
    while (!quit) {
        SDL_Delay(5);
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
