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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
