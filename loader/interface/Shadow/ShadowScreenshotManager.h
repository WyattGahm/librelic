#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ShadowData.h"
#import "ShadowHelper.h"

typedef void (^scblock)();

@interface ShadowScreenshotManager: NSObject
@property BOOL pending;
@property NSMutableArray *calls;
-(void)handle:(scblock)pass;
+(id)sharedInstance;

@end



