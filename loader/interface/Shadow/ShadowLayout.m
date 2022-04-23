#import "ShadowLayout.h"

@implementation ShadowLayout
+(NSMutableDictionary<NSString*,NSMutableDictionary*>*)defaultLayout{
    NSDictionary *data = @{
        @"save": @{
            @"x": [NSString stringWithFormat:@"%f", [UIScreen mainScreen].bounds.size.width * 0.85],
            @"y": [NSString stringWithFormat:@"%f", [UIScreen mainScreen].bounds.size.height * 0.70],
            @"s": @"40",
        },
        @"upload": @{
            @"x": [NSString stringWithFormat:@"%f", [UIScreen mainScreen].bounds.size.width * 0.88],
            @"y": [NSString stringWithFormat:@"%f", [UIScreen mainScreen].bounds.size.height * 0.87],
            @"s": @"40",
        },
        @"sc": @{
            @"x": [NSString stringWithFormat:@"%f", [UIScreen mainScreen].bounds.size.width * 0.85],
            @"y": [NSString stringWithFormat:@"%f", [UIScreen mainScreen].bounds.size.height * 0.70 - 100],
            @"s": @"40",
        },
        @"seen": @{
            @"x": [NSString stringWithFormat:@"%f", [UIScreen mainScreen].bounds.size.width * 0.85],
            @"y": [NSString stringWithFormat:@"%f", [UIScreen mainScreen].bounds.size.height * 0.70 - 50],
            @"s": @"40",
        },
    };
    ShadowLayout *ret = [ShadowLayout new];
    [ret assignData: data];
    return ret.layout;
    
}
-(void)assignData:(NSDictionary*)data{
    NSMutableDictionary *ret = [NSMutableDictionary new];
    for(NSString* key in data){
        if(!ret[key]){
            ret[key] = [NSMutableDictionary new];
        }
        ret[key] = [data[key] mutableCopy];
    }
    self.layout = ret;
}
-(CGRect)frameForID:(NSString*)key{
    NSMutableDictionary *config = self.layout[key] ? self.layout[key] : [ShadowLayout defaultLayout][key];
    float s = config[@"s"] ? [config[@"s"] floatValue] : 40;
    return CGRectMake(s,s,s,s);
}
-(void)setFrameForID:(NSString*)key value:(CGRect)val{
    if(!self.layout[key]) self.layout[key] = [NSMutableDictionary new];
    self.layout[key][@"s"] = [NSString stringWithFormat:@"%f", val.size.width];
}
-(CGPoint)centerForID:(NSString*)key{
    NSMutableDictionary *config = self.layout[key] ? self.layout[key] : [ShadowLayout defaultLayout][key];
    float x = config[@"x"] ? [config[@"x"] floatValue] : 40;
    float y = config[@"y"] ? [config[@"y"] floatValue] : 40;
    return CGPointMake(x, y);
}
-(void)setCenterForID:(NSString*)key value:(CGPoint)val{
    NSLog(@"DEBUG 0: %@ %@",self.layout.class, key);
    /*
    if(!self.layout[key]){
        self.layout[key] = [NSMutableDictionary new];
        NSLog(@"SETTING UP %@",key);
    }
     */
    self.layout[key][@"x"] = [NSString stringWithFormat:@"%f", val.x];
    self.layout[key][@"y"] = [NSString stringWithFormat:@"%f", val.y];
}

@end
