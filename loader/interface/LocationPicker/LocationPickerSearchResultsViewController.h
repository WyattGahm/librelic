//
//  LocationPickerSearchResultsViewController.h
//  ShadowUI
//
//  Created by Wyatt Gahm on 11/10/21.
//
#import <UIKit/UIKit.h>

@interface LocationPickerSearchResultsViewController : UITableViewController <UISearchResultsUpdating>

@property (nonatomic, retain) NSArray *items;
@property (nonatomic, retain) UIViewController *parentController;
@property (nonatomic, assign) BOOL allowDeletion;

@end
