#import "ShadowOptionsManager.h"

@implementation ShadowOptionsManager
+(id)sharedInstance{
    static ShadowOptionsManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ShadowOptionsManager alloc] init];
    });
    return sharedInstance;
}

-(id)init{
    self = [super init];
    self.items = [NSMutableArray new];
    return self;
}

-(void)addOptionWithTitle:(NSString*)title identifier:(NSString*)identifier block:(id)action{
    if(![self identifierExists:identifier]){
        NSDictionary *newoption = @{
            @"identifier": identifier,
            @"title": title,
            @"block": action,
        };
        [self.items addObject:newoption];
    }
}

-(NSMutableArray*)allIdentifiers{
    NSMutableArray *ret = [NSMutableArray new];
    for(NSDictionary *item in self.items){
        [ret addObject:item[@"identifier"]];
    }
    return ret;
}

-(NSString*)titleForIdentifier:(NSString*)identifier{
    for(NSDictionary *item in self.items){
        if([identifier isEqual: item[@"identifier"]]){
            return item[@"title"];
        }
    }
    return @"UH OH! MAJOR ERROR!";
}

-(id)blockForIdentifier:(NSString*)identifier{
    for(NSDictionary *item in self.items){
        if([identifier isEqual: item[@"identifier"]]){
            return item[@"block"];
        }
    }
    return nil;
}
-(BOOL)identifierExists:(NSString*)identifier{
    for(NSDictionary *item in self.items){
        if([identifier isEqual: item[@"identifier"]]){
            return YES;
        }
    }
    return NO;
}

-(void)clear{
    self.items = [NSMutableArray new];
}
@end

