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

@interface MapViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, MKAnnotation>{
    CLLocationManager *locationManager;
    int _trackColor;
    int _setPinColorTest;
    bool location;
    bool dropPinColor;
    bool isPushed;
    bool myPinColor;
    bool redColor;
    bool greenColor;
    bool purpleColor;
    double longitude;
    double latitude;
    NSString *title;
    MKMapView *mapView;
    MKPinAnnotationView *myPinView;
        
}




@property (nonatomic, retain) IBOutlet MKMapView *mapView;

@property MKMapPoint * pointsArray;
@property (retain) CLLocation *startLocation;
@property (retain) CLLocation *stopLocation;
@property BOOL isRecording;
@property (retain) MKPolyline *routeLine;

- (UIColor *)colorForTrackInteger:(NSInteger)trackColor;
-(MKOverlayView *)routeTrack:(CLLocation *)startLocation atCurrent2DLocation:(CLLocation *)currentLocation;


-(IBAction)startTrack:(id)sender;
-(IBAction)myLocation:(id)sender;
//-(IBAction)getLocation;
-(IBAction)setMap:(id)sender;
-(IBAction)pinDrop;
@end