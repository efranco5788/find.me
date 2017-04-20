//
//  LocationManager.m
//  find.me
//
//  Created by Emmanuel Franco on 4/16/17.
//  Copyright © 2017 Emmanuel Franco. All rights reserved.
//

#import "LocationManager.h"
#import <dispatch/dispatch.h>
#import "CityDataObject.h"

#define HAS_LAUNCHED_ONCE @"HasLaunchedOnce"
#define ADDRESS @"address"
#define CITY @"city"
#define STATE @"state"
#define STATE_NAME @"Name"
#define ZIPCODE @"zipcode"
#define ABBREVIATION @"Abbreviation"
#define DISTANCE_FILTER @"distance_filter"
#define LOCATION @"recorded_location"
#define RECORDED_TIME @"recorded_time"
#define ZIPCODE_LENGTH 5
#define CURRENT_LOCATION_AGE_THRESHOLD 5
#define LOCATION_TIME_THRESHOLD 600
#define DISTANCE_FILTER_THRESHOLD 1609.34
#define KM_PER_MILE 1.60934
#define KEY_FOR_ALL_POSTAL_CODES @"postalCodes"
#define KEY_FOR_POSTAL_CODE @"postalCode"
#define KEY_FOR_LATITUDE @"lat"
#define KEY_FOR_LONGTITUDE @"lng"
#define KEY_FOR_RADIUS @"radius"
#define KEY_FOR_ROWS @"maxRows"
#define KEY_FOR_COUNTRY @"country"
#define KEY_FOR_LOCAL_COUNTRY @"localCountry"
#define KEY_FOR_USERNAME @"username"
#define MAX_ROWS @"20"
#define DEFAULT_RADIUS @"1"
#define DEFAULT_ROWS @"5"

static LocationManager* sharedManager;

@interface LocationManager()
@property NSArray* locationHistory;

@end

@implementation LocationManager

+ (LocationManager*) sharedLocationServiceManager
{
    if (sharedManager == nil) {
        
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            
            sharedManager = [[super alloc] init];
            
        });
    }
    return sharedManager;
}

- (id)init
{
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self->currentLocations  = [[NSArray alloc] init];
    
    return self;
}


#pragma mark -
#pragma mark - Zipcode Services
-(BOOL)hasLocationsRecorded
{
    if (self.locationHistory.count < 1) {
        return FALSE;
    }
    else return TRUE;
}

-(void)attemptToAddCurrentLocation:(CityDataObject*)aCity addCompletionHandler:(addLocationResponse)completionHandler
{
    
    if (!aCity) {
        completionHandler(NO);
    }
    else{
        
        CityDataObject* currentCity = [[CityDataObject alloc] initWithCity:aCity.name State:aCity.state stateAbbr:aCity.state andPostal:aCity.postal andAddress:aCity.address andLongitude:aCity.longitude andLatitude:aCity.latitude];
        
        NSMutableArray* copy = self.locationHistory.mutableCopy;
        
        [copy addObject:currentCity];
        
        self.locationHistory = copy.copy;
        
        NSLog(@"Current Location saved %@", self.locationHistory);
        
        completionHandler(YES);
    }
    
}


#pragma mark -
#pragma mark - Location Services
-(void)startUpdates
{
    if (self.locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        [self.locationManager setDistanceFilter:DISTANCE_FILTER_THRESHOLD];
        self.locationHistory = [[NSArray alloc] init];
        attempts = 0;
    }
    
    [self.locationManager setDelegate:self];
    
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    else{
        [self.locationManager startUpdatingLocation];
    }
    
}

-(void)stopUpdates // Stop receiving updates
{
    [self.locationManager stopUpdatingLocation];
    
    self.locationManager.delegate = nil;
    
    attempts = 0;
    
    NSLog(@"Location Services was terminated");
}


