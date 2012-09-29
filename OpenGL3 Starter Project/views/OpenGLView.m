#include "OpenGLView.h"

#define NSPIXFMT NSOpenGLPixelFormat
#define NSCTX    NSOpenGLContext

#import <OpenGL/CGLMacro.h>

@implementation OpenGLView {
    CVDisplayLinkRef displayLink;
}

- (void)awakeFromNib
{
    NSOpenGLPixelFormatAttribute attrs[] = {
        NSOpenGLPFADoubleBuffer,
        NSOpenGLPFADepthSize, 24,
        NSOpenGLPFAOpenGLProfile,
        NSOpenGLProfileVersion3_2Core,
        0
    };
    
    NSPIXFMT *pf = [[NSPIXFMT alloc] initWithAttributes:attrs];
    
    if (!pf) {
        NSLog(@"No OpenGL pixel format");
        [NSApp terminate:self];
    }
    
    NSCTX* context = [[NSCTX alloc] initWithFormat:pf shareContext:nil];
    
    [self setPixelFormat:pf];
    [self setOpenGLContext:context];
    
    [pf release];
    [context release];
}

- (void)prepareOpenGL
{
    GLint vsync = 1;
    CGLContextObj cglContext = [[self openGLContext] CGLContextObj];
    CGLPixelFormatObj cglPixelFormat = [[self pixelFormat] CGLPixelFormatObj];

    [[self openGLContext] setValues:&vsync forParameter:NSOpenGLCPSwapInterval];
    CVDisplayLinkCreateWithActiveCGDisplays(&displayLink);
    CVDisplayLinkSetOutputCallback(displayLink, &displayLinkCallback, self);
    CVDisplayLinkSetCurrentCGDisplayFromOpenGLContext(displayLink, cglContext,
                                                      cglPixelFormat);

    CVDisplayLinkStart(displayLink);
}

- (CGLContextObj) willStartDrawing
{
    CGLContextObj cgl_ctx = [[self openGLContext] CGLContextObj];
    CGLSetCurrentContext(cgl_ctx);
	CGLLockContext(cgl_ctx);
    return cgl_ctx;
}

- (void) didFinishDrawing: (CGLContextObj) cgl_ctx;
{
    CGLUnlockContext(cgl_ctx);
}

- (CVReturn)render
{
    CGLContextObj cgl_ctx = [self willStartDrawing];

    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    [[self openGLContext] flushBuffer];

    [self didFinishDrawing:cgl_ctx];

    return kCVReturnSuccess;
}

- (void) reshape
{
    CGLContextObj cgl_ctx = [self willStartDrawing];
	[super reshape];
    [self didFinishDrawing:cgl_ctx];
}

- (void) update
{
    CGLContextObj cgl_ctx = [self willStartDrawing];
	[super update];
    [self didFinishDrawing:cgl_ctx];
}

- (void)dealloc
{
    CVDisplayLinkRelease(displayLink);
    [super dealloc];
}

- (void) drawRect:(NSRect)dirtyRect
{
    [self render];
}

static CVReturn displayLinkCallback(CVDisplayLinkRef displayLink,
  const CVTimeStamp* now, const CVTimeStamp* outputTime, CVOptionFlags flagsIn,
  CVOptionFlags* flagsOut, void* displayLinkContext)
{
    [(OpenGLView*)displayLinkContext render];
    return kCVReturnSuccess;
}

@end