//
//     Generated by class-dump 3.5 (64 bit) (Debug version compiled Sep 17 2017 16:24:48).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2015 by Steve Nygard.
//

#import <objc/NSObject.h>

#import "SCContextActionMenuDataSource-Protocol.h"

@class NSArray, NSNumber, SCDisposableObserverLifecycle, SCOperaPage;
@protocol SCContextActionMenuDataSourceDelegate;

@interface SCContextActionMenuOperaDataSource : NSObject <SCContextActionMenuDataSource>
{
    SCOperaPage *_page;
    NSNumber *_isSubscribed;
    SCDisposableObserverLifecycle *_subscriptionObserverLifecycle;
    SCDisposableObserverLifecycle *_operaPageObserverLifecycle;
    NSArray *_actionMenuItems;
    id <SCContextActionMenuDataSourceDelegate> _delegate;
}

@property(nonatomic) __weak id <SCContextActionMenuDataSourceDelegate> delegate; // @synthesize delegate=_delegate;
@property(readonly, nonatomic) NSArray *actionMenuItems; // @synthesize actionMenuItems=_actionMenuItems;
- (void)_handleSubscribedUpdate:(id)arg1;	// IMP=0x000000010513b180
- (void)_pageChanged:(id)arg1;	// IMP=0x000000010513ac58
- (void)_setupSubscribeListening;	// IMP=0x000000010513a934
- (id)initWithOperaPageObservable:(id)arg1 delegate:(id)arg2;	// IMP=0x000000010513a720

@end

