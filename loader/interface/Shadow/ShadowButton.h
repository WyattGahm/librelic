#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface ShadowButton: UIImageView <UIGestureRecognizerDelegate>
@property UIImage *primary;
@property UIImage *secondary;
@property NSString *identifier;
-(instancetype)initWithPrimaryImage:(UIImage*)primary secondaryImage:(UIImage*)secondary identifier:(NSString*)key target:(id)cls action:(SEL)action;
-(void)addToVC:(UIViewController*)vc;
@end
