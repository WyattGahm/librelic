//
//  ShadowServerData.h
//  ShadowUI
//
//  Created by Wyatt Gahm on 11/11/21.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ShadowServerData : NSObject
+(NSDictionary *)dictionaryForURL:(NSURL *)url;
@end

@implementation ShadowServerData
+(NSDictionary *)dictionaryForURL:(NSURL *)url{
    NSLog(@"TRYING TO LOAD SERVER");
    //if (![[UIApplication sharedApplication]canOpenURL:[url absoluteURL] ] ) return @{};
    NSData *data = [NSData dataWithContentsOfURL: url];
    NSLog(@"got: %@",data);
    if (data == nil) return @{};
    NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    return json;
}
@end
