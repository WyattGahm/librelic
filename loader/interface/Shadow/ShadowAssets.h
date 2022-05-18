#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ShadowData.h"


@interface ShadowAssets:NSObject
@property UIImage *upload;
@property UIImage *seen;
@property UIImage *save;
@property UIImage *saved;
@property UIImage *screenshot;
@property UIImage *pull_normal;
@property UIImage *pull_wink;
@property UIImage *pull_rainbow;
@property UIImage *pull_shocked;
@property UIImage *pull_hands;
@property UIImage *seened;
@property UIImage *toolbar;
@property NSString *settings;
+ (instancetype)sharedInstance;
@end


