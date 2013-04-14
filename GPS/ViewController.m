//
//  ViewController.m
//  GPS
//
//  Created by Nasko on 3/2/13.
//  Copyright (c) 2013 Nasko. All rights reserved.
//

#import "ViewController.h"
#import "PinClass.h"


@interface ViewController ()


@end

@implementation ViewController


-(IBAction)pinDrop {
    
    [self makePin];
    
}

-(IBAction)startTrack:(UIBarButtonItem*)sender {
    
    if (mapView.showsUserLocation == NO) {
        
        UIAlertView *alert = [[ UIAlertView alloc] initWithTitle:nil message:@"Please turn on your location" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert autorelease];
        
        
    }
    else if (isPushed == FALSE) {
        isPushed = TRUE;
        [sender setTitle:@"Stop Track"];
        _startLocation = [[mapView userLocation] location];
        _isRecording = YES;
        //[button setTitle:@"Stop Track" forState:UIControlStateNormal];
        
        [self makePin];
    }
    else if (isPushed == TRUE) {
        isPushed = FALSE;
        _stopLocation = [[mapView userLocation] location];
        _isRecording = NO;
        [sender setTitle:@"Start Track"];
    }
}

-(IBAction)myLocation:(id)sender {
    mapView.showsUserLocation = YES;
    [mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
    if (location == TRUE) {
    UIAlertView *alert = [[ UIAlertView alloc] initWithTitle:nil message:@"Location is ON" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert autorelease];
    location = FALSE;
    }
}

-(IBAction)getLocation {
    if(location == FALSE) {
    mapView.showsUserLocation = NO;
        UIAlertView *alert = [[ UIAlertView alloc] initWithTitle:nil message:@"Location is OFF" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert autorelease];
        location = TRUE;
    }
    else if(location == TRUE) {
        mapView.showsUserLocation = YES;
        UIAlertView *alert = [[ UIAlertView alloc] initWithTitle:nil message:@"Location is ON" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert autorelease];
            location = FALSE;
    }
}

-(IBAction)setMap:(id)sender {
    switch (((UISegmentedControl *) sender).selectedSegmentIndex)
    {
    case 0:
        {
            mapView.mapType = MKMapTypeStandard;
            break;
        }
    case 1:
        {
            mapView.mapType = MKMapTypeSatellite;
            break;
        }
    case 2:
        {
            mapView.mapType = MKMapTypeHybrid;
            break;
        }
    }
}
@synthesize mapView;

-(void)makePin {
    MKCoordinateRegion region;
    region.center.latitude = latitude;
    region.center.longitude = longitude;
    region.span.latitudeDelta = 0.01f;
    region.span.longitudeDelta = 0.01f;
    [mapView setRegion:region animated:YES];
    
    
    PinClass *ann = [[PinClass alloc] init];
    ann.coordinate = region.center;
    [mapView addAnnotation:ann];
    
}

-(void)routeTrack:(CLLocation *)startLocation atCurrent2DLocation:(CLLocation *)currentLocation {
    _pointsArray[0]= MKMapPointForCoordinate(startLocation.coordinate);
    _pointsArray[1]= MKMapPointForCoordinate(currentLocation.coordinate);
    
    _routeLine = [MKPolyline polylineWithPoints:_pointsArray count:2];
    
    [mapView addOverlay:_routeLine];  //MkMapView declared in .h
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    latitude = newLocation.coordinate.latitude;
    NSString *lat = [NSString stringWithFormat:@"%f",latitude];
    latLabel.text = lat;
    longitude = newLocation.coordinate.longitude;
    NSString *longt = [NSString stringWithFormat:@"%f",longitude];
    longLabel.text = longt;
    
    if (_isRecording) {
        [self routeTrack:oldLocation atCurrent2DLocation:newLocation];
    }

}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    MKOverlayView* overlayView = nil;
    
    
    MKPolylineView  * _routeLineView = [[[MKPolylineView alloc] initWithPolyline:_routeLine] autorelease];
    _routeLineView.fillColor = [UIColor blueColor];
    _routeLineView.strokeColor = [UIColor blueColor];
    _routeLineView.lineWidth = 15;
    _routeLineView.lineCap = kCGLineCapSquare;
    
    
    overlayView = _routeLineView;
    
    return overlayView;
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    isPushed = FALSE;
    _isRecording = NO;
    location = TRUE;
    mapView.showsUserLocation = NO;
    mapView.delegate = self;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    //locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [locationManager startUpdatingLocation];
    _pointsArray = malloc(sizeof(CLLocationCoordinate2D)*2);
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [super dealloc];
    free(_pointsArray);
}

@end