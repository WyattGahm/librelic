//
//  ShadowSetting.h
//  ShadowUI
//
//  Created by Wyatt Gahm on 11/10/21.
//

@interface ShadowSetting: NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *key;
@property _Bool value;
@property _Bool useEntry;
@property (strong, nonatomic) NSString *entry;
-(instancetype)key:(NSString *)key name:(NSString *)name text:(NSString *)text value:(_Bool)value;
-(instancetype)fromDict:(NSDictionary *)dict;
-(instancetype)fromArray:(NSArray *)dict;
@end

@implementation ShadowSetting
-(instancetype)key:(NSString *)key name:(NSString *)name text:(NSString *)text value:(_Bool)value{
    self.key = key;
    self.name = name;
    self.text = text;
    self.value = value;
    return self;
}
-(instancetype)fromDict:(NSDictionary *)dict{
    self.key = dict[@"key"];
    self.name = dict[@"name"];
    self.text = dict[@"text"];
    self.value = ((NSString *)dict[@"value"]).boolValue;
    if(dict[@"entry"]){
        self.useEntry = TRUE;
        self.entry = dict[@"entry"];
    }
    return self;
}
-(instancetype)fromArray:(NSArray *)array{
    self.key = array[0];
    self.name = array[1];
    self.text = array[2];
    self.value = ((NSString *)array[3]).boolValue;
    if(array.count > 4){
        self.useEntry = TRUE;
        self.entry = array[4];
    }
    return self;
}
+(NSArray<ShadowSetting*>*)makeSettings:(NSArray<NSArray*>*)data{
    NSMutableArray<ShadowSetting*> *settings = [NSMutableArray new];
    for(NSArray *setting in data) [settings addObject:[[ShadowSetting new] fromArray: setting]];
    return [settings copy];
}
+(NSMutableDictionary*)makeDict:(NSArray<ShadowSetting*>*)data{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    for(ShadowSetting *setting in data) //[dict addObject:[[ShadowSetting new] fromArray: setting]];
        if(setting.useEntry)
            [dict setObject:setting.entry forKey:setting.key];
        else
            [dict setObject:setting.value ? @"True" : @"False" forKey:setting.key];
    return dict;
}
@end

