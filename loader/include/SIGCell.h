





#import <UIKit/UIView.h>

@class NSArray, NSAttributedString, NSString, SIGLabel, UIColor, UIImageView, UILayoutGuide;
@protocol SIGCellDetailTextFormatDelegate;

@interface SIGCell : UIView
{
    NSArray *_leadingAccessoryViewConstraints;
    UILayoutGuide *_labelsLayoutGuide;
    NSArray *_labelsContainerConstraints;
    NSArray *_titleLabelConstraints;
    NSArray *_detailLabelConstraints;
    NSArray *_alternateLabelConstraints;
    NSArray *_trailingAccessoryViewConstraints;
    UIImageView *_actionIndicatorView;
    UIImageView *_officialBadgeView;
    NSArray *_actionIndicatorConstraints;
    NSArray *_officialBadgeConstraints;
    _Bool _alternateLabelIsValue;
    UIColor *_preHighlightBackgroundColor;
    double _detailLabelFrameWidthDuringLastLayout;
    _Bool _selected;
    _Bool _highlighted;
    _Bool _enabled;
    _Bool _adjustsHeightAccommodatingExtraLines;
    _Bool _destructive;
    _Bool _centered;
    unsigned long long _style;
    UIColor *_highlightColor;
    UIView *_leadingAccessoryView;
    unsigned long long _officialBadgeType;
    NSString *_badgeText;
    UIView *_trailingAccessoryView;
    unsigned long long _actionIndicator;
    unsigned long long _textStyle;
    id <SIGCellDetailTextFormatDelegate> _detailTextFormatDelegate;
    SIGLabel *_textLabel;
    SIGLabel *_detailLabel;
    SIGLabel *_alternateLabel;
    struct UIEdgeInsets _edgeInsets;
}

+ (unsigned long long)_typographicalStyleForTextStyle:(unsigned long long)arg1;
+ (double)computedHeightThatFits:(struct CGSize)arg1 titleText:(id)arg2 detailText:(id)arg3 titleTextStyle:(unsigned long long)arg4 isCentered:(_Bool)arg5;
+ (double)computedHeightThatFits:(struct CGSize)arg1 cellStyle:(unsigned long long)arg2 titleText:(id)arg3 detailText:(id)arg4 titleTextStyle:(unsigned long long)arg5 badgeText:(id)arg6 trailingAccessoryViewWidth:(double)arg7 leadingAccessoryViewWidth:(double)arg8 isCentered:(_Bool)arg9;
+ (struct CGSize)badgeTextSizeThatFits:(struct CGSize)arg1 withText:(id)arg2;
+ (struct CGSize)detailTextSizeThatFits:(struct CGSize)arg1 withText:(id)arg2 isCentered:(_Bool)arg3;
+ (struct CGSize)titleTextSizeThatFits:(struct CGSize)arg1 withText:(id)arg2 andTitleTextStyle:(unsigned long long)arg3 isCentered:(_Bool)arg4;
+ (double)heightForCellWithStyle:(unsigned long long)arg1;
+ (id)tallCellWithAvatar;
+ (id)tallCell;
+ (id)compressedCellWithAvatar;
+ (id)compressedCell;
+ (id)standardCellWithAvatar;
+ (id)standardCell;

@property(nonatomic) struct UIEdgeInsets edgeInsets;
@property(readonly, nonatomic) SIGLabel *alternateLabel;
@property(readonly, nonatomic) SIGLabel *detailLabel;
@property(readonly, nonatomic) SIGLabel *textLabel;
@property(nonatomic) __weak id <SIGCellDetailTextFormatDelegate> detailTextFormatDelegate;
@property(nonatomic, getter=isCentered) _Bool centered;
@property(nonatomic, getter=isDestructive) _Bool destructive;
@property(nonatomic) unsigned long long textStyle;
@property(nonatomic) unsigned long long actionIndicator;
@property(retain, nonatomic) UIView *trailingAccessoryView;
@property(copy, nonatomic) NSString *badgeText;
@property(nonatomic, getter=getOfficialBadgeType) unsigned long long officialBadgeType;
@property(nonatomic) _Bool adjustsHeightAccommodatingExtraLines;
@property(retain, nonatomic) UIView *leadingAccessoryView;
@property(nonatomic, getter=isEnabled) _Bool enabled;
@property(retain, nonatomic) UIColor *highlightColor;
@property(nonatomic, getter=isHighlighted) _Bool highlighted;
@property(nonatomic, getter=isSelected) _Bool selected;
@property(readonly, nonatomic) unsigned long long style;
- (id)_selectedTextColor;
- (id)_textColor;
- (unsigned long long)_selectedTypographicalStyleForTextStyle:(unsigned long long)arg1;
- (_Bool)_shouldChangeTextAppearanceOnSelectedState;
- (void)_stylizeTextLabel;
- (id)_constraintsForBadge;
- (void)_updateConstraintsForOfficialBadge;
- (id)_constraintsForActionIndicator;
- (void)_updateConstraintsForActionIndicator;
- (id)_constraintsForTrailingAccessoryView;
- (void)_updateConstraintsForTrailingAccessoryView;
- (void)_configureLayoutDirection;
- (id)_constraintsForAlternateLabel;
- (void)_updateConstraintsForAlternateLabel;
- (id)_constraintsForDetailsLabel;
- (void)_updateConstraintsForDetailLabel;
- (id)_constraintsForTitleLabel;
- (void)_updateConstraintsForTitleLabel;
- (double)_labelsContainerTrailingConstraint;
- (double)_labelsContainerLeadingConstraint;
- (id)_constraintsForLabelsContainer;
- (void)_updateConstraintsForLabelsContainer;
- (id)_constraintsForLeadingAccessoryView;
- (void)_updateConstraintsForLeadingAccessoryView;
- (void)_setupAutolayoutConstraints;
- (void)_createAlternateLabelIfNeeded;
- (void)_createDetailsLabelIfNeeded;
- (struct CGSize)sizeThatFits:(struct CGSize)arg1;
- (struct CGSize)intrinsicContentSize;
@property(copy, nonatomic) NSString *valueText;
@property(copy, nonatomic) NSString *emojiText;
@property(copy, nonatomic) NSAttributedString *attributedDetailText;
- (void)_resetDetailText;
- (void)setDetailTextTruncationDelegate:(id)arg1;
- (id)_getDetailTextFromFormatDelegateUsingText:(id)arg1;
@property(copy, nonatomic) NSString *detailText;
@property(copy, nonatomic) NSAttributedString *attributedTitleText;
@property(nonatomic) _Bool adjustsTitleFontSizeToFitWidth;
@property(copy, nonatomic) NSString *titleText;
- (void)setSelected:(_Bool)arg1 animated:(_Bool)arg2;
- (void)traitCollectionDidChange:(id)arg1;
- (void)layoutSubviews;
- (id)initWithStyle:(unsigned long long)arg1;

@end

