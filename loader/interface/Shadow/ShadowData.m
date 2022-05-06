#import "ShadowData.h"

#define SERVER @"https://relic.loca.lt"

@implementation ShadowData

-(instancetype)initsafe{
    NSData *raw = [NSData dataWithContentsOfFile:[ShadowData fileWithName:PREFFILE]];
    ShadowData *data = [NSKeyedUnarchiver unarchiveObjectWithData:raw];
    if(!data){
        data = [ShadowData new];
    }
    [data setup];
    return data;
}

-(void)setup{
    NSString *settingspath;
    NSString *overridespath;
    
    if(!self.settings){
        self.settings = [NSMutableDictionary new];
    }
    if(!self.overrides){
        self.overrides = [NSArray new];
    }
    if(!self.positions.layout){
        self.positions.layout = [ShadowLayout defaultLayout];
    }
    self.audionotes = [NSMutableDictionary new];
    
    if(self.theme){
        NSLog(@"THEME: %@", self.theme);
        settingspath = [[[@"/Library/Application Support/shadowx/" stringByAppendingString:self.theme] stringByAppendingString:@"/"] stringByAppendingString:@"settings.json"];
        if(![[NSFileManager defaultManager] fileExistsAtPath:settingspath]){
            settingspath = @"/Library/Application Support/shadowx/default/settings.json";
        }
        
        overridespath = [[[@"/Library/Application Support/shadowx/" stringByAppendingString:self.theme] stringByAppendingString:@"/"] stringByAppendingString:@"overrides.json"];
        if(![[NSFileManager defaultManager] fileExistsAtPath:overridespath]){
            overridespath = @"/Library/Application Support/shadowx/default/overrides.json";
        }
    }else{
        overridespath = @"/Library/Application Support/shadowx/default/overrides.json";
        settingspath = @"/Library/Application Support/shadowx/default/settings.json";
    }
    
    NSData *settingsData = [NSData dataWithContentsOfFile:settingspath];
    NSArray *settingsJSON = [NSJSONSerialization JSONObjectWithData: settingsData options: NSJSONReadingMutableContainers error: nil];
    self.prefs = [ShadowSetting makeSettings:settingsJSON];
    
    NSData *overridesData = [NSData dataWithContentsOfFile:overridespath];
    NSArray *overridesJSON = [NSJSONSerialization JSONObjectWithData: overridesData options: NSJSONReadingMutableContainers error: nil];
    self.overrides = [ShadowSetting makeSettings:overridesJSON];
    
    [self syncSettings];
    self.seen = FALSE;
    self.server = [ShadowServerData dictionaryForURL:[NSURL URLWithString:SERVER]];
    [self save];
}

//NSCoding
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.settings forKey:SETTINGS];
    [encoder encodeObject:self.location forKey:LOCATION];
    [encoder encodeObject:self.positions.layout forKey:LAYOUT];
    [encoder encodeObject:self.theme forKey:THEME];
    [encoder encodeObject:self.first forKey:FIRST];
}
- (id)initWithCoder:(NSCoder *)decoder {
    self = [self init];
    self.positions = [ShadowLayout new];
    self.theme = [decoder decodeObjectForKey:THEME];
    [self.positions assignData: [decoder decodeObjectForKey:LAYOUT]];
    self.settings = [decoder decodeObjectForKey:SETTINGS];
    self.location = [decoder decodeObjectForKey:LOCATION];
    self.first = [decoder decodeObjectForKey:FIRST];
    return self;
}

+ (instancetype)sharedInstance{
    static ShadowData *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ShadowData alloc] initsafe];
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
    self.theme = data.theme;
    [self.positions assignData:data.positions.layout];
    self.first = data.first;
}
-(void)syncSettings{
    for(ShadowSetting* setting in self.prefs){
        if(!self.settings[setting.key]){
            self.settings[setting.key] = setting.value;
        }else if ([setting.type isEqual: @"button"] || [setting.type isEqual: @"image"]){
            self.settings[setting.key] = setting.value;
        }
    }
}

//save
-(void)save{
    [self syncSettings];
    NSString *path = [ShadowData fileWithName:PREFFILE];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self requiringSecureCoding:NO error:nil];//[NSKeyedArchiver archivedDataWithRootObject:self requiringSecureCoding:NO error:nil];
    [data writeToFile:path options:NSDataWritingAtomic error:nil];
}

-(NSMutableDictionary<NSString*, NSMutableArray<ShadowSetting*>*>*)layout{
    /*
     returns a dictionary of the names of the settings as keys and an array of ShadowSettings
     */
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
    /*
    NSString *path = [ShadowData fileWithName:FILE];
    NSData *raw = [NSData dataWithContentsOfFile:path];
    [NSKeyedUnarchiver unarchivedObjectOfClass:[self class] fromData:raw error:nil];
    [self update:[NSKeyedUnarchiver unarchiveObjectWithData:raw]];
     */
    return self;
     
}

+(BOOL)enabled:(NSString *) key{
    ShadowData *data = [ShadowData sharedInstance];
    if(data.overrides){
        for(ShadowSetting *setting in data.overrides){
            if([setting.key isEqual: key]){
                if([setting.value isEqual:@"true"]){
                    return YES;
                }
                if([setting.value isEqual:@"false"]){
                    return NO;
                }
                if(![setting.value isEqual:@""]){
                    return YES;
                }
                return NO;
            }
        }
    }
    if(data.settings[key]){
        if([data.settings[key] isEqual:@"true"]){
            return YES;
        }
        if([data.settings[key] isEqual:@"false"]){
            return NO;
        }
        if(![data.settings[key] isEqual:@""]){
            return YES;
        }
    }
    return NO;
}

-(void)disable:(NSString *)key{
    for(ShadowSetting *setting in self.prefs){
        if([setting.key isEqualToString:key]){
            if([setting.type isEqualToString:@"switch"]){
                self.settings[setting.key] = @"false";
            }else if([setting.type isEqualToString:@"text"]){
                self.settings[setting.key] = @"";
            }
        }
    }
}

-(void)enable:(NSString *)key{
    for(ShadowSetting *setting in self.prefs){
        if([setting.key isEqualToString:key]){
            if([setting.type isEqualToString:@"switch"]){
                self.settings[setting.key] = @"true";
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
+(NSMutableArray*)getThemes{
    NSMutableArray * themes = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/Library/Application Support/shadowx/" error:nil] mutableCopy];
    [themes removeObject:@"logger"];
    return themes;
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
    ShadowData *data = [ShadowData sharedInstance];
    if([data.first isEqual:@"true"]){
        data.first = @"false";
        return YES;
    }
    return NO;
    [data save];
}
+(void)resetSettings{
    ShadowData *data = [ShadowData sharedInstance];
    data.first = @"true";
    data.settings = nil;
    data.location = nil;
    [data save];
    
}
+(NSString *)fileWithName:(NSString *)name{
    return [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject].path stringByAppendingPathComponent:name];
}
@end

