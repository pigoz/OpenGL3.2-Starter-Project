#include "OpenGLView.h"

#define NSPIXFMT NSOpenGLPixelFormat
#define NSCTX    NSOpenGLContext

@implementation OpenGLView : NSOpenGLView

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

- (void)drawRect:(NSRect)dirtyRect
{
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    [[self openGLContext] flushBuffer];
}

@end