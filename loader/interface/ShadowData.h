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
#define FILE @"shadowxrelic.plist"

@interface ShadowData:NSObject <NSCoding>
@property NSArray<ShadowSetting *> *prefs;
@property NSMutableDictionary *settings;
@property NSMutableDictionary *location;
@property NSDictionary *server;
@property BOOL seen;
-(void)save;
-(id)load;
-(BOOL)enabled:(NSString *) key;
+(BOOL)isFirst;
-(void)disable:(NSString *)key;
+(void)resetSettings;
+(NSString *)fileWithName:(NSString *)name;
-(CLLocation *)getLocation;
@end

@implementation ShadowData
-(id)init{
    self = [super init];
    self.prefs = [ShadowSetting makeSettings:@[
        @[@"header",@"image", @"----", @"----", @"image", @"/Library/Application Support/shadowx/header0.png"],
        
        
        @[@"snapchat interface", @"nomapswiping", @"No Map Swipe", @"Disable swiping to Snapmap.", @"switch", @"false"],
        @[@"snapchat interface", @"noads", @"Disable Ads", @"Block all advertisements.", @"switch", @"true"],
        @[@"snapchat interface", @"openurl", @"Open Link Default", @"Open links in chat using safari.", @"switch", @"false"],
        @[@"snapchat interface", @"hidenewchat", @"Hide New Chat Button", @"Hide the blue button on the bottom on recent UI versions.", @"switch", @"true"],
        @[@"snapchat interface", @"highlights", @"Remove Highlights", @"Remove the stupid TikTok knock-off tab (requires app restart).", @"switch", @"false"],
        @[@"snapchat interface", @"discover", @"Remove Discover", @"Remove the Discover stories", @"switch", @"false"],
        @[@"snapchat interface", @"quickadd", @"Remove Quick Add", @"Remove the Quick Add sections", @"switch", @"false"],
        @[@"snapchat interface", @"friendmoji", @"Hide Friendmoji", @"Hide the \"Friendmojis\" next to people's names (requires pull-refresh).",  @"switch", @"false"],
        @[@"snapchat interface", @"scramble", @"Randomize Best Friends", @"Randomly change the order off the best friends list.",  @"switch", @"false"],
        
        @[@"recording", @"screenshotconfirm", @"Screenshot Confirm", @"Presents a prompt to ignore screenshots", @"switch", @"false"],
        @[@"recording", @"screenrecord", @"Screen Record", @"Supress screen recording", @"switch", @"true"],
        @[@"recording", @"scpassthrough", @"Screenshot Supression", @"Toggle supressing screenshot notifications", @"switch", @"true"],
        
        @[@"actions", @"reset", @"Reset All Settings", @"Requires closing and opening Snapchat.", @"button",@"RESET"],
        @[@"actions", @"debug", @"Open Log", @"Opens a log window for debugging.", @"button", @"DEBUG"],
        
        @[@"spoof", @"location", @"Spoof Location", @"Use the location selector below to change location.", @"switch", @"false"],
        @[@"spoof", @"picklocation", @"Pick Location", @"Requires enabling \"Spoof Location\".", @"button", @"PICK"],
        @[@"spoof", @"spoofviews",@"Spoof Story Views", @"Leave blank for normal.",@"text",@"1034789"],
        @[@"spoof", @"spoofsc",@"Spoof Story Screenshots", @"Leave blank for normal.",@"text",@"871239"],
        @[@"spoof", @"pinnedchats",@"Override Pin Limit", @"Enter a number for the chat pin limit.",@"text",@"3"],
        @[@"spoof", @"teleport", @"Teleport to Friends", @"Tap a friend on the Snapmap to teleport to them", @"switch", @"false"],
        
        @[@"shadow interface", @"darkmode", @"Shadow Dark Mode", @"Use dark mode in this settings menu.", @"switch", @"true"],
        @[@"shadow interface", @"subtitle", @"Hide Subtitle", @"Hide the subtitle containing an MOTD or something from the devs.",@"switch",@"false"],
        @[@"shadow interface", @"rgb", @"Cool RGB Animation", @"Makes the shadow header RBG (think chromahomebarX).", @"switch", @"true"],
        @[@"shadow interface", @"customtitle",@"Custom Title", @"Leave blank to use default.",@"text",@""],
        
        @[@"shadow additions", @"seenright", @"Seen On Right", @"Seen Button moved to the right side of the screen", @"switch", @"false"],
        @[@"shadow additions", @"showbanners", @"Show Banners", @"Enable banners for some interactions (saving, marking as seen)",  @"switch", @"true"],
        @[@"shadow additions", @"savebutton", @"Use New Save Button", @"Places the save button on the image rather than the action menu", @"switch", @"true"],
        @[@"shadow additions", @"upload", @"Upload From Camera Roll", @"Press the upload button to select an image and then press the button to take a picture.", @"switch", @"true"],
        @[@"shadow additions", @"savehax", @"Keep Snaps In Chat", @"Delivered and open snaps will be fake saved in chat.",  @"switch", @"false"],
        @[@"shadow additions", @"seenbutton", @"Enable Mark as Seen", @"Use a button to mark snaps as seen.",  @"switch", @"true"],
        @[@"shadow additions", @"screenshotbtn", @"Screenshot Button", @"Use a button to mark snaps as screenshotted.",  @"switch", @"false"],
        @[@"shadow additions", @"closeseen", @"Close On Marked", @"Close the snap when marked as seen. Alternatively, pressing the button again will mark as unseen.",  @"switch", @"true"],
        @[@"shadow additions", @"markfriends", @"Manual Mark Friends", @"Mark all stories but friends as seen automatically", @"switch", @"false"],
        
        @[@"shadow experiments", @"scspambtn", @"Screenshot Spam", @"Rapidly sends screenshot notifications as a PRANK",  @"switch", @"false"],
        @[@"shadow experiments", @"eastereggs", @"Enable Easter Eggs", @"Enable some small and potentially buggy secret changes.", @"switch", @"true"],
        @[@"shadow experiments", @"hotdog", @"Download Hotdog Images", @"Disabling this wont change anything, downloading hotdog images regardless.",  @"switch", @"true"],
        
        //@[@"nocall", @"Hide Call Buttons", @"Hide the call buttons on recent UI versions.",@TRUE],
        //@[@"callconfirmvideo", @"Video Call Confirm", @"Presents a popup to verify that the action was intentional.",@TRUE],
        //@[@"callconfirmaudio", @"Audio Call Confirm", @"Presents a popup to verify that the action was intentional.",@TRUE],
    ]];
    [self syncSettings];
    self.location = [NSMutableDictionary new];
    self.seen = FALSE;
    return self;
}
//NSCoding
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.settings forKey:SETTINGS];
    [encoder encodeObject:self.location forKey:LOCATION];
}
//NSCoding
- (id)initWithCoder:(NSCoder *)decoder {
    self = [self init];
    self.settings = [decoder decodeObjectForKey:SETTINGS];
    self.location = [decoder decodeObjectForKey:LOCATION];
    return self;
}

