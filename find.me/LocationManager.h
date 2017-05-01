//
//  LocationManager.h
//  find.me
//
//  Created by Emmanuel Franco on 4/16/17.
//  Copyright © 2017 Emmanuel Franco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@class CityDataObject;


typedef void (^addLocationResponse)(BOOL success);
typedef void (^generalCompletionHandler)(BOOL success);
typedef void (^fetchPostalCompletionHandler)(id object);

@protocol LocationManagerDelegate <NSObject>
@optional
-(void) locationDidFinish;
-(void) onlineAttemptFailedwithError:(NSError*)error;
-(void) coordinateFetched:(id)deal;
@end

@interface LocationManager : NSObject<CLLocationManagerDelegate>
{
@private NSArray* currentLocations;
@private NSInteger attempts;
@private dispatch_queue_t backgroundQueue;
}

+ (LocationManager *) sharedLocationServiceManager;

@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, assign) id<LocationManagerDelegate> delegate;

-(id) init;

-(void) startUpdates;

-(void) stopUpdates;

-(BOOL) shouldStartUpdatesBasedOnAuthorization: (CLAuthorizationStatus) authorizationStatus;

-(id) retrieveCurrentLocation;

-(void) fetchLocationInformation:(NSArray*) locations;

-(BOOL) hasLocationsRecorded;

-(BOOL) hasMetLocationTimeThreshold;


@end
