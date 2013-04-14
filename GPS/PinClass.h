//
//  PinClass.h
//  GPS
//
//  Created by Nasko on 4/12/13.
//  Copyright (c) 2013 Nasko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

@interface PinClass : NSObject <MKAnnotation> {
    
    CLLocationCoordinate2D coordinate;
    
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end
