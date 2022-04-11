#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define FADE_SPEED 2

@interface RainbowRoad : NSObject

- (instancetype)initWithLabel:(UILabel *)label;

- (void)resume;
- (void)pause;
- (void)remove;

@end




