//
//  HomeViewController.m
//  find.me
//
//  Created by Emmanuel Franco on 4/17/17.
//  Copyright © 2017 Emmanuel Franco. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "CityDataObject.h"
#import "LocationDisplayViewController.h"
#import "LocationManager.h"

#define PUSH_TO_LOCATION_VIEW @"pushToLocationDisplay"

@interface HomeViewController ()<LocationManagerDelegate>

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationDisplayViewController = [[LocationDisplayViewController alloc] initWithNibName:@"LocationDisplayViewController" bundle:[NSBundle mainBundle]];
}

-(void)viewDidAppear:(BOOL)animated
{
    AppDelegate* appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    [appDelegate.locationManager setDelegate:self];
    
    [appDelegate.locationManager startUpdates];
}

-(void)viewDidDisappear:(BOOL)animated
{
    AppDelegate* appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    [appDelegate.locationManager setDelegate:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)locationDidFinish
{
    [self performSegueWithIdentifier:PUSH_TO_LOCATION_VIEW sender:self];
}

-(void)onlineAttemptFailedwithError:(NSError *)error
{
    UIAlertController* alert;
    
    if (error) {
        alert = [UIAlertController alertControllerWithTitle:error.localizedDescription message:error.localizedRecoverySuggestion preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* cancelBtn = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alert addAction:cancelBtn];
    }
    else alert = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    AppDelegate* appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    CityDataObject* city = (CityDataObject*) [appDelegate.locationManager retrieveCurrentLocation];
    
    if (!city) {
        
        AppDelegate* appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        
        [appDelegate.locationManager setDelegate:self];
        
        [appDelegate.locationManager startUpdates];
        
    }
    else{
        LocationDisplayViewController* destination = (LocationDisplayViewController*) [segue destinationViewController];
        
        destination.addressString = [[NSString alloc] initWithString:city.address];
        destination.cityString = [[NSString alloc] initWithString:city.name];
        destination.stateString = [[NSString alloc] initWithString:city.state];
        destination.latString = [[NSString alloc] initWithString:city.latitude];
        destination.longString = [[NSString alloc] initWithString:city.longitude];

    }
    
}


@end
