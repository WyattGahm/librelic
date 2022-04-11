//
//  XLLogerManager.m
//  XLLogerDemo
//
//  Created by mgfjx on 2021/9/12.
//

#import "XLLogerManager.h"
#import "XLLogerView.h"
#import "XLWindow.h"

#define kEnableKey @"kEnableKey"

@interface XLLogerManager ()<XLWindowEventDelegate>

@property (nonatomic, strong) UIViewController *explorerViewController ;
@property (nonatomic, strong) XLWindow *window ;
@property (nonatomic, strong) XLLogerView *logView ;

@property (nonatomic, assign) int outDupValue ;
@property (nonatomic, assign) int errDupValue ;

@property (nonatomic, strong) dispatch_source_t outSource_t ;
@property (nonatomic, strong) dispatch_source_t errSource_t ;

/// temporary log if logView don't create
@property (nonatomic, strong) NSString *temporaryLog ;

@end

@implementation XLLogerManager

static XLLogerManager *singleton = nil;

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    if (!singleton) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            singleton = [super allocWithZone:zone];
        });
    }
    return singleton;
}

- (instancetype)init{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [super init];
        singleton.textColor = [UIColor whiteColor];
        singleton.textSize = 12.0f;
        singleton.autoDestination = NO;
        singleton.temporaryLog = @"";
        id enable = [[NSUserDefaults standardUserDefaults] objectForKey:kEnableKey];
        if (!enable) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kEnableKey];
        }
        singleton->_enable = [[NSUserDefaults standardUserDefaults] boolForKey:kEnableKey];
    });
    return singleton;
}

- (id)copyWithZone:(NSZone *)zone{
    return singleton;
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    return singleton;
}

+ (instancetype)manager {
    return [[self alloc] init];
}

- (void)prepare {
    if (!self.enable) {
        return;
    }
    self.outDupValue = dup(STDOUT_FILENO);
    self.errDupValue = dup(STDERR_FILENO);
    
    if (self.autoDestination) {
        if (!isatty(STDERR_FILENO)) {
            self.outSource_t = [self _startCapturingWritingToFD:STDOUT_FILENO];
            self.errSource_t = [self _startCapturingWritingToFD:STDERR_FILENO];
        }
    } else {
        self.outSource_t = [self _startCapturingWritingToFD:STDOUT_FILENO];
        self.errSource_t = [self _startCapturingWritingToFD:STDERR_FILENO];
    }
}

- (void)setEnable:(BOOL)enable {
    [[NSUserDefaults standardUserDefaults] setBool:enable forKey:kEnableKey];
    _enable = enable;
    if (enable) {
        [self prepare];
    } else {
        if (self.outSource_t) {
            dispatch_source_cancel(self.outSource_t);
            self.outSource_t = nil;
        }
        if (self.errSource_t) {
            dispatch_source_cancel(self.errSource_t);
            self.errSource_t = nil;
        }
        dup2(self.outDupValue, STDOUT_FILENO);
        dup2(self.errDupValue, STDERR_FILENO);
    }
}

- (XLWindow *)window {
    NSAssert(NSThread.isMainThread, @"You must use %@ from the main thread only.", NSStringFromClass([self class]));
    if (!_window) {
        _window = [[XLWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.eventDelegate = self;
        _window.backgroundColor = [UIColor clearColor];
    }
    
    return _window;
}

- (UIViewController *)explorerViewController {
    if (!_explorerViewController) {
        _explorerViewController = [UIViewController new];
    }

    return _explorerViewController;
}

/// add XLLoger View On Root window
- (void)showOnWindow {
    
    if (self.logView) {
        return;
    }
    UIWindow *flex = self.window;
    flex.hidden = NO;
    if (@available(iOS 13.0, *)) {
        // Only look for a new scene if we don't have one
        if (!flex.windowScene) {
            flex.windowScene = XLLogerManager.appKeyWindow.windowScene;
        }
    }
    [self showOnView:self.window];
}

- (void)showOnView:(UIView *)superView {
    CGFloat superHeight = superView.frame.size.height;
    CGFloat superWidth = superView.frame.size.width;
    XLLogerView *logView = [[XLLogerView alloc] initWithFrame:CGRectMake(20, 88, superWidth * 3.0/4, superHeight * 3.0/5)];
    logView.defaultLog = self.temporaryLog;
    [superView addSubview:logView];
    logView.layer.zPosition = UIWindowLevelStatusBar + 1;
    self.logView = logView;
    self.temporaryLog = nil;
    
    __weak __typeof(&*self) weakSelf  = self;
    logView.closeCallback = ^{
        if (weakSelf.logView) {
            [weakSelf.logView removeFromSuperview];
            weakSelf.logView = nil;
        }
    };
}

- (dispatch_source_t)_startCapturingWritingToFD:(int)fd  {

    int fildes[2];
    pipe(fildes);  // [0] is read end of pipe while [1] is write end
    dup2(fildes[1], fd);  // Duplicate write end of pipe "onto" fd (this closes fd)
    close(fildes[1]);  // Close original write end of pipe
    fd = fildes[0];  // We can now monitor the read end of the pipe

    char* buffer = malloc(1024);
    fcntl(fd, F_SETFL, O_NONBLOCK);
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_READ, fd, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0));
    dispatch_source_set_cancel_handler(source, ^{
        free(buffer);
    });
    dispatch_source_set_event_handler(source, ^{
        @autoreleasepool {

            NSMutableData* data = [[NSMutableData alloc] init];
            while (1) {
                ssize_t size = read(fd, buffer, 1024);
                if (size <= 0) {
                    break;
                }
                [data appendBytes:buffer length:size];
                if (size < 1024) {
                    break;
                }
            }
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.outputCallback) {
                    self.outputCallback(str);
                } else {
                    self.temporaryLog = [NSString stringWithFormat:@"%@%@",self.temporaryLog, str];
                }
            });
        }
    });
    dispatch_resume(source);
    return source;
}

+ (UIWindow *)appKeyWindow {
    // First, check UIApplication.keyWindow
    XLWindow *window = (id)UIApplication.sharedApplication.keyWindow;
    if (window) {
        if ([window isKindOfClass:[XLWindow class]]) {
            return window.previousKeyWindow;
        }
        
        return window;
    }
    
    // As of iOS 13, UIApplication.keyWindow does not return nil,
    // so this is more of a safeguard against it returning nil in the future.
    //
    // Also, these are obviously not all FLEXWindows; FLEXWindow is used
    // so we can call window.previousKeyWindow without an ugly cast
    for (XLWindow *window in UIApplication.sharedApplication.windows) {
        if (window.isKeyWindow) {
            if ([window isKindOfClass:[XLWindow class]]) {
                return window.previousKeyWindow;
            }
            
            return window;
        }
    }
    
    return nil;
}

#pragma mark - XLWindowEventDelegate
- (BOOL)shouldHandleTouchAtPoint:(CGPoint)pointInWindow {
    // Ask the explorer view controller
    return [self.logView shouldReceiveTouchAtWindowPoint:pointInWindow];
}

@end
