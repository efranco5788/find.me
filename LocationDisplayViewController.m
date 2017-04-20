//
//  LocationDisplayViewController.m
//  find.me
//
//  Created by Emmanuel Franco on 4/16/17.
//  Copyright © 2017 Emmanuel Franco. All rights reserved.
//

#import "LocationDisplayViewController.h"
#import "AppDelegate.h"
#import "CityDataObject.h"

@interface LocationDisplayViewController ()

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
