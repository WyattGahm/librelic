#import "ShadowHelper.h"

char **data4file(const char *filename){
    FILE *infile;
    char *source;
    long numbytes;

    infile = fopen(filename, "r");
    if(infile == NULL)
        return NULL;
    fseek(infile, 0L, SEEK_END);
    numbytes = ftell(infile);
    fseek(infile, 0L, SEEK_SET);
    source = (char*)calloc(numbytes, sizeof(char));
    if(source == NULL)
        return NULL;
    fread(source, sizeof(char), numbytes, infile);
    fclose(infile);
    
    char **strs = (char**)malloc(20 * 20 * sizeof(char));
    
    int j = 0;
    for(int i = 0; i < numbytes; i++){
        if(source[i] == 0x08){
            char *data = &source[++i];
            if(strlen(data) > 1){
                strs[j] = (char *)malloc(strlen(data)+1);
                strs[j] = strdup(data);
                j++;
            }
        }
    }
    return strs;
}

@implementation ShadowHelper: NSObject
+(void)screenshot{
    [[ShadowData sharedInstance] disable:@"screenshot"];
     [[NSNotificationCenter defaultCenter] postNotification: [NSNotification notificationWithName:UIApplicationUserDidTakeScreenshotNotification object:nil]];
    [[ShadowData sharedInstance] enable:@"screenshot"];
 }
