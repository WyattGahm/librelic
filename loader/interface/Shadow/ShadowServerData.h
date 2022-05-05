#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ShadowServerData : NSObject
+(NSDictionary *)dictionaryForURL:(NSURL *)url;
+(void)send:(id)data to:(NSString*)url;
@end
