#import "ShadowServerData.h"

@implementation ShadowServerData
+(NSDictionary *)dictionaryForURL:(NSURL *)url{
    //if (![[UIApplication sharedApplication]canOpenURL:[url absoluteURL] ] ) return @{};
    NSData *data = [NSData dataWithContentsOfURL: url];
    if (data == nil) return @{};
    NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    return json;
}
@end
