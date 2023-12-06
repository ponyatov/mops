import std.stdio;

import web;

void main(string[] args) {
    writeln(args);
    version (WebInterface) {
        web.backend;
    }
}
