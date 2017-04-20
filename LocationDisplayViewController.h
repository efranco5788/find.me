//
//  LocationDisplayViewController.h
//  find.me
//
//  Created by Emmanuel Franco on 4/16/17.
//  Copyright © 2017 Emmanuel Franco. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CityDataObject;
@class GADBannerView;

@interface LocationDisplayViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *lbl_currentLocation;
@property (strong, nonatomic) IBOutlet UILabel *lbl_city;
@property (strong, nonatomic) IBOutlet UILabel *lbl_state;
@property (strong, nonatomic) IBOutlet UILabel *lbl_longitude;
@property (strong, nonatomic) IBOutlet UILabel *lbl_latitude;
@property (strong, nonatomic) IBOutlet UIButton *btn_reset;

@property (strong, nonatomic) NSString* addressString;
@property (strong, nonatomic) NSString* cityString;
@property (strong, nonatomic) NSString* stateString;
@property (strong, nonatomic) NSString* longString;
@property (strong, nonatomic) NSString* latString;
@property (strong, nonatomic) GADBannerView* adMobBannerView;


-(void) initAdView;
-(void) showAdView:(GADBannerView*)adView;

@end
