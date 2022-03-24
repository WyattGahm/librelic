//
//  XLLogerView.h
//  XLLogerDemo
//
//  Created by mgfjx on 2021/9/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLLogerView : UIView

@property (nonatomic, copy) void (^closeCallback) (void) ;
@property (nonatomic, strong) NSString *defaultLog ;

- (BOOL)shouldReceiveTouchAtWindowPoint:(CGPoint)pointInWindowCoordinates ;

@end

NS_ASSUME_NONNULL_END
