/// web interface
module web;

import vibe.vibe;

HTTPServerSettings settings = null;
URLRouter router = null;

static this() {
    settings = new HTTPServerSettings;
    settings.port = 12345;
    settings.bindAddresses = ["127.0.0.1"];
    settings.errorPageHandler = toDelegate(&error);
    router = new URLRouter;
}

void error(HTTPServerRequest req, HTTPServerResponse res,
        HTTPServerErrorInfo err) {
    res.render!("error.dt", req, err);
}

void backend() {
    // 
    router.get("/", staticTemplate!"index.dt");
    router.get("/about", serveStaticFile("README.md"));
    // 
    router.get("/favicon.ico", serveStaticFile("static/logo.png"));
    router.get("*", serveStaticFiles("static/"));
    // 
    listenHTTP(settings, router);
    runApplication();
}
