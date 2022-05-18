#import <UIKit/UIKit.h>

@class SCActionModel;

@interface SCChatActionMenuButtonViewModel : NSObject <NSCopying>
{
    NSAttributedString *_title;
    NSAttributedString *_subtitle;
    NSString *_karmaIdentifier;
    UIImage *_image;
    SCActionModel *_dismissAction;
    SCActionModel *_tapAction;
}

@property(readonly, copy, nonatomic) SCActionModel *tapAction;
@property(readonly, copy, nonatomic) SCActionModel *dismissAction;
@property(readonly, copy, nonatomic) UIImage *image;
@property(readonly, copy, nonatomic) NSString *karmaIdentifier;
@property(readonly, copy, nonatomic) NSAttributedString *subtitle;
@property(readonly, copy, nonatomic) NSAttributedString *title;
- (_Bool)isEqual:(id)arg1;
- (unsigned long long)hash;
- (id)copyWithZone:(struct _NSZone *)arg1;
- (id)initWithTitle:(id)arg1 subtitle:(id)arg2 karmaIdentifier:(id)arg3 image:(id)arg4 imageTint:(id)arg5 displaySpinner:(BOOL)arg6 dismissAction:(id)arg7 tapAction:(id)arg8 callback:(id)arg9;

@end

