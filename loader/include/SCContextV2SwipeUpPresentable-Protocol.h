





#import <Foundation/Foundation.h>

@class SCContextV2SwipeUpGestureTracker, UIViewController;

@protocol SCContextV2SwipeUpPresentable <NSObject>
@property(copy, nonatomic) id onContentSizeChange;
@property(copy, nonatomic) id onDismissal;
- (void)setPresentationAmount:(double)arg1 gestureTracker:(SCContextV2SwipeUpGestureTracker *)arg2;
- (void)gestureTracker:(SCContextV2SwipeUpGestureTracker *)arg1 isActivelyAnimatingPresentationAmount:(_Bool)arg2;
- (double)initialSwipeUpGesturePresentationAmount:(SCContextV2SwipeUpGestureTracker *)arg1;
- (void)presentFromBaseViewController:(UIViewController *)arg1 gestureTracker:(SCContextV2SwipeUpGestureTracker *)arg2 completion:(void (^)(void))arg3;
@end

