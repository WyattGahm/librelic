#import "SIGAlertDialogAction.h"
#import "SIGAlertDialog.h"
#import "ShadowData.h"
#import "XLLogerManager.h"
#import "LocationPicker.h"
#import "SCStatusBarOverlayLabelWindow.h"
#import "RainbowRoad.h"
#import "ShadowServerData.h"

@interface ShadowHelper: NSObject
+(void)screenshot;
+(void)dialogWithTitle:(NSString*)title text:(NSString*)text;
+(void)banner:(NSString*)text color:(NSString *)color alpha:(float)alpha;
+(void)banner:(NSString*)text color:(NSString *)color;
+(void)debug;
+(void)picklocation;
+(void)reset;
+(NSMutableDictionary*)identifiers;
@end
