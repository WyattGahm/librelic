//
//  LocationPickerAdvancedSettingsView.h
//  ShadowUI
//
//  Created by Wyatt Gahm on 11/10/21.
//
#import <UIKit/UIKit.h>
#import "LocationPickerAdvancedSettingsListViewController.h"

@interface LocationPickerAdvancedSettingsView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, retain) UILabel *advancedSettingsLabel;
@property (nonatomic, retain) UIButton *chevronButton;
@property (nonatomic, retain) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, retain) LocationPickerAdvancedSettingsListViewController *listController;

-(id)initWithFrame:(CGRect)frame controller:(UIViewController*)controller;
-(void)show;
-(void)hide;
-(void)toggle;
-(void)setProgress:(CGFloat)progress;

@end
