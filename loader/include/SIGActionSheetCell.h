#import "SIGCell.h"

#import <Foundation/Foundation.h>

@class NSString, SIGActionSheet, SIGLoadingIndicatorView, SIGTargetActionDispatcher, UILongPressGestureRecognizer;

@interface SIGActionSheetCell : SIGCell <UIGestureRecognizerDelegate>
{
    SIGTargetActionDispatcher *_eventDispatcher;
    _Bool _actionSpecified;
    UILongPressGestureRecognizer *_longPressGestureRecognizer;
    SIGLoadingIndicatorView *_loadingIndicator;
    SIGActionSheet *_actionSheet;
    id _action;
}

+ (id)cardWithTitleText:(id)arg1 detailText:(id)arg2;
+ (id)cardWithImage:(id)arg1 titleText:(id)arg2;
+ (id)footerCellWithText:(id)arg1;
+ (id)sendToCellWithText:(id)arg1;
+ (id)sendToCellWithText:(id)arg1 isCompressed:(_Bool)arg2;
+ (id)switchCellWithText:(id)arg1 value:(_Bool)arg2;
+ (id)switchCellWithText:(id)arg1 value:(_Bool)arg2 compressed:(_Bool)arg3;
+ (id)selectCellWithText:(id)arg1 value:(_Bool)arg2;
+ (id)selectCellWithText:(id)arg1 value:(_Bool)arg2 compressed:(_Bool)arg3;
+ (id)moreOptionsCellWithText:(id)arg1;
+ (id)moreOptionsCellWithText:(id)arg1 compressed:(_Bool)arg2;
+ (id)descriptionCellWithText:(id)arg1 description:(id)arg2;
+ (id)valueCellWithText:(id)arg1 value:(id)arg2;
+ (id)loadingCellWithStyle:(unsigned long long)arg1;
+ (id)loadingCell;
+ (id)tallCellWithText:(id)arg1;
+ (id)errorCellWithText:(id)arg1;
+ (id)destructiveOptionCellWithText:(id)arg1;
+ (id)optionCellWithText:(id)arg1;
+ (id)optionCellWithText:(id)arg1 isCompressed:(_Bool)arg2;
@property(copy, nonatomic) id action;
@property(nonatomic) __weak SIGActionSheet *actionSheet;
- (_Bool)gestureRecognizer:(id)arg1 shouldRecognizeSimultaneouslyWithGestureRecognizer:(id)arg2;
- (void)didMoveToWindow;
- (void)_sendActions;
- (void)_addTarget:(id)arg1 action:(SEL)arg2;
- (void)setEnabled:(_Bool)arg1;
- (void)setSelected:(_Bool)arg1 animated:(_Bool)arg2;
- (void)_createLoadingIndicatorIfNeeded;
- (void)_onLongPress:(id)arg1;
- (void)_possiblyInvokeActionBlock;
- (void)_assertValidActionSheet;
- (void)_markActionSpecifiedOrAssert;
- (id)target:(id)arg1 action:(SEL)arg2;
- (id)block:(id)arg1;
- (id)initWithStyle:(unsigned long long)arg1;


@property(readonly, copy) NSString *debugDescription;
@property(readonly, copy) NSString *description;
@property(readonly) NSUInteger hash;
@property(readonly) Class superclass;

@end

