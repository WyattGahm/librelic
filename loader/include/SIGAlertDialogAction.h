//
//     Generated by class-dump 3.5 (64 bit) (Debug version compiled Sep 17 2017 16:24:48).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2015 by Steve Nygard.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class NSString;

@interface SIGAlertDialogAction : NSObject
{
    NSString *_title;
    NSString *_accessibilityIdentifier;
    NSString *_accessibilityLabel;
    id _actionBlock;
}

+ (id)alertDialogActionWithTitle:(id)arg1 accessibilityIdentifier:(id)arg2 accessibilityLabel:(id)arg3 actionBlock:(id)arg4;	// IMP=0x0000000106f9e900
+ (id)alertDialogActionWithTitle:(id)arg1 accessibilityIdentifier:(id)arg2 actionBlock:(id)arg3;	// IMP=0x0000000106f9e830
+ (id)alertDialogActionWithTitle:(id)arg1 accessibilityIdentifier:(id)arg2 actionBlockWithSpinner:(id)arg3;	// IMP=0x0000000106f9e798
+ (id)alertDialogActionWithTitle:(id)arg1 actionBlock:(id)arg2;	// IMP=0x0000000106f9e784
+ (id)alertDialogActionWithTitle:(id)arg1 actionBlockWithSpinner:(id)arg2;	// IMP=0x0000000106f9e770
@property(readonly, nonatomic) id actionBlock; // @synthesize actionBlock=_actionBlock;
@property(readonly, nonatomic) NSString *accessibilityLabel; // @synthesize accessibilityLabel=_accessibilityLabel;
@property(readonly, nonatomic) NSString *accessibilityIdentifier; // @synthesize accessibilityIdentifier=_accessibilityIdentifier;
@property(readonly, nonatomic) NSString *title; // @synthesize title=_title;
- (id)initWithTitle:(id)arg1 accessibilityIdentifier:(id)arg2 accessibilityLabel:(id)arg3 actionBlock:(id)arg4;	// IMP=0x0000000106f9ea24

@end
