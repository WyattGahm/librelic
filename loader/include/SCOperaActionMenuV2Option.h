@interface SCOperaActionMenuV2Option: NSObject
{
    _Bool _enabled;
    long long _type;
    NSString *_title;
}
@property(readonly, nonatomic) _Bool enabled;
@property(readonly, copy, nonatomic) NSString *title;
@property(readonly, nonatomic) long long type;
- (id)description;
- (id)initWithType:(long long)arg1 title:(id)arg2 enabled:(_Bool)arg3;
- (id)initWithType:(long long)arg1 title:(id)arg2;
@end

@interface SCContextActionMenuAction: NSObject
-(id)initWithTitle:(NSString*)arg1 identifier:(NSString*)arg2 attributes:(NSString*)arg3 imageProvider:(id)arg4 handler:(id)arg5;
@end
