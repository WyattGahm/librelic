//
//  XLLogerManager.h
//  XLLogerDemo
//
//  Created by mgfjx on 2021/9/12.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLLogerManager : NSObject

+ (instancetype)manager ;

/// call at didFinishLaunchingWithOptions
- (void)prepare ;

@property (nonatomic, assign) BOOL enable ;

/// If YES,  the app running on the device by xcode or on simulator will use xcode console. Default NO
@property (nonatomic, assign) BOOL autoDestination ;

@property (nonatomic, copy) void (^outputCallback) (NSString *outPut) ;

/// TextView text color, default white
@property (nonatomic, strong) UIColor *textColor ;

/// TextView text size, default 12.0f
@property (nonatomic, assign) CGFloat textSize ;

/// add XLLoger View On Root window
- (void)showOnWindow ;

/// add XLLoger View On view
- (void)showOnView:(UIView *)superView ;

@end

NS_ASSUME_NONNULL_END
