





#import <Foundation/Foundation.h>

@class NSString, UIView;

@protocol SCComposerViewOwner <NSObject>

@optional
- (void)didRenderComposerView:(UIView *)arg1;
- (_Bool)composerWillTeardownView:(UIView *)arg1;
- (UIView *)composerWillCreateViewForClass:(Class)arg1 nodeId:(NSString *)arg2;
- (void)didAwakeViewFromComposer:(UIView *)arg1;
@end

