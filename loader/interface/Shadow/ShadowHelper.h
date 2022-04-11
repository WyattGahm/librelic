#import "SIGAlertDialogAction.h"
#import "SIGAlertDialog.h"
#import "ShadowData.h"
#import "XLLogerManager.h"
#import "LocationPicker.h"
#import "SCStatusBarOverlayLabelWindow.h"

@interface ShadowHelper: NSObject
+(void)screenshot;
+(void)banner:(NSString*)text color:(NSString *)color alpha:(float)alpha;
+(void)banner:(NSString*)text color:(NSString *)color;
+(void)debug;
+(void)picklocation;
+(void)reset;
@end
