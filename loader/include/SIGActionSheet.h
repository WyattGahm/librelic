#import <UIKit/UIKit.h>


@protocol SIGActionSheetDelegate;

@interface SIGActionSheet : UIViewController
{
    NSMutableArray *_actionItems;
    NSString *_sectionHeaderText;
    NSAttributedString *_sectionHeaderAttributedText;
    unsigned long long _sectionHeaderTypographicalStyle;
    UIStackView *_stackView;
    NSArray *_headerConstraints;
    NSArray *_bodyConstraints;
    NSArray *_footerConstraints;
    UIView *_header;
    UIView *_footer;
    UIView *_backgroundView;
    UIScrollView *_containerView;
    UIView *_headerContainer;
    UIView *_footerContainer;
    id <SIGActionSheetDelegate> _delegate;
    UIViewController *_actionSheetNavigationController;
}

+ (_Bool)viewControllerIsActionSheet:(id)arg1;
@property(nonatomic) __weak UIViewController *actionSheetNavigationController;
@property(nonatomic) __weak id <SIGActionSheetDelegate> delegate;
@property(readonly, nonatomic) NSArray *actionItems;
@property(retain, nonatomic) UIView *footer;
@property(retain, nonatomic) UIView *header;
@property(retain, nonatomic) UIScrollView *containerView;
@property(retain, nonatomic) UIView *backgroundView;
- (void)_setupAutolayout;    // IMP=0x0000000106f949cc
- (double)_stackViewIntrinsicContentHeight;    // IMP=0x0000000106f94888
- (void)_updateConstraints;    // IMP=0x0000000106f93af4
- (void)_setupBody;    // IMP=0x0000000106f93820
- (void)_setupFooter;    // IMP=0x0000000106f936b4
- (void)_setupHeader;    // IMP=0x0000000106f93548
- (void)_resetActionSheetView;    // IMP=0x0000000106f93374
- (void)viewDidLayoutSubviews;    // IMP=0x0000000106f93324
- (void)viewDidLoad;    // IMP=0x0000000106f92ec0
- (void)viewWillAppear:(_Bool)arg1;    // IMP=0x0000000106f92ebc
- (void)dismissActionSheetWithCompletion:(id)arg1;    // IMP=0x0000000106f92e50
- (void)dismissActionSheet;    // IMP=0x0000000106f92e10
- (void)presentNestedActionSheet:(id)arg1;    // IMP=0x0000000106f92da4
- (void)setAttributedText:(id)arg1 typographicalStyle:(unsigned long long)arg2;    // IMP=0x0000000106f92d2c
- (void)replaceWithActionItems:(id)arg1 title:(id)arg2 headerItem:(id)arg3 footerItem:(id)arg4;    // IMP=0x0000000106f92bc0
- (id)initWithActionItems:(id)arg1 title:(id)arg2 headerItem:(id)arg3 footerItem:(id)arg4;    // IMP=0x0000000106f92a6c
- (void)replaceWithHeader:(id)arg1 title:(id)arg2 actionSheetCells:(id)arg3 footer:(id)arg4;    // IMP=0x0000000106f9a694
- (id)initWithHeader:(id)arg1 title:(id)arg2 actionSheetCells:(id)arg3 footer:(id)arg4;    // IMP=0x0000000106f9a480

@end
