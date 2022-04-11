#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ShadowData.h"


@interface ShadowAssets:NSObject
@property UIImage *upload;
@property UIImage *seen;
@property UIImage *save;
@property UIImage *saved;
@property UIImage *screenshot;
@property UIImage *pullrefresh;
@property UIImage *seened;
@property NSString *settings;
+ (instancetype)sharedInstance;
@end


