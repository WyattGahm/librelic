





#import <Foundation/Foundation.h>

@class NSArray, NSString, SIGHeaderItemTextInputTraits, UIScrollView, UIView;
@protocol SIGHeaderItemDelegate, SIGTextFieldPillDelegate, UITextFieldDelegate;

@protocol SIGHeaderItem <NSObject>
@property(nonatomic) _Bool ignoreRTL;
@property(retain, nonatomic) UIView *bottomAccessoryView;
@property(nonatomic) _Bool showsSectionTitle;
@property(nonatomic) _Bool tabBarScrollSpanTabAndCentered;
@property(copy, nonatomic) NSArray *tabBarItems;
@property(retain, nonatomic) UIView *searchFieldTrailingView;
@property(retain, nonatomic) UIView *searchFieldLeadingView;
@property(nonatomic) __weak id <SIGTextFieldPillDelegate> pillsDelegate;
@property(readonly, nonatomic) SIGHeaderItemTextInputTraits *searchFieldTextInputTraits;
@property(nonatomic) __weak id <UITextFieldDelegate> searchFieldDelegate;
@property(nonatomic, getter=isSearchFieldVisible) _Bool searchFieldVisible;
@property(copy, nonatomic) NSString *subtitle;
@property(nonatomic) __weak UIScrollView *scrollView;
@property(nonatomic, getter=isTitleAlwaysCollapsed) _Bool titleAlwaysCollapsed;
@property(nonatomic, getter=doesTitleCollapseWhenScrolled) _Bool titleCollapsesWhenScrolled;
@property(nonatomic) long long titleTextAlignment;
@property(retain, nonatomic) NSString *editableTitlePlaceholderText;
@property(nonatomic, getter=isTitleEditable) _Bool titleEditable;
@property(copy, nonatomic) NSString *title;
@property(nonatomic) _Bool trailingAccessoryViewHidden;
@property(retain, nonatomic) UIView *trailingAccessoryView;
@property(nonatomic) _Bool customLeadingAccessoryViewHidden;
@property(retain, nonatomic) UIView *customLeadingAccessoryView;
@property(nonatomic) unsigned long long dismissalAction;
@property(nonatomic) __weak id <SIGHeaderItemDelegate> delegate;
@property(nonatomic) _Bool fadeScrollEnabled;
@property(nonatomic) _Bool highlighted;
@property(nonatomic) unsigned long long style;
@property(nonatomic) _Bool hidden;
@end

