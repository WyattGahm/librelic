#import <Foundation/Foundation.h>

@interface ShadowOptionsManager: NSObject
@property NSMutableArray *items;
+(id)sharedInstance;
-(void)addOptionWithTitle:(NSString*)title identifier:(NSString*)identifier block:(id)action;
-(NSMutableArray*)allIdentifiers;
-(NSString*)titleForIdentifier:(NSString*)identifier;
-(id)blockForIdentifier:(NSString*)identifier;
-(BOOL)identifierExists:(NSString*)identifier;
-(void)clear;
@end
