#import <Foundation/Foundation.h>

@protocol SCOperaLayerViewControllerMediaContainer <NSObject>
- (double)mediaHeightToWidthAspectRatio;
- (_Bool)isOverlay;
- (struct CGRect)mediaViewFrame;
@end

