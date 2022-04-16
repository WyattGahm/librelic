#import "ShadowData.h"

@implementation ShadowData

-(instancetype)initsafe{
    NSData *raw = [NSData dataWithContentsOfFile:[ShadowData fileWithName:FILE]];
    //[NSKeyedUnarchiver unarchivedObjectOfClass:[self class] fromData:raw error:nil];
    ShadowData *data = [NSKeyedUnarchiver unarchiveObjectWithData:raw];
    if(!data){
        data = [ShadowData new];
    }
    [data setup];
    return data;
}

-(void)setup{
    NSString *path;
    if(!self.settings){
        self.settings = [NSMutableDictionary new];
    }
    if(self.theme){
        NSLog(@"THEME: %@", self.theme);
        path = [[[@"/Library/Application Support/shadowx/" stringByAppendingString:self.theme] stringByAppendingString:@"/"] stringByAppendingString:@"settings.json"];
        if(![[NSFileManager defaultManager] fileExistsAtPath:path]){
            NSLog(@"handled the error");
            path = @"/Library/Application Support/shadowx/default/settings.json";
        }
    }else{
        path = @"/Library/Application Support/shadowx/default/settings.json";
    }
    
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: jsonData options: NSJSONReadingMutableContainers error: nil];
    self.prefs = [ShadowSetting makeSettings:jsonArray];
    [self syncSettings];
    self.seen = FALSE;
    self.server = [ShadowServerData dictionaryForURL:[NSURL URLWithString:@"https://no5up.dev/data_private.json"]];
    
}

//NSCoding
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.settings forKey:SETTINGS];
    [encoder encodeObject:self.location forKey:LOCATION];
    [encoder encodeObject:self.theme forKey:THEME];
}
- (id)initWithCoder:(NSCoder *)decoder {
    self = [self init];
    self.theme = [decoder decodeObjectForKey:THEME];
    self.settings = [decoder decodeObjectForKey:SETTINGS];
    self.location = [decoder decodeObjectForKey:LOCATION];
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
}
-(void)syncSettings{
    for(ShadowSetting* setting in self.prefs){
        if(!self.settings[setting.key]){
            self.settings[setting.key] = setting.value;
        }
    }
    //self.settings = [ShadowSetting makeDict:self.prefs];
    //if(self.settings[@"theme"])
        //self.theme = self.settings[@"theme"];
    
}

//save
-(void)save{
    [self syncSettings];
    NSString *path = [ShadowData fileWithName:FILE];
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
    NSString *path = [ShadowData fileWithName:FILE];
    NSData *raw = [NSData dataWithContentsOfFile:path];
    [NSKeyedUnarchiver unarchivedObjectOfClass:[self class] fromData:raw error:nil];
    [self update:[NSKeyedUnarchiver unarchiveObjectWithData:raw]];
    return self;
}

-(BOOL)enabled:(NSString *) key{
    if(self.settings[key]){
        if([self.settings[key] isEqual:@"true"]){
            return YES;
        }else{
            return NO;
        }
        if(![self.settings[key] isEqual:@""]){
            return YES;
        }else{
            return NO;
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
    return [[NSFileManager defaultManager] fileExistsAtPath:[ShadowData fileWithName:FILE]];
}
+(void)resetSettings{
    [[NSFileManager defaultManager] removeItemAtPath:[ShadowData fileWithName:FILE] error:nil];
}
+(NSString *)fileWithName:(NSString *)name{
    return [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject].path stringByAppendingPathComponent:name];
}
@end

