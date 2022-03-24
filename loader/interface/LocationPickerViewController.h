//
//  LocationPickerViewController.h
//  ShadowUI
//
//  Created by Wyatt Gahm on 11/10/21.
//
#import "LocationPickerView.h"
#import "LocationPickerSearchResultsViewController.h"
#import <UIKit/UIKit.h>
#import "LocationPicker.h"

@interface LocationPickerViewController : UIViewController <UISearchBarDelegate>
//exp
@property (nonatomic, copy) LocationHandler handler;

@property (nonatomic, retain) UISearchController *searchController;
@property (nonatomic, retain) LocationPickerSearchResultsViewController *searchResultsController;
@property (nonatomic, retain) UIBarButtonItem *saveButton;
@property (nonatomic, retain) LocationPickerView *lpView;
@property (nonatomic, retain) NSMutableArray *favorites;
@property (nonatomic, retain) NSMutableDictionary *dictionary;
-(void)save:(id)sender;
-(void)updateSavedFavorites;
-(id)initWithCallback:(LocationHandler)handler;
@end


