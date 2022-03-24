#import <Foundation/Foundation.h>

@class NSHashTable;

@protocol SCOperaFadeTransitionCompatibleViewController <NSObject>
- (NSHashTable *)fadingViewsForFadeTransition;
- (NSHashTable *)movingViewsForFadeTransition;
@end

