//
//  MapViewController.h
//  find.me
//
//  Created by Emmanuel Franco on 4/25/17.
//  Copyright © 2017 Emmanuel Franco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class CityDataObject;

@interface MapViewController : UIViewController

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CityDataObject* userLocation;

@end
