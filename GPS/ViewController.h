//
//  ViewController.h
//  GPS
//
//  Created by Nasko on 3/2/13.
//  Copyright (c) 2013 Nasko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MKReverseGeocoder.h>


@interface ViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>{
    CLLocationManager *locationManager;
    bool location;
    bool isPushed;
    double longitude;
    double latitude;
    IBOutlet UILabel *latLabel;
    IBOutlet UILabel *longLabel;
    MKMapView *mapView;
    
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property MKMapPoint * pointsArray;
@property (retain) CLLocation *startLocation;
@property (retain) CLLocation *stopLocation;
@property BOOL isRecording;
@property (retain) MKPolyline *routeLine;

-(IBAction)startTrack:(id)sender;
-(IBAction)myLocation:(id)sender;
-(IBAction)getLocation;
-(IBAction)setMap:(id)sender;
-(IBAction)pinDrop;
@end