//
//  CityDataObject.m
//  find.me
//
//  Created by Emmanuel Franco on 4/16/17.
//  Copyright © 2017 Emmanuel Franco. All rights reserved.
//

#import "CityDataObject.h"

@implementation CityDataObject
-(instancetype)init
{
    return [self initWithCity:nil State:nil stateAbbr:nil andPostal:nil andAddress:nil andLongitude:nil andLatitude:nil];
}

-(id)initWithCity:(NSString *)city State:(NSString *)state stateAbbr:(NSString *)abbr andPostal:(NSString *)postalCode andAddress:(NSString *)anAddress andLongitude:(NSString *)aLon andLatitude:(NSString *)aLat
{
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.address = anAddress;
    self.name = city;
    self.state = state;
    self.stAbbr = abbr;
    self.postal = postalCode;
    
    self.longitude = aLon;
    self.latitude = aLat;
    
    return self;
}


@end
