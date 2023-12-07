import std.stdio;

import web;
import video;

void main(string[] args) {
    writeln(args);
    video.loop;
    version (WebInterface) {
        web.backend;
    }
}