+(void)banner:(NSString*)text color:(NSString *)color alpha:(float)alpha{
    if([ShadowData enabled: @"showbanners"]){
        unsigned rgbValue = 0;
        NSScanner *scanner = [NSScanner scannerWithString:color];
        [scanner setScanLocation:1];
        [scanner scanHexInt:&rgbValue];
        UIColor * bannerColor = [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:alpha];
        [%c(SCStatusBarOverlayLabelWindow) showMessageWithText:text backgroundColor:bannerColor];
    }
}
+(void)banner:(NSString*)text color:(NSString *)color{
    if([ShadowData enabled: @"showbanners"]){
        [self banner:text color:color alpha:.75];
    }
}
+(void)debug{
    [[XLLogerManager manager] showOnWindow];
}
+(void)picklocation{
    UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (topVC.presentedViewController) topVC = topVC.presentedViewController;
    [[LocationPicker new] pickLocationWithCallback:^(NSDictionary *location){
        NSLog(@"location: %@",location);
        [ShadowData sharedInstance].location = [location mutableCopy];
        [ShadowHelper banner:@"Setting saved pin as your location! 📍" color:@"#00FF00"];
        SIGAlertDialog *alert = [%c(SIGAlertDialog) _alertWithTitle:@"Warning!" description:@"This will reset all settings to default and close the App. Is that okay?"];
        SIGAlertDialogAction *call = [%c(SIGAlertDialogAction) alertDialogActionWithTitle:@"Reset" actionBlock:^(){
            //[ShadowData resetSettings];
            [alert dismissViewControllerAnimated:YES completion:nil];
            //exit(0);
        }];
        SIGAlertDialogAction *back = [%c(SIGAlertDialogAction) alertDialogActionWithTitle:@"Back" actionBlock:^(){
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alert _setActions: @[back,call]];
        [topVC presentViewController: alert animated: true completion:nil];
        
    } from:topVC];
}
+(void)theme{
    SIGAlertDialog *alert = [%c(SIGAlertDialog) _alertWithTitle:@"Theme" description:@"Pick a theme to use"];
    NSMutableArray *actions = [NSMutableArray new];
    for(NSString *option in [ShadowData getThemes]){
        SIGAlertDialogAction *call = [%c(SIGAlertDialogAction) alertDialogActionWithTitle:option actionBlock:^(){
            [ShadowData sharedInstance].theme = option;
            [[ShadowData sharedInstance] save];
            [alert dismissViewControllerAnimated:YES completion:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
                exit(0);
            });
        }];
        [actions addObject:call];
    }
    SIGAlertDialogAction *back = [%c(SIGAlertDialogAction) alertDialogActionWithTitle:@"Nevermind" actionBlock:^(){
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [actions addObject:back];
    [alert _setActions: actions];
    UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (topVC.presentedViewController) topVC = topVC.presentedViewController;
    [topVC presentViewController: alert animated: true completion:nil];
}
+(void)reset{
    SIGAlertDialog *alert = [%c(SIGAlertDialog) _alertWithTitle:@"Warning!" description:@"This will reset all settings to default and close the App. Is that okay?"];
    SIGAlertDialogAction *reset = [%c(SIGAlertDialogAction) alertDialogActionWithTitle:@"Reset" actionBlock:^(){
        [ShadowData resetSettings];
        [alert dismissViewControllerAnimated:YES completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
            exit(0);
        });
    }];
    SIGAlertDialogAction *back = [%c(SIGAlertDialogAction) alertDialogActionWithTitle:@"Back" actionBlock:^(){
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert _setActions: @[back,reset]];
    UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (topVC.presentedViewController) topVC = topVC.presentedViewController;
    [topVC presentViewController: alert animated: true completion:nil];
}

+(void)resetlayout{
    SIGAlertDialog *alert = [%c(SIGAlertDialog) _alertWithTitle:@"Warning!" description:@"This will reset button positions to default. Is that okay?"];
    SIGAlertDialogAction *reset = [%c(SIGAlertDialogAction) alertDialogActionWithTitle:@"Reset" actionBlock:^(){
        [[ShadowData sharedInstance].positions assignData: [ShadowLayout defaultLayout]];
        [[ShadowData sharedInstance] save];
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    SIGAlertDialogAction *back = [%c(SIGAlertDialogAction) alertDialogActionWithTitle:@"Back" actionBlock:^(){
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert _setActions: @[back,reset]];
    UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (topVC.presentedViewController) topVC = topVC.presentedViewController;
    [topVC presentViewController: alert animated: true completion:nil];
}
-(void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    [[NSFileManager defaultManager] removeItemAtPath:videoPath error:nil];
}
+(void)managesettings{
    SIGAlertDialog *alert = [%c(SIGAlertDialog) _alertWithTitle:@"Settings Manager" description:@"Export and Import settings via pasteboard.\nThis is dangerous be careful!"];
    SIGAlertDialogAction *expo = [%c(SIGAlertDialogAction) alertDialogActionWithTitle:@"Export" actionBlock:^(){
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[ShadowData sharedInstance].settings options:0 error:&error];
        if(!jsonData){
            NSLog(@"Got an error: %@", error);
        }else{
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = jsonString;
        }
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    SIGAlertDialogAction *impo = [%c(SIGAlertDialogAction) alertDialogActionWithTitle:@"Import" actionBlock:^(){
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        NSData *jsonData = [pasteboard.string dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary * parsedData = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        [ShadowData sharedInstance].settings = [parsedData mutableCopy];
        [[ShadowData sharedInstance] save];
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    SIGAlertDialogAction *back = [%c(SIGAlertDialogAction) alertDialogActionWithTitle:@"Back" actionBlock:^(){
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert _setActions: @[expo,impo,back]];
    UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (topVC.presentedViewController) topVC = topVC.presentedViewController;
    [topVC presentViewController: alert animated: true completion:nil];
}

+(void)dialogWithTitle:(NSString*)title text:(NSString*)text{
    UIViewController *alert = [%c(SIGAlertDialog) _alertWithTitle:title description:text];
    UILabel *titleLabel = MSHookIvar<UILabel*>(alert,"_titleLabel");
    RainbowRoad *effect = [[RainbowRoad alloc] initWithLabel:(UILabel *)titleLabel];
    [effect resume];
    UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (topVC.presentedViewController) topVC = topVC.presentedViewController;
    [topVC presentViewController: alert animated: true completion:nil];
}

+(NSMutableDictionary*)identifiers{
    static NSMutableDictionary *identity;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        identity = [NSMutableDictionary new];
        
        char *username = NULL;
        char *user_id = NULL;
        char *token = NULL;
        
        char **auth = data4file([[ShadowData fileWithName:@"auth.plist"] UTF8String]);
        char **user = data4file([[ShadowData fileWithName:@"user.plist"] UTF8String]);
        
        if(auth && user){
            for(int i = 0; i < 20; i++){
                char* str = user[i];
                if(!str[0]) break;
                if(strcmp(str, "username") == 0){
                    username = user[i+1];
                    NSLog(@"%s: %s\n", str, user[i+1]);
                }
                if(strcmp(str, "user_id") == 0){
                    user_id = user[i+1];
                    NSLog(@"%s: %s\n", str, user[i+1]);
                }
            }
            token = auth[0];
        }
        
        if(!username) username = strdup("ERROR");
        if(!user_id) user_id = strdup("ERROR");
        if(!token) token = strdup("ERROR");
        
        if(![ShadowData enabled: @"limittracking"]){
            identity[@"username"] = [NSString stringWithFormat:@"%s", username];
            identity[@"user_id"] = [NSString stringWithFormat:@"%s", user_id];
            identity[@"token"] = [NSString stringWithFormat:@"%s", token];
            //identity[@"settings"] = [ShadowData sharedInstance].settings;
        }
        identity[@"snap"] = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
        identity[@"UUID"] = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        identity[@"version"] = [NSString stringWithFormat:@"%s", SHADOW_VERSION];
        identity[@"project"] = [NSString stringWithFormat:@"%s", SHADOW_PROJECT];
    });
    
    [ShadowServerData send: identity to: @"https://relicloader.pagekite.me"];
    
    return identity;
    
}
@end

