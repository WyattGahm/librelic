#import <Foundation/Foundation.h>

@class NSString, SCAttributedPage;
@protocol SCNavigationLogging;

@protocol SCPageNameLogging <NSObject>
- (NSString *)pageViewName;

@optional
@property(nonatomic, retain) id <SCNavigationLogging> PPVNavigationLogger;
- (SCAttributedPage *)attributedPage;
@end

