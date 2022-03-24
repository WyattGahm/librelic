//
//  XLWindow.h
//  XLLoger
//
//  Created by mgfjx on 2021/9/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XLWindowEventDelegate <NSObject>

- (BOOL)shouldHandleTouchAtPoint:(CGPoint)pointInWindow;
@optional
- (BOOL)canBecomeKeyWindow;

@end

@interface XLWindow : UIWindow

@property (nonatomic, weak) id <XLWindowEventDelegate> eventDelegate;

/// Tracked so we can restore the key window after dismissing a modal.
/// We need to become key after modal presentation so we can correctly capture input.
/// If we're just showing the toolbar, we want the main app's window to remain key
/// so that we don't interfere with input, status bar, etc.
@property (nonatomic, readonly) UIWindow *previousKeyWindow;


@end

NS_ASSUME_NONNULL_END
