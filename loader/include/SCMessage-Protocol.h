#import <Foundation/Foundation.h>

@class SCSnapState;

@protocol SCMessage <NSObject>
- (SCSnapState *)snapState;
@end

