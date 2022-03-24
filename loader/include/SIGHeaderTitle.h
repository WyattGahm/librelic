#import <UIKit/UIView.h>

#import "SIGAnimationContext-Protocol.h"
#import "SIGHeaderEditingTextFieldDelgate-Protocol.h"
#import "SIGHeaderItemObserverDelegate-Protocol.h"

@class NSLayoutConstraint, NSObject, NSString, SIGAnimationContext, SIGHeaderEditingTextField, SIGHeaderItemKeyValueObserver, SIGLabel, UITapGestureRecognizer, UITextField;
@protocol SIGHeaderItem;

@interface SIGHeaderTitle : UIView <SIGHeaderItemObserverDelegate, SIGAnimationContext, SIGHeaderEditingTextFieldDelgate>
{
    SIGHeaderItemKeyValueObserver *_headerItemKVO;
    SIGLabel *_titleLabel;
    SIGLabel *_subtitleLabel;
    SIGLabel *_incomingTitleLabel;
    NSObject<SIGHeaderItem> *_incomingHeaderItem;
    SIGLabel *_incomingSubtitleLabel;
    SIGAnimationContext *_currentAnimation;
    NSLayoutConstraint *_subtitleHeightConstraint;
    SIGHeaderEditingTextField *_titleTextField;
    UITapGestureRecognizer *_titleLabelTapGestureRecognizer;
    UITapGestureRecognizer *_titleTextFieldTapGestureRecognizer;
    unsigned long long _style;
    NSObject<SIGHeaderItem> *_headerItem;
}

@property(readonly, nonatomic) NSObject<SIGHeaderItem> *headerItem;
@property(readonly, nonatomic) UITextField *titleTextField;
- (double)_heightForSubtitleLabel:(id)arg1;
- (void)completeAnimation:(_Bool)arg1;
- (id)_startAnimationForTransitionTo:(id)arg1 style:(long long)arg2;
- (_Bool)_headerItemViewCanTransitionInPlaceToHeaderItem:(id)arg1;
- (id)startAnimationForTransitionToHeaderItem:(id)arg1 style:(long long)arg2;
- (void)headerItem:(id)arg1 didChangeEditableTitlePlaceholderText:(id)arg2;
- (void)headerItem:(id)arg1 didChangeTitleEditable:(_Bool)arg2;
- (void)headerItem:(id)arg1 didChangeSubtitle:(id)arg2;
- (void)headerItem:(id)arg1 didChangeTitle:(id)arg2;
- (void)headerItem:(id)arg1 didChangeStyle:(unsigned long long)arg2;
- (void)SIGHeaderEditingTextFieldDidResign:(id)arg1;
- (void)_exitTitleEditMode;
- (void)_removeEditableTitle;
- (void)_titleTextFieldTapped:(id)arg1;
- (void)_titleTapped:(id)arg1;
- (void)_toggleSubtitleVisibility;
- (void)_toggleTitleVisibility;
- (id)hitTest:(struct CGPoint)arg1 withEvent:(id)arg2;
- (void)_applyStyle:(unsigned long long)arg1 toLabel:(id)arg2;
- (void)resignTextField;
- (void)setHeaderItem:(id)arg1;
- (struct CGSize)intrinsicContentSize;
- (id)initWithHeaderItem:(id)arg1;


@property(readonly, copy) NSString *debugDescription;
@property(readonly, copy) NSString *description;
@property(readonly) NSUInteger hash;
@property(readonly) Class superclass;

@end

