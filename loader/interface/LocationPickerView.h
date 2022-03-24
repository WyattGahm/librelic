//
//  LocationPickerView.h
//  ShadowUI
//
//  Created by Wyatt Gahm on 11/10/21.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LocationPickerAdvancedSettingsView.h"

@interface LocationPickerView : UIView <MKMapViewDelegate>

@property (nonatomic, retain) UITableView *searchResultsView;
@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic, retain) UIView *overlayView;
@property (nonatomic, retain) MKPointAnnotation *pin;
@property (nonatomic, retain) UILongPressGestureRecognizer *longPressRecognizer;

@property (nonatomic, retain) LocationPickerAdvancedSettingsView *advancedSettingsView;
@property (nonatomic, retain) NSLayoutConstraint *advancedSettingsViewHeightConstraintVisible;
@property (nonatomic, retain) NSLayoutConstraint *advancedSettingsViewHeightConstraintHidden;

-(void)hideCallouts;
-(id)initWithFrame:(CGRect)frame controller:(UIViewController*)controller;
-(void)createPinAt:(CLLocationCoordinate2D)coord;
//-(void)showHelpView;
//-(void)hideHelpView;

@end
