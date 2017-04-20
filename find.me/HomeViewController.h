//
//  HomeViewController.h
//  find.me
//
//  Created by Emmanuel Franco on 4/17/17.
//  Copyright © 2017 Emmanuel Franco. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CityDataObject;
@class LocationDisplayViewController;

@interface HomeViewController : UIViewController

@property (strong, nonatomic) LocationDisplayViewController* locationDisplayViewController;

@end
