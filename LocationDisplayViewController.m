//
//  LocationDisplayViewController.m
//  find.me
//
//  Created by Emmanuel Franco on 4/16/17.
//  Copyright © 2017 Emmanuel Franco. All rights reserved.
//

#import "LocationDisplayViewController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <AudioToolbox/AudioToolbox.h>
#import "AppDelegate.h"
#import "CityDataObject.h"
#import "MapViewController.h"

#define AD_ID @"ca-app-pub-2804657410672476/9141297944"
#define SEGUE_MAP_VIEW @"segueToMap"

@interface LocationDisplayViewController ()<GADBannerViewDelegate, LocationManagerDelegate>

@end

@implementation LocationDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.lbl_currentLocation setText:self.addressString];
    [self.lbl_city setText:self.cityString];
    [self.lbl_state setText:self.stateString];
    [self.lbl_latitude setText:self.latString];
    [self.lbl_longitude setText:self.longString];
    
    self.loadingView = [[UIView alloc] init];
    [self.loadingView setFrame:self.view.frame];
    [self.loadingView setBackgroundColor:[UIColor blackColor]];
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] init];
    [indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [indicator setFrame:CGRectMake((self.loadingView.frame.size.width / 2), (self.loadingView.frame.size.height / 2), indicator.frame.size.width, indicator.frame.size.height)];
    [self.loadingView addSubview:indicator];
    [indicator startAnimating];
    [self.loadingView setHidden:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self initAdView];
    [self showAdView:self.adMobBannerView];
}


-(void)initAdView
{
    self.adMobBannerView = [[GADBannerView alloc] init];
    CGFloat screenWidth = self.view.frame.size.width;
    
    
    [self.adMobBannerView setAdSize:GADAdSizeFromCGSize(CGSizeMake(screenWidth, 50))];
    [self.adMobBannerView setAdUnitID:AD_ID];
    self.adMobBannerView.rootViewController = self;
    self.adMobBannerView.delegate = self;
    [self.view addSubview:self.adMobBannerView];
    GADRequest* request = [[GADRequest alloc] init];
    
    [self.adMobBannerView loadRequest:request];
}

-(void)showAdView:(GADBannerView *)adView
{
    if (!adView) adView = self.adMobBannerView;
    [UIView beginAnimations:@"showAdView" context:nil];
    
    adView.frame = CGRectMake(0, 20, adView.frame.size.width, adView.frame.size.height);
    
    [UIView commitAnimations];
    
    [adView setHidden:NO];
}

-(void)showLoadingView
{
    [self.loadingView setAlpha:0.5];
    [self.loadingView setHidden:NO];
    [self.view addSubview:self.loadingView];

}

-(void)hideLoadingView
{
    [self.loadingView setHidden:YES];
}

-(void)resetLocation:(generalCompletionHandler)completionHandler
{
    AppDelegate* appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    [appDelegate.locationManager setDelegate:self];
    
    [appDelegate.locationManager startUpdates];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)resetPressed:(id)sender {
    
    [self showLoadingView];
    
    AppDelegate* appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    [appDelegate.locationManager setDelegate:self];
    
    [appDelegate.locationManager startUpdates];
}

- (IBAction)mapPressed:(id)sender {
    [self performSegueWithIdentifier:SEGUE_MAP_VIEW sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:SEGUE_MAP_VIEW]) {
        
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        
        AppDelegate* appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        
        CityDataObject* city = [appDelegate.locationManager retrieveCurrentLocation];
        
        MapViewController* destination = segue.destinationViewController;
        
        [destination setUserLocation:city];
        
    }
}

-(void)locationDidFinish
{
    AppDelegate* appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    CityDataObject* city = [appDelegate.locationManager retrieveCurrentLocation];
    
    self.addressString = [[NSString alloc] initWithString:city.address];
    self.cityString = [[NSString alloc] initWithString:city.name];
    self.stateString = [[NSString alloc] initWithString:city.state];
    self.latString = [[NSString alloc] initWithString:city.latitude];
    self.longString = [[NSString alloc] initWithString:city.longitude];
    
    [self.lbl_currentLocation setText:self.addressString];
    [self.lbl_city setText:self.cityString];
    [self.lbl_state setText:self.stateString];
    [self.lbl_latitude setText:self.latString];
    [self.lbl_longitude setText:self.longString];
    
    [self hideLoadingView];
}

-(void)onlineAttemptFailedwithError:(NSError *)error
{
    UIAlertController* alert;
    
    if (error) {
        alert = [UIAlertController alertControllerWithTitle:error.localizedDescription message:error.localizedRecoverySuggestion preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* cancelBtn = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (!self.loadingView.isHidden) [self hideLoadingView];
        }];
        
        [alert addAction:cancelBtn];
    }
    else alert = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
