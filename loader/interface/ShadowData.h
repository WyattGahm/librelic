//
//  SHData.h
//  ShadowUI
//
//  Created by Wyatt Gahm on 11/10/21.
//
#import "ShadowSetting.h"
#import "ShadowServerData.h"


#define LOCATION @"location"
#define SETTINGS @"settings"
#define FILE @"shadowx.plist"

@interface ShadowData:NSObject <NSCoding>//,NSXMLParserDelegate
@property (strong, nonatomic) NSArray<ShadowSetting *> *prefs;
@property (strong, nonatomic) NSMutableDictionary *settings;
@property (strong, nonatomic) NSMutableDictionary *location;
@property (strong, nonatomic) NSDictionary *server;
@property (strong, nonatomic) NSMutableDictionary *story;
@property (strong, nonatomic) NSString *pagename;
@property (strong, nonatomic) id currentopera;
@property BOOL seen;
-(void)save;
-(id)load;
-(BOOL)enabled:(NSString *) key;
+(BOOL)isFirst;
-(void)disable:(NSString *)key;
+(void)resetSettings;
+(NSString *)fileWithName:(NSString *)name;
-(CLLocation *)getLocation;
/*
 - (BOOL)objectForKeyedSubscript:(id)key;
 - (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key ;
 */
@end

@implementation ShadowData
//NSObject
-(id)init{
    self = [super init];
    self.prefs = [ShadowSetting makeSettings:@[
        @[@"screenshot", @"Screenshot Supression", @"Screenshotting will no longer send a notification.", @TRUE],
        @[@"savehax", @"Keep Snaps In Chat", @"Delivered and open snaps will temporarily be saved in chat.", @TRUE],
        @[@"seenbutton", @"Enable Mark as Seen", @"Use a button to mark snaps as seen", @FALSE],
        @[@"storyghost", @"Story Ghost", @"View stories anonymously.", @FALSE],
        @[@"noads", @"Disable Ads", @"Block all advertisements", @FALSE],
        @[@"snapghost", @"Snap Ghost", @"Snaps and messages will appear unviewed/unopened.", @FALSE],
        @[@"customtitle",@"Custom Title", @"Leave blank to use default",@FALSE,@""],
        @[@"spoofviews",@"Spoof Story Views", @"Leave blank for normal.",@FALSE,@"1034789"],
        @[@"spoofsc",@"Spoof Story Screenshots", @"Leave blank for normal.",@FALSE,@"871239"],
        @[@"save", @"Save To Camera Roll", @"Tap and hold while viewing a snap to bring up the UI press \"Save Snap Shadow\".",@TRUE],
        @[@"subtitle", @"Hide Subtitle", @"Hide the subtitle containing an MOTD or something from the devs",@FALSE],
        @[@"upload", @"Upload From Camera Roll", @"Press the upload button to select an image and then press the button to take a picture.", @TRUE],
        @[@"nocall", @"Hide Call Buttons", @"Hide the call buttons on recent UI versions.",@TRUE],
        @[@"pinnedchats",@"Override Pin Limit", @"Enter a number for the chat pin limit",@TRUE,@"3"],
        @[@"closeseen", @"Close On Marked", @"Close the snap when marked as seen. Alternatively, pressing the button again will mark as unseen.", @FALSE],
        @[@"savebutton", @"Use Save Button", @"This option will provide a save button to replace the menu option.", @TRUE],
        @[@"callconfirmvideo", @"Video Call Confirm", @"Presents a popup to verify that the action was intentional.",@TRUE],
        @[@"callconfirmaudio", @"Audio Call Confirm", @"Presents a popup to verify that the action was intentional.",@TRUE],
        @[@"hidenewchat", @"Hide New Chat Button", @"Hide the blue button on the bottom on recent UI versions.",@TRUE],
        @[@"highlights", @"Remove Highlights", @"Remove the stupid TikTok knock-off tab (requires app restart).",@FALSE],
        @[@"friendmoji", @"Hide Friendmoji", @"Hide the \"Friendmojis\" next to people's names (requires pull-refresh).", @FALSE],
        @[@"scramble", @"Randomize Best Friends", @"Randomly change the order off the best friends list.", @FALSE],
        @[@"rgb", @"Cool RGB Animation", @"Makes the shadow header RBG (think chromahomebarX).", @TRUE],
        @[@"notitle", @"Keep Normal Title", @"Enable this to hide the \"Shadow X\" label", @FALSE],
        @[@"hotdog", @"Download Hotdog Images", @"Disabling this wont change anything, downloading hotdog images regardless.", @TRUE],
        @[@"reset", @"Reset All Settings", @"Requires closing and opening Snapchat", @FALSE],
    ]];
    [self syncSettings];
    self.location = [NSMutableDictionary new];
    self.seen = FALSE;
    return self;
}
//NSCoding
- (void) encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.settings forKey:SETTINGS];
    [encoder encodeObject:self.location forKey:LOCATION];
}
//NSCoding
- (id)initWithCoder:(NSCoder *)decoder {
    self = [self init];
    self.settings = [decoder decodeObjectForKey:SETTINGS];
    self.location = [decoder decodeObjectForKey:LOCATION];
    return self;//self initwith blahhhhhh
}

