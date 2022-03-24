//
//  LocationPicker.h
//  ShadowUI
//
//  Created by Wyatt Gahm on 11/10/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


typedef void(^LocationHandler)(NSDictionary *selection);

@interface LocationPicker:NSObject
-(void)pickLocationWithCallback:(LocationHandler)handler from:(UIViewController*)controller;
@end
