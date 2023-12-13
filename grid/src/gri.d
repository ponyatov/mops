import std.stdio;

import bindbc.sdl;

SDL_DisplayMode display_mode;

class Window {
    SDL_Window* window = null;
    SDL_Renderer* renderer = null;
    string title;
    int w, h, x, y;
    ubyte r, g, b;
    this(string title, int width, int height, int xpos,
            int ypos, ubyte red, ubyte green, ubyte blue) {
        this.title = title;
        w = width;
        h = height;
        x = xpos;
        y = ypos;
        r = red;
        g = green;
        b = blue;
        assert(SDL_CreateWindowAndRenderer(w, h,
                SDL_WINDOW_SHOWN | SDL_WINDOW_BORDERLESS, &window, &renderer) == 0);
        SDL_SetWindowPosition(window, x, y);
        SDL_SetRenderDrawColor(renderer, r, g, b, 0x00);
        draw;
    }

    void draw() {
        SDL_RenderClear(renderer);
        SDL_RenderPresent(renderer);
    }

    ~this() {
        SDL_DestroyRenderer(renderer);
        SDL_DestroyWindow(window);
    }
}

Window A, B, C;

void nomouse() {
    SDL_ShowCursor(SDL_DISABLE);
}

void init() {
    assert(SDL_Init(SDL_INIT_VIDEO) == 0);
    nomouse;
    assert(SDL_GetCurrentDisplayMode(0, &display_mode) == 0);
    auto w = display_mode.w;
    auto h = display_mode.h;
    A = new Window("A", w / 3, h, w / 3 * 0, 0, 0x11, 0x00, 0x00);
    B = new Window("B", w / 3, h, w / 3 * 1, 0, 0x00, 0x11, 0x00);
    B = new Window("C", w / 3, h, w / 3 * 2, 0, 0x00, 0x00, 0x11);
}

void fini() {
    A.destroy;
    B.destroy;
    C.destroy;
    SDL_Quit();
}

void loop() {
    SDL_Event event;
    bool quit = false;
    while (!quit) {
        SDL_Delay(5);
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

void main(string[] args) {
    writeln(args);
    init;
    loop;
    fini;
}
