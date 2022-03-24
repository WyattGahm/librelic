#import <Foundation/Foundation.h>

@class SCOperaPageGestureRecognizers, UIGestureRecognizer;

@protocol SCOperaPageGestureRecognizersDelegate <NSObject>
- (void)operaPageGestureRecognizers:(SCOperaPageGestureRecognizers *)arg1 didEndGestureWithType:(long long)arg2 recognizer:(UIGestureRecognizer *)arg3;
- (void)operaPageGestureRecognizers:(SCOperaPageGestureRecognizers *)arg1 didChangeStateWithType:(long long)arg2 recognizer:(UIGestureRecognizer *)arg3;
- (void)operaPageGestureRecognizers:(SCOperaPageGestureRecognizers *)arg1 didBeginGestureWithType:(long long)arg2 recognizer:(UIGestureRecognizer *)arg3;
- (_Bool)operaPageGestureRecognizers:(SCOperaPageGestureRecognizers *)arg1 shouldRecognizeGesture:(long long)arg2;
@end

