#import <Foundation/Foundation.h>

@class NSArray;
@protocol SCPerforming;

@protocol SCOperaShareableMediaItemsProviding <NSObject>
- (NSArray *)shareableMediaSnapshotsWithPerformer:(id <SCPerforming>)arg1;
- (NSArray *)shareableMedias;
@end

