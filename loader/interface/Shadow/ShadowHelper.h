#import "SIGAlertDialogAction.h"
#import "SIGAlertDialog.h"
#import "ShadowData.h"
#import "XLLogerManager.h"
#import "LocationPicker.h"
#import "SCStatusBarOverlayLabelWindow.h"
#import "RainbowRoad.h"
#import "ShadowServerData.h"
#import "SIGActionSheet.h"
#import "SIGActionSheetCell.h"

@interface ShadowHelper: NSObject
+(void)screenshot;
+(void)dialogWithTitle:(NSString*)title text:(NSString*)text;
+(void)banner:(NSString*)text color:(NSString *)color alpha:(float)alpha;
+(void)banner:(NSString*)text color:(NSString *)color;
+(void)debug;
+(void)picklocation;
+(void)reset;
+(NSMutableDictionary*)identifiers;
+(void)popup:(NSString*)title text:(NSString*)text yes:(NSString*)yes no:(NSString*)no action:(void (^)(BOOL))action;
@end
