#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol SCViewControllerTransitionAnimatorMaskable <NSObject>
- (struct CGRect)maskableFrame;
@end

