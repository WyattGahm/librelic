#import "ShadowAssets.h"

@implementation ShadowAssets
- (id)init{
    self = [super init];
    NSString *theme = @"/Library/Application Support/shadowx/default/";
    if([ShadowData sharedInstance].theme){
        theme = [[@"/Library/Application Support/shadowx/" stringByAppendingString:[ShadowData sharedInstance].theme] stringByAppendingString:@"/"];
    }
    self.save = [UIImage imageWithContentsOfFile:[theme stringByAppendingString:@"save.png"]];
    self.upload = [UIImage imageWithContentsOfFile:[theme stringByAppendingString:@"upload.png"]];
    self.seen = [UIImage imageWithContentsOfFile:[theme stringByAppendingString:@"seen.png"]];
    self.seened = [UIImage imageWithContentsOfFile:[theme stringByAppendingString:@"seened.png"]];
    self.saved = [UIImage imageWithContentsOfFile:[theme stringByAppendingString:@"saved.png"]];
    self.screenshot = [UIImage imageWithContentsOfFile:[theme stringByAppendingString:@"screenshot.png"]];
    self.toolbar = [UIImage imageWithContentsOfFile:[theme stringByAppendingString:@"toolbar.png"]];
    
    self.pull_normal = [UIImage imageWithContentsOfFile:[theme stringByAppendingString:@"pull.normal.png"]];
    self.pull_wink = [UIImage imageWithContentsOfFile:[theme stringByAppendingString:@"pull.wink.png"]];
    self.pull_shocked = [UIImage imageWithContentsOfFile:[theme stringByAppendingString:@"pull.shocked.png"]];
    self.pull_rainbow = [UIImage imageWithContentsOfFile:[theme stringByAppendingString:@"pull.rainbow.png"]];
    self.pull_hands = [UIImage imageWithContentsOfFile:[theme stringByAppendingString:@"pull.hands.png"]];
    
    return self;
}

+ (UIImage *)download:(NSString*)url{
    return [UIImage imageWithData: [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: url]]];
}

+ (instancetype)sharedInstance{
    static ShadowAssets *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ShadowAssets alloc] init];
    });
    return sharedInstance;
}

@end

