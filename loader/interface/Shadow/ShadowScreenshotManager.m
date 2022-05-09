#import "ShadowScreenshotManager.h"

@implementation ShadowScreenshotManager
-(id)init{
    self = [super init];
    self.pending = NO;
    self.calls = [NSMutableArray new];
    return self;
}
+ (instancetype)sharedInstance{
    static ShadowScreenshotManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [ShadowScreenshotManager new];
    });
    return sharedInstance;
}
-(void)handle:(scblock)pass{
    if([ShadowData enabled:@"screenshotconfirm"]){
        [self.calls addObject: pass];
        if(!self.pending){
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(reset) userInfo:nil repeats:NO];
            self.pending = YES;
            [ShadowHelper popup: @"Screenshot" text: @"Should we notify the app that you took a screenshot?" yes: @"Supress" no: @"Screenshot" action:^(BOOL supress){
                if(!supress){
                    for(scblock call in self.calls){
                        call();
                    }
                }
                self.calls = [NSMutableArray new];
                NSLog(supress ? @"yuh":@"nah");
            }];
        }
    }else if(![ShadowData enabled:@"screenshot"]){
        pass();
    }
}
-(void)reset{
    self.pending = NO;
}
@end

//scimpalaprofileOnboardingView(Model)
//SIGActionSheet, SIGActionSheetCell
