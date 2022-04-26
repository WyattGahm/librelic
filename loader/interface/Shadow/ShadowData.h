#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#import "ShadowSetting.h"
#import "ShadowServerData.h"
#import "ShadowLayout.h"

#define LOCATION @"location"
#define SETTINGS @"settings"
#define THEME @"theme"
#define LAYOUT @"layout"
#define FIRST @"first"
#define FILE @"shadowxrelic.plist"

@interface ShadowData:NSObject <NSCoding>
@property NSArray<ShadowSetting *> *prefs;
@property NSMutableDictionary *settings;
@property NSMutableDictionary *location;
@property NSDictionary *server;
@property ShadowLayout *positions;
@property BOOL seen;
@property NSMutableDictionary<NSString*, NSData*> *audionotes;
@property NSString *theme;
@property NSString *first;
-(void)save;
-(id)load;
+(BOOL)enabled:(NSString *) key;
+(BOOL)isFirst;
-(void)disable:(NSString *)key;
+(void)resetSettings;
+(NSString *)fileWithName:(NSString *)name;
-(CLLocation *)getLocation;
+ (instancetype)sharedInstance;
-(void)enable:(NSString *)key;
-(NSMutableDictionary<NSString*, NSMutableArray<ShadowSetting*>*>*)layout;
-(NSMutableArray<NSString*>*)orderedSections;
-(long)indexForKey:(NSString *)key;
+(NSMutableArray*)getThemes;
@end

