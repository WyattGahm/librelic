//
//  LocationPickerSearchResultsViewController.m
//  ShadowUI
//
//  Created by Wyatt Gahm on 11/10/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LocationPickerSearchResultsViewController.h"
#import "LocationPickerViewController.h"
#import "LocationPickerView.h"

@implementation LocationPickerSearchResultsViewController

- (id)init {
    self = [super init];
    self.items = @[];
    self.allowDeletion = NO;
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    if (!searchController.searchBar.text) return;

    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = searchController.searchBar.text;

    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (response) {
            self.allowDeletion = NO;
            self.items = response.mapItems;
            [self.tableView reloadData];
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    id item = [self.items objectAtIndex:indexPath.row];

    if ([item isKindOfClass:[MKMapItem class]]) {
        MKPlacemark *placemark = ((MKMapItem *)item).placemark;
        cell.textLabel.text = placemark.name;
    } else if ([item isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = item;
        cell.textLabel.text = dict[@"Name"];
    } else {
        cell.textLabel.text = @"Error";
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(0,0);

    id item = [self.items objectAtIndex:indexPath.row];

    if ([item isKindOfClass:[MKMapItem class]]) {
        MKPlacemark *placemark = ((MKMapItem *)item).placemark;
        coord = placemark.coordinate;
    } else if ([item isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = item;
        coord = CLLocationCoordinate2DMake([dict[@"Latitude"] doubleValue], [dict[@"Longitude"] doubleValue]);
    }

    MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
    MKCoordinateRegion region = {coord, span};

    LocationPickerView *view = ((LocationPickerViewController *)self.parentController).lpView;
    if (!view.pin) [view createPinAt:coord];
    else [view.pin setCoordinate:coord];
    [view.pin setTitle:@"Selected location"];
    [view.mapView setRegion:region animated:YES];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.allowDeletion;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [((LocationPickerViewController *)self.parentController).favorites removeObjectAtIndex:indexPath.row];
        [((LocationPickerViewController *)self.parentController) updateSavedFavorites];
        [self.tableView reloadData];
    }
}

@end

