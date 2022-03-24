@class NSString, UIPanGestureRecognizer, UIView, UIViewController;
@protocol SCContextV2SwipeUpGestureDelegate, SCContextV2SwipeUpPresentable;

@interface SCContextV2SwipeUpGestureTracker : NSObject <UIGestureRecognizerDelegate>
{
    UIPanGestureRecognizer *_panRec;
    _Bool _panRecIsLockedIn;
    _Bool _enabled;
    id _delegate;
    UIViewController *_presentedViewController;
    UIView *_attachedToView;
    double _presentationAmount;
}

+ (id)_animatableProperty;    // IMP=0x000000010514cecc
@property(nonatomic) double presentationAmount; // @synthesize presentationAmount=_presentationAmount;
@property(nonatomic) __weak UIView *attachedToView; // @synthesize attachedToView=_attachedToView;
@property(nonatomic) _Bool enabled; // @synthesize enabled=_enabled;
@property(nonatomic) __weak UIViewController *presentedViewController; // @synthesize presentedViewController=_presentedViewController;
@property(nonatomic) __weak id  delegate; // @synthesize delegate=_delegate;
- (id)_createContextActionSourceWithActionType:(long long)arg1;    // IMP=0x000000010514d0a0
- (double)_swipeUpDistance;    // IMP=0x000000010514ce68
- (void)_swipeUpVCDidDismissViaSwipe:(_Bool)arg1;    // IMP=0x000000010514cd90
- (void)_updateViewAttachment;    // IMP=0x000000010514c8e8
- (void)setPresented:(_Bool)arg1 animated:(_Bool)arg2 source:(id)arg3 completion:(id)arg4;    // IMP=0x000000010514c084
- (void)detatchGestureFromView:(id)arg1;    // IMP=0x000000010514bffc
- (void)attachGestureToView:(id)arg1;    // IMP=0x000000010514bff0
- (_Bool)gestureRecognizer:(id)arg1 shouldReceiveTouch:(id)arg2;    // IMP=0x000000010514bf64
- (_Bool)gestureRecognizer:(id)arg1 shouldRecognizeSimultaneouslyWithGestureRecognizer:(id)arg2;    // IMP=0x000000010514bf5c
- (void)_panned:(id)arg1;    // IMP=0x000000010514ba20
- (id)init;    // IMP=0x000000010514b938

// Remaining properties
@property(readonly, copy) NSString *debugDescription;
@property(readonly, copy) NSString *description;
@property(readonly) NSUInteger hash;
@property(readonly) Class superclass;

@end

