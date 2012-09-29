static int counter = 0;

void initialize_opengl(CGLContextObj cgl_ctx) {
    NSLog(@"OpenGL initialization function");
}

void uninitialize_opengl(CGLContextObj cgl_ctx) {
    NSLog(@"OpenGL un-initialization function");
}

void render(CGLContextObj cgl_ctx) {
    // NSLog(@"render called %d times", ++counter);
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    CGLFlushDrawable(cgl_ctx);
}