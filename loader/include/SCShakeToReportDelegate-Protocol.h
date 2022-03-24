#import <Foundation/Foundation.h>

@class NSString;

@protocol SCShakeToReportDelegate <NSObject>

@optional
- (NSString *)jiraMetaInfo;
- (NSString *)defaultSubProjectName;
- (NSString *)defaultProjectNameV2;
- (void)willEndCensoringScreenshot;
- (void)willStartCensoringScreenshot;
- (_Bool)shouldDisableShakeToReportOnCurrentPage;
@end

