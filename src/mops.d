import std.stdio;

import web;
import video;

void main(string[] args) {
    writeln(args);
    video.blaster;
    version (WebInterface) {
        web.backend;
    }
}
