//
//  MapViewController.m
//  find.me
//
//  Created by Emmanuel Franco on 4/25/17.
//  Copyright © 2017 Emmanuel Franco. All rights reserved.
//

#import "MapViewController.h"
#import "CityDataObject.h"

#define METERS_PER_MILE 1609.344

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    
    CGFloat lat = [self.userLocation.latitude floatValue];
    CGFloat lng = [self.userLocation.longitude floatValue];
    
    CLLocationCoordinate2D zoomLocation = CLLocationCoordinate2DMake(lat, lng);
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5 * METERS_PER_MILE, 0.5 * METERS_PER_MILE);
    
    [_mapView setRegion:viewRegion animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}


@end
