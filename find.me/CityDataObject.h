//
//  CityDataObject.h
//  find.me
//
//  Created by Emmanuel Franco on 4/16/17.
//  Copyright © 2017 Emmanuel Franco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityDataObject : NSObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* address;
@property (nonatomic, strong) NSString* state;
@property (nonatomic, strong) NSString* stAbbr;
@property (nonatomic, strong) NSString* postal;
@property (nonatomic, strong) NSString* longitude;
@property (nonatomic, strong) NSString* latitude;

-initWithCity:(NSString*)city State:(NSString*)state stateAbbr:(NSString*)abbr andPostal:(NSString*)postalCode andAddress:(NSString*)anAddress andLongitude:(NSString*)aLon andLatitude:(NSString*)aLat;

@end
