





#import <Foundation/Foundation.h>

@class NSArray, NSObject, NSString, UIView;
@protocol SIGHeaderItem, SIGTextFieldPillDelegate, UITextFieldDelegate;

@protocol SIGHeaderItemObserverDelegate <NSObject>

@optional
- (void)headerItem:(NSObject<SIGHeaderItem> *)arg1 didChangeSmartInsertDeleteType:(long long)arg2;
- (void)headerItem:(NSObject<SIGHeaderItem> *)arg1 didChangeSmartDashesType:(long long)arg2;
- (void)headerItem:(NSObject<SIGHeaderItem> *)arg1 didChangeSmartQuotesType:(long long)arg2;
- (void)headerItem:(NSObject<SIGHeaderItem> *)arg1 didChangeTextContentType:(NSString *)arg2;
- (void)headerItem:(NSObject<SIGHeaderItem> *)arg1 didChangeSecureTextEntry:(_Bool)arg2;
- (void)headerItem:(NSObject<SIGHeaderItem> *)arg1 didChangeEnablesReturnKeyAutomatically:(_Bool)arg2;
- (void)headerItem:(NSObject<SIGHeaderItem> *)arg1 didChangeReturnKeyType:(long long)arg2;
- (void)headerItem:(NSObject<SIGHeaderItem> *)arg1 didChangeKeyboardAppearance:(long long)arg2;
- (void)headerItem:(NSObject<SIGHeaderItem> *)arg1 didChangeKeyboardType:(long long)arg2;
- (void)headerItem:(NSObject<SIGHeaderItem> *)arg1 didChangeSpellCheckingType:(long long)arg2;
- (void)headerItem:(NSObject<SIGHeaderItem> *)arg1 didChangeAutocorrectionType:(long long)arg2;
- (void)headerItem:(NSObject<SIGHeaderItem> *)arg1 didChangeAutocapitalizationType:(long long)arg2;
- (void)headerItem:(NSObject<SIGHeaderItem> *)arg1 didChangeSearchFieldTrailingView:(UIView *)arg2;
- (void)headerItem:(NSObject<SIGHeaderItem> *)arg1 didChangeSearchFieldLeadingView:(UIView *)arg2;
- (void)headerItem:(NSObject<SIGHeaderItem> *)arg1 didChangePillsDelegate:(id <SIGTextFieldPillDelegate>)arg2;
- (void)headerItem:(NSObject<SIGHeaderItem> *)arg1 didChangeSearchFieldDelegate:(id <UITextFieldDelegate>)arg2;
- (void)headerItem:(NSObject<SIGHeaderItem> *)arg1 didChangeSearchFieldVisible:(_Bool)arg2;
- (void)headerItem:(NSObject<SIGHeaderItem> *)arg1 didChangeTabBarScrollSpanTabAndCentered:(_Bool)arg2;
- (void)headerItem:(NSObject<SIGHeaderItem> *)arg1 didChangeTabBarItems:(NSArray *)arg2;
- (void)headerItem:(NSObject<SIGHeaderItem> *)arg1 didChangeTitleTextAlignment:(long long)arg2;
- (void)headerItem:(NSObject<SIGHeaderItem> *)arg1 didChangeEditableTitlePlaceholderText:(NSString *)arg2;
- (void)headerItem:(NSObject<SIGHeaderItem> *)arg1 didChangeTitleEditable:(_Bool)arg2;
- (void)headerItem:(NSObject<SIGHeaderItem> *)arg1 didChangeTitleCollapsesWhenScrolled:(_Bool)arg2;
- (void)headerItem:(NSObject<SIGHeaderItem> *)arg1 didChangeTitleAlwaysCollapsed:(_Bool)arg2;
- (void)headerItem:(NSObject<SIGHeaderItem> *)arg1 didChangeSubtitle:(NSString *)arg2;
- (void)headerItem:(NSObject<SIGHeaderItem> *)arg1 didChangeTitle:(NSString *)arg2;
- (void)headerItem:(NSObject<SIGHeaderItem> *)arg1 didChangeBottomAccessoryView:(UIView *)arg2;
- (void)headerItem:(NSObject<SIGHeaderItem> *)arg1 didChangeDismissalAction:(unsigned long long)arg2;
- (void)headerItem:(NSObject<SIGHeaderItem> *)arg1 didChangeCustomLeadingAccessoryViewHidden:(_Bool)arg2;
- (void)headerItem:(NSObject<SIGHeaderItem> *)arg1 didChangeCustomLeadingAccessoryView:(UIView *)arg2;
- (void)headerItem:(NSObject<SIGHeaderItem> *)arg1 didChangeTrailingAccessoryViewHidden:(_Bool)arg2;
- (void)headerItem:(NSObject<SIGHeaderItem> *)arg1 didChangeTrailingAccessoryView:(UIView *)arg2;
- (void)headerItem:(NSObject<SIGHeaderItem> *)arg1 didChangeIgnoreRTL:(_Bool)arg2;
- (void)headerItem:(NSObject<SIGHeaderItem> *)arg1 didChangeHighlighted:(_Bool)arg2;
- (void)headerItem:(NSObject<SIGHeaderItem> *)arg1 didChangeStyle:(unsigned long long)arg2;
- (void)headerItem:(NSObject<SIGHeaderItem> *)arg1 didChangeShowsSectionTitle:(_Bool)arg2;
- (void)headerItem:(NSObject<SIGHeaderItem> *)arg1 didChangeHidden:(_Bool)arg2;
@end

