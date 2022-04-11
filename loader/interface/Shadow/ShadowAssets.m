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
    self.saved = [UIImage imageWithContentsOfFile:[theme stringByAppendingString:@"saved.png"]];
    self.pullrefresh = [UIImage imageWithContentsOfFile:[theme stringByAppendingString:@"pullrefresh.png"]];
    self.screenshot = [UIImage imageWithContentsOfFile:[theme stringByAppendingString:@"screenshot.png"]];
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

