//
//  LocationPicker.m
//  ShadowUI
//
//  Created by Wyatt Gahm on 11/10/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LocationPicker.h"
#import "LocationPickerViewController.h"

//typedef void(^LocationHandler)(CLLocationCoordinate2D selection);

@implementation LocationPicker
-(void)pickLocationWithCallback:(LocationHandler)handler from:(UIViewController*)controller{
    UINavigationController *NGVC = [[UINavigationController alloc] initWithRootViewController:[[LocationPickerViewController alloc] initWithCallback:handler]];
    [controller presentViewController:NGVC animated:YES completion:nil];
}
@end
