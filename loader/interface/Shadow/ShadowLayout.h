#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ShadowLayout: NSObject
@property NSMutableDictionary<NSString*,NSMutableDictionary*> *layout;
+(NSMutableDictionary<NSString*,NSMutableDictionary*>*)defaultLayout;
-(CGRect)frameForID:(NSString*)key;
-(void)setFrameForID:(NSString*)key value:(CGRect)val;
-(CGPoint)centerForID:(NSString*)key;
-(void)setCenterForID:(NSString*)key value:(CGPoint)val;
-(void)assignData:(NSDictionary*)data;
@end
