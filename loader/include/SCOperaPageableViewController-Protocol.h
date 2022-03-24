#import <Foundation/Foundation.h>

@class NSDictionary, UIGestureRecognizer, UIView;
@protocol SCOperaPageableViewControllerDelegate;

@protocol SCOperaPageableViewController <NSObject>
- (_Bool)isPausedForAttachment;
- (void)setPausedForAttachment:(_Bool)arg1;
- (void)didUpdateBottomPageViewProperties:(NSDictionary *)arg1;
- (_Bool)canHandleRoundCorner;
- (void)setPageableViewControllerDelegate:(id <SCOperaPageableViewControllerDelegate>)arg1;
- (id <SCOperaPageableViewControllerDelegate>)pageableViewControllerDelegate;
- (void)setVolume:(double)arg1;
- (long long)pageabilityForRelativePosition:(unsigned long long)arg1 gestureRecognizer:(UIGestureRecognizer *)arg2;
- (_Bool)mediaIsBeingPreparedForDisplay;
- (void)teardown;
- (void)stop;
- (void)start;
- (void)resume;
- (void)pause;
- (void)viewDidFullyDisappear;
- (void)viewWillFullyDisappear;
- (void)viewDidPartiallyAppearWithCurrentViewRelativePosition:(unsigned long long)arg1;
- (void)neighborViewDidFullyAppearWithCurrentViewRelativePosition:(unsigned long long)arg1;
- (void)viewDidFullyAppear;
- (void)viewWillFullyAppear;
- (UIView *)view;

@optional
- (long long)pageabilityForRelativePosition:(unsigned long long)arg1 navigationStyle:(long long)arg2 swipeDirection:(long long)arg3 gestureRecognizer:(UIGestureRecognizer *)arg4;
@end

