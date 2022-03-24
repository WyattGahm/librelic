
@class NSArray;
@protocol SCContextActionMenuDataSourceDelegate;

@protocol SCContextActionMenuDataSource
@property(readonly, nonatomic) NSArray *actionMenuItems;
@property(nonatomic) __weak id <SCContextActionMenuDataSourceDelegate> delegate;
@end

