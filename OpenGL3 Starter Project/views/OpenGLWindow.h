@interface OpenGLWindow : NSWindow
@property (nonatomic, assign, getter=isFullscreen) BOOL fullscreen;
@property (nonatomic, assign) NSRect windowedFrame;
@property (nonatomic, retain) NSString *windowedTitle;

- (IBAction)toggleWindowFullscreen:(id)sender;
@end