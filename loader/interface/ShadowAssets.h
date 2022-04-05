@interface ShadowAssets:NSObject
/*
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

 - (BOOL)objectForKeyedSubscript:(id)key;
 - (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key ;
 */
@property UIImage *header;
@property UIImage *rose;
@property UIImage *upload;
@property UIImage *save;
@property UIImage *saved;
@property UIImage *done;

@end

@implementation ShadowAssets
- (id)init{
    self = [super init];
    //self.header = [ShadowAssets download:@"https://cdn.discordapp.com/attachments/953505592759177268/960604026410532864/shadow_x_relic.png"];
    //self.header = [ShadowAssets download:@"https://cdn.discordapp.com/attachments/953505592759177268/960766335346950194/SIX_D1FE30A9-FF97-426B-9ABC-69B2C15BB28B.png"];
    self.header = [UIImage imageWithContentsOfFile:@"/Library/Application Support/shadowx/header1.png"];
    return self;
}

+ (UIImage *)download:(NSString*)url{
    return [UIImage imageWithData: [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: url]]];
}

+ (instancetype)sharedInstance{
    static ShadowAssets *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ShadowAssets alloc] init];
    });
    return sharedInstance;
}

@end

