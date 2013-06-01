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
#import <CoreData/CoreData.h>
#import <MapKit/MKPinAnnotationView.h>

@interface MapViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, MKAnnotation>

@property (nonatomic, retain) CLLocationManager *locationManager;
@property BOOL isPushed;
@property BOOL dropPinColor; // differentiate between start/stop and other cases
@property int setPinColorTest; // holy mother of variable names - kur tate banica
@property int trackColor;

@property double latitude;
@property double longitude;

@property BOOL location;
@property BOOL myPinColor;
@property BOOL redColor;
@property BOOL greenColor;
@property BOOL purpleColor;

@property (nonatomic, retain) MKPinAnnotationView *myPinViewTest;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;


@property MKMapPoint * pointsArray;
@property (retain) CLLocation *startLocation;
@property (retain) CLLocation *stopLocation;
@property BOOL isRecording;
@property (retain) MKPolyline *routeLine;

- (UIColor *)colorForTrackInteger:(NSInteger)trackColor;
-(MKOverlayView *)routeTrack:(CLLocation *)startLocation atCurrent2DLocation:(CLLocation *)currentLocation;
-(MKPinAnnotationView *)pinCheckTest:(NSInteger)pinCountTest;
-(MKAnnotationView *)mapView:(MKMapView *)mapView1 viewForAnnotation:(id<MKAnnotation>)annotation;



-(IBAction)startTrack:(id)sender;
-(IBAction)myLocation:(id)sender;
-(IBAction)setMap:(id)sender;
-(IBAction)pinDrop;
@end

/*
 {
 NSString *title;
 }
 
 -(IBAction)getLocation;
*/