#pragma mark -
#pragma mark - Location Services Delegate
//Validate the authorization status of the app
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self.locationManager startUpdatingLocation];
            NSLog(@"Location Services has started");
            break;
        default:
            [self.delegate onlineAttemptFailed];
            break;
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self stopUpdates];
    
    CLLocation* recentLocation = [locations lastObject];
    
    if (recentLocation.horizontalAccuracy < 0) {
        NSLog(@"horizontal accuracy error");
        return;
    }
    
    NSDate* locationDate = recentLocation.timestamp;
    
    NSTimeInterval locationAge = [locationDate timeIntervalSinceNow];
    
    float ageOfLocation = fabs(locationAge);
    
    // Verify location is current
    if (ageOfLocation <= CURRENT_LOCATION_AGE_THRESHOLD)
    {
        NSLog(@"Current Location %f seconds", ageOfLocation);
        
        NSDate* recordedTime = [NSDate date];
        
        NSDictionary* currentLocation = [[NSDictionary alloc] initWithObjectsAndKeys:recentLocation, LOCATION, recordedTime, RECORDED_TIME, nil];
        
        [self recordLocation:currentLocation];
        
        NSLog(@"New Location was found and added");
        [self fetchLocationInformation:nil];
    }
    else
    {
        //NSLog(@"Location is old: %f seconds", fabs(locationAge));
        NSLog(@"Location is old: %f seconds", ageOfLocation);
        [self startUpdates];
    }
    
}

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    attempts = attempts + 1;
    
    switch (error.code) {
        case kCLErrorLocationUnknown:
            if (attempts <= 3) {
                NSLog(@"Attempt %ld", (long)attempts);
            }
            else
            {
                [self stopUpdates];
                [self.delegate onlineAttemptFailed];
            }
            break;
        case kCLErrorGeocodeCanceled:
            [self stopUpdates];
            break;
        default:
            if (attempts < 0) {
                [self startUpdates];
            }
            else if (attempts > 0 && attempts < 3)
            {
                [NSThread sleepForTimeInterval:2];
                [self startUpdates];
            }
            else
                [self stopUpdates];
            [self.delegate onlineAttemptFailed];
            break;
    }
}

-(BOOL) shouldStartUpdatesBasedOnAuthorization: (CLAuthorizationStatus) authorizationStatus
{
    int status = authorizationStatus;
    
    switch (status) {
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            return YES;
            break;
        default:
            return NO;
            break;
    }
}


#pragma mark -
#pragma mark - Current Location
-(id) retrieveCurrentLocation
{
    if (self.locationHistory.count < 1) return nil;
    
    return [self.locationHistory lastObject];
}


-(void) fetchLocationInformation:(NSArray*)locations
{
    CLGeocoder* coder = [[CLGeocoder alloc] init];
    
    if (locations == nil) {
        
        NSDictionary* tempRecentLocation = [self.locationHistory lastObject];
        
        CLLocation* mostRecentLocation = [tempRecentLocation objectForKey:LOCATION];
        
        [coder reverseGeocodeLocation: mostRecentLocation completionHandler:^(NSArray* placemarks, NSError* error){
            
            if (error) {
                NSLog(@"%@", error.description);
                [self.delegate onlineAttemptFailed];
            }
            else
            {
                CLPlacemark* currentLocation = [placemarks objectAtIndex:0];
                
                NSNumber* lon =  [NSNumber numberWithDouble:mostRecentLocation.coordinate.longitude];
                
                NSNumber* lat = [NSNumber numberWithDouble:mostRecentLocation.coordinate.latitude];
                
                NSDictionary* address = [currentLocation addressDictionary];
                
                NSArray* formattedAdd = [address valueForKey:@"FormattedAddressLines"];
                
                NSString* currentAddress = [formattedAdd objectAtIndex:0];
                
                NSString* cityName = [address valueForKey:@"City"] ;
                
                NSString* state = [address valueForKey:@"State"];
                
                NSString* postal = [currentLocation postalCode];
                
                CityDataObject* city = [[CityDataObject alloc] initWithCity:cityName State:state stateAbbr:state andPostal:postal andAddress:currentAddress andLongitude:[lon stringValue] andLatitude:[lat stringValue]];
                
                [self attemptToAddCurrentLocation:city addCompletionHandler:^(BOOL success) {
                    
                    if (success) {
                        
                        [self.delegate locationDidFinish];
                        
                    }
                    
                }];
                
            }
            
        }];
    }
    else{
        
        for (CLLocation* location in locations) {
            
            [coder reverseGeocodeLocation: location completionHandler:^(NSArray* placemarks, NSError* error){
                
                if (error) {
                    NSLog(@"%@", error.description);
                }
                else
                {
                    CLPlacemark* currentLocation = [placemarks objectAtIndex:0];
                    
                    NSString* recentZipcode = [currentLocation postalCode];
                    
                    NSLog(@"Zipcode: %@", recentZipcode);
                    
                    [self.delegate locationDidFinish];
                }
                
            }];
            
        }
    }
    
}

-(BOOL)hasMetLocationTimeThreshold
{
    NSDictionary* currentLocation = [self.locationHistory lastObject];
    
    NSDate* timestamp = [currentLocation objectForKey:RECORDED_TIME];
    
    NSTimeInterval age = [timestamp timeIntervalSinceNow];
    
    if (fabs(age) <= LOCATION_TIME_THRESHOLD) {
        return NO;
    }
    else return YES;
}

-(void)recordLocation:(NSDictionary*)location
{
    NSMutableArray* copyLocationHistory = self.locationHistory.mutableCopy;
    
    [copyLocationHistory addObject:location];
    
    self.locationHistory = copyLocationHistory.copy;
    
    NSLog(@"Location recorded");
}


@end
