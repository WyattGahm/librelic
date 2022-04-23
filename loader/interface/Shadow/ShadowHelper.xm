#import "ShadowHelper.h"

@implementation ShadowHelper
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
@end

