#import <Foundation/Foundation.h>

@class UIView;
@protocol SCOperaActionBarContentView;

@protocol SCOperaActionBarContentProviding <NSObject>
- (UIView<SCOperaActionBarContentView> *)actionBarContentViewForConfiguration:(id)arg1;

@optional
- (_Bool)shouldHideActionBar;
@end

