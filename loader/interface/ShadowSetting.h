//
//  ShadowSetting.h
//  ShadowUI
//
//  Created by Wyatt Gahm on 11/10/21.
//

@interface ShadowSetting: NSObject
@property NSString *section;
@property NSString *key;
@property NSString *title;
@property NSString *text;
@property NSString *type;
@property NSString *value;

//@property NSString *value;
//-(instancetype)key:(NSString *)key name:(NSString *)name text:(NSString *)text value:(_Bool)value;
-(instancetype)fromDict:(NSDictionary *)dict;
-(instancetype)fromArray:(NSArray *)dict;
@end

@implementation ShadowSetting
/*
-(instancetype)key:(NSString *)key name:(NSString *)name text:(NSString *)text value:(_Bool)value{
    self.key = key;
    self.name = name;
    self.text = text;
    self.value = value;
    return self;
}
 */
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

