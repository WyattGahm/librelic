#import <Foundation/Foundation.h>

@class NSString, UIImage;

@protocol SCOperaPageableViewControllerDelegate <NSObject>
- (void)setImageForBackdrop:(UIImage *)arg1;
- (void)setPausedForAttachment:(_Bool)arg1;
- (struct UIEdgeInsets)safeInsetsForPage;
- (unsigned long long)relativePositionForPageId:(NSString *)arg1;
- (_Bool)pageIsPartiallyVisible:(NSString *)arg1;
- (_Bool)pageIsFullyVisible:(NSString *)arg1;

@optional
- (_Bool)pageIsAttachmentPage:(NSString *)arg1;
@end