+ (instancetype)sharedInstance{
    static ShadowData *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ShadowData alloc] init];
        sharedInstance.server = [ShadowServerData dictionaryForURL:[NSURL URLWithString:@"https://no5up.dev/data.json"]];
    });
    return sharedInstance;
}

- (CLLocation *)getLocation{
    return [[CLLocation alloc]initWithLatitude:[self.location[@"latitude"] boolValue] longitude : [self.location[@"longitude"] boolValue] ];
}

//reinit
-(void)update:(ShadowData*)data{
    self.settings = [NSMutableDictionary dictionaryWithDictionary:data.settings];
    self.location = [NSMutableDictionary dictionaryWithDictionary:data.location];
}
-(void)syncSettings{
    self.settings = [ShadowSetting makeDict:self.prefs];
}
-(void)syncPrefs{
    for(NSString *key in self.settings){
        for(ShadowSetting *setting in self.prefs){
            if([key isEqualToString:setting.key]){
                if(setting.useEntry){
                    setting.entry = self.settings[key];
                }else{
                    setting.value = ((NSString *)self.settings[key]).boolValue;
                }
            }
        }
    }
}
//save
-(void)save{
    [self syncSettings];
    NSString *path = [ShadowData fileWithName:FILE];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self requiringSecureCoding:NO error:nil];//[NSKeyedArchiver archivedDataWithRootObject:self requiringSecureCoding:NO error:nil];
    [data writeToFile:path options:NSDataWritingAtomic error:nil];
}
//load
-(id)load{
    NSString *path = [ShadowData fileWithName:FILE];
    NSData *raw = [NSData dataWithContentsOfFile:path];
    [NSKeyedUnarchiver unarchivedObjectOfClass:[self class] fromData:raw error:nil];
    [self update:[NSKeyedUnarchiver unarchiveObjectWithData:raw]];
    [self syncPrefs];
    return self;
    
}
//legacy support
-(BOOL)enabled:(NSString *) key{
    //NSLog(@"get: %@",self.settings);
    //return ((ShadowSetting*)[[ShadowSetting makeDict:self.prefs] objectForKey:key]).value;
    for(ShadowSetting *setting in self.prefs){
        if([setting.key isEqualToString:key]){
            if(setting.useEntry){
                return ![setting.entry isEqualToString:@""];
            }else{
               return setting.value;
            }
        }
    }
    return false;
}

-(BOOL)enabled_secure:(const char *) str{
    NSString *key = [NSString stringWithUTF8String:str];
    //NSLog(@"get: %@",self.settings);
    //return ((ShadowSetting*)[[ShadowSetting makeDict:self.prefs] objectForKey:key]).value;
    for(ShadowSetting *setting in self.prefs){
        if([setting.key isEqualToString:key]){
            if(setting.useEntry){
                return ![setting.entry isEqualToString:@""];
            }else{
               return setting.value;
            }
        }
    }
    return false;
}

-(void)disable:(NSString *)key{
    for(ShadowSetting *setting in self.prefs){
        if([setting.key isEqualToString:key]){
            if(setting.useEntry){
                setting.entry = @"";
            }else{
                setting.value = FALSE;
            }
        }
    }
}

//utils
+(BOOL)isFirst{
    return [[NSFileManager defaultManager] fileExistsAtPath:[ShadowData fileWithName:FILE]];
}
+(void)resetSettings{
    [[NSFileManager defaultManager] removeItemAtPath:[ShadowData fileWithName:FILE] error:nil];
}
+(NSString *)fileWithName:(NSString *)name{
    return [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject].path stringByAppendingPathComponent:name];
}
@end
