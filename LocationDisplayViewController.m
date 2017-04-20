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

#define AD_ID @"ca-app-pub-2804657410672476/9141297944"

@interface LocationDisplayViewController ()<GADBannerViewDelegate>

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
    [self.loadingView setBackgroundColor:[UIColor blackColor]];
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
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] init];
    [indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [indicator startAnimating];
    
    [self.loadingView setFrame:self.view.frame];
    [indicator setFrame:CGRectMake((self.loadingView.frame.size.width / 2), (self.loadingView.frame.size.height / 2), indicator.frame.size.width, indicator.frame.size.height)];
    [self.loadingView setAlpha:0.5];
    [self.loadingView setHidden:NO];
    [self.loadingView addSubview:indicator];
    [self.view addSubview:self.loadingView];

}

-(void)hideLoadingView
{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)resetPressed:(id)sender {
    [self showLoadingView];
}
@end