+ (instancetype)sharedInstance{
    static ShadowData *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ShadowData alloc] init];
        sharedInstance.server = [ShadowServerData dictionaryForURL:[NSURL URLWithString:@"https://no5up.dev/data_private.json"]];
    });
    return sharedInstance;
}

- (CLLocation *)getLocation{
    return [[CLLocation alloc]initWithLatitude:[self.location[@"Latitude"] floatValue] longitude : [self.location[@"Longitude"] floatValue] ];
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
                setting.value = self.settings[key];
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

-(NSMutableDictionary<NSString*, NSMutableArray<ShadowSetting*>*>*)layout{
    NSMutableDictionary<NSString*, NSMutableArray<ShadowSetting*>*> *sections = [NSMutableDictionary new];
    for(ShadowSetting *setting in self.prefs){
        if(!sections[setting.section] ){
            sections[setting.section] = [NSMutableArray new];
        }
        [sections[setting.section] addObject:setting];
    }
    return sections;
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
    for(ShadowSetting *setting in self.prefs){
        if([setting.key isEqualToString:key]){
            if([setting.type isEqualToString:@"switch"]){
                return [setting.value isEqualToString:@"true"];
            }else if([setting.type isEqualToString:@"text"]){
                return ![setting.value isEqualToString:@""];
            }else if([setting.type isEqualToString:@"button"]){
                return YES;
            }
        }
    }
    return NO;
}

-(void)disable:(NSString *)key{
    for(ShadowSetting *setting in self.prefs){
        if([setting.key isEqualToString:key]){
            if([setting.type isEqualToString:@"switch"]){
                setting.value = @"false";
            }else if([setting.type isEqualToString:@"text"]){
                setting.value = @"";
            }
        }
    }
}

-(long)indexForKey:(NSString *)key{
    for(int i = 0; i < self.prefs.count; i ++){
        if([self.prefs[i].key isEqual: key]){
            return i;
        }
    }
    return -1;
}
-(NSMutableArray<NSString*>*)orderedSections{
    NSMutableArray<NSString*> *ordered = [NSMutableArray new];
    for(int i = 0; i < self.prefs.count; i ++){
        if(![ordered containsObject:self.prefs[i].section])
            [ordered addObject: self.prefs[i].section];
    }
    return ordered;
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
