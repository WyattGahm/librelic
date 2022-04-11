#import "ShadowSetting.h"

@implementation ShadowSetting

-(instancetype)fromDict:(NSDictionary *)dict{
    self.section = dict[@"section"];
    self.key = dict[@"key"];
    self.title = dict[@"title"];
    self.text = dict[@"text"];
    self.type = dict[@"type"];
    self.value = dict[@"value"];
    return self;
}
-(instancetype)fromArray:(NSArray *)array{
    self.section = array[0];
    self.key = array[1];
    self.title = array[2];
    self.text = array[3];
    self.type = array[4];
    self.value = array[5];
    return self;
}
+(NSArray<ShadowSetting*>*)makeSettings:(NSArray<NSArray*>*)data{
    NSMutableArray<ShadowSetting*> *settings = [NSMutableArray new];
    for(NSArray *setting in data) [settings addObject:[[ShadowSetting alloc] fromArray: setting]];
    return [settings copy];
}
+(NSMutableDictionary*)makeDict:(NSArray<ShadowSetting*>*)data{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    for(ShadowSetting *setting in data)
        [dict setObject:setting.value forKey:setting.key];
    return dict;
}
-(NSArray*)getData{
    return @[self.section, self.key, self.title, self.text, self.type, self.value];
}
@end


