#import "ShadowChatActions.h"

@implementation ShadowChatActions
+(instancetype)sharedInstance{
    static ShadowChatActions *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ShadowChatActions alloc] init];
    });
    return sharedInstance;
}
-(id)init{
    self = [super init];
    self.items = [NSMutableDictionary new];
    return self;
}

-(void)addOptionWithTitle:(NSString*)title subtitle:(NSString* )subtitle icon:(UIImage*)icon identifier:(NSString*)identifier type:(NSString*)type block:(Action)action{
    self.items[identifier] = @{
        @"type": type,
        @"identifier": identifier,
        @"title": title,
        @"subtitle": subtitle,
        @"icon": icon,
        @"block": action,
    };
}

-(void)clear{
    self.items = [NSMutableDictionary new];
}
@end
