#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ShadowSetting: NSObject
@property NSString *section;
@property NSString *key;
@property NSString *title;
@property NSString *text;
@property NSString *type;
@property NSString *value;
+(NSArray<ShadowSetting*>*)makeSettings:(NSArray<NSArray*>*)data;
+(NSMutableDictionary*)makeDict:(NSArray<ShadowSetting*>*)data;
-(NSArray*)getData;
-(instancetype)fromArray:(NSArray *)array;
-(instancetype)fromDict:(NSDictionary *)dict;
@end
