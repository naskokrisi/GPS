//
//  ViewController.m
//  GPS
//
//  Created by Nasko on 3/2/13.
//  Copyright (c) 2013 Nasko. All rights reserved.
//

#import "MapViewController.h"
#import "PinClass.h"
#import "TrackViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

-(IBAction)startTrack:(UIBarButtonItem*)sender {
    _mapView.showsUserLocation = YES;

    if (_isPushed == NO) {
        _dropPinColor = YES;
        _isPushed = YES;
        [sender setTitle:@"Stop Track"];
        _startLocation = [[_mapView userLocation] location];
        _isRecording = YES;
        _pinColorCheck = 2;
        [self makePin];
    }
    else if (_isPushed == YES) {
        _dropPinColor = YES;
        _trackColor ++;
        if(_trackColor == 4) _trackColor = 0;
        _isPushed = NO;
        _stopLocation = [[_mapView userLocation] location];
        _isRecording = NO;
        _pinColorCheck = 1;
        [self makePin];
        [sender setTitle:@"Start Track"];
    }
}

-(IBAction)myLocation:(id)sender {
    
    MKCoordinateRegion regionUser;
    regionUser.center.latitude = _latitude;
    regionUser.center.longitude = _longitude;
    regionUser.span.latitudeDelta = 0.01f;
    regionUser.span.longitudeDelta = 0.01f;
    [_mapView setRegion:regionUser animated:YES];
    [_mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
}

-(IBAction)setMap:(id)sender {
    switch (((UISegmentedControl *) sender).selectedSegmentIndex)
    {
    case 0:
        {
            _mapView.mapType = MKMapTypeStandard;
            break;
        }
    case 1:
        {
            _mapView.mapType = MKMapTypeSatellite;
            break;
        }
    case 2:
        {
            _mapView.mapType = MKMapTypeHybrid;
            break;
        }
    }
}

# pragma mark - Pin Making

-(IBAction)pinDrop {
    
    _pinColorCheck = 3;
    _dropPinColor = NO;
    [self makePin];
    
}

-(void)pinMaker {
    MKCoordinateRegion region;
    region.center.latitude = _latitude;
    region.center.longitude = _longitude;
    region.span.latitudeDelta = 0.01f;
    region.span.longitudeDelta = 0.01f;
    [_mapView setRegion:region animated:YES];
    
    PinClass *ann = [[PinClass alloc] init];
    ann.coordinate = region.center;
    [_mapView addAnnotation:ann];

}

-(void)makePin {

    if (_dropPinColor == NO) {
        _purpleColor = YES;
        [self pinMaker];
         
    }
    
    else if(_myPinColor == YES) {
        _myPinColor = NO;
        _dropPinColor = NO;
        _greenColor = YES;
        [self pinMaker];
        
    }
    
    else if(_myPinColor == NO) {
        _myPinColor = YES;
        _dropPinColor = NO;
        _redColor = YES;
        [self pinMaker];
    }
    
}

-(MKPinAnnotationView *)pinChangeColor:(NSInteger)pinColorCount {
    
    switch (pinColorCount) {
        case 1: {
            _myPinView.pinColor = MKPinAnnotationColorRed;
            _myPinView.animatesDrop = YES;
            return _myPinView;
        }
        case 2: {
            _myPinView.pinColor = MKPinAnnotationColorGreen;
            _myPinView.animatesDrop = YES;
            return _myPinView;
        }
        case 3: {
            _myPinView.pinColor = MKPinAnnotationColorPurple;
            _myPinView.animatesDrop = YES;
            _myPinView.draggable = YES;
            return _myPinView;
        }
            
    }
    return 0;
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView1 viewForAnnotation:(id<MKAnnotation>)annotation {
    
    MKPinAnnotationView *pinView = (MKPinAnnotationView*) [mapView1 dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
    
    if (pinView ==nil) {
        
        
        _myPinView= [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"Pin"];
        
        if (_redColor == YES) {
            [self pinChangeColor:1];
            pinView = _myPinView;
            _pinColorCheck = 1;
            _redColor = NO;
            return pinView;
            
        } else if (_greenColor == YES) {
            [self pinChangeColor:2];
            pinView = _myPinView;
            _pinColorCheck = 2;
            _greenColor = NO;
            return pinView;
            
        }  else if (_purpleColor == YES) {
            [self pinChangeColor:3];
            pinView = _myPinView;
            _pinColorCheck = 3;
            _purpleColor = NO;
            return pinView;
        }
        
    }
    return 0;
}

# pragma mark - Route Track Color

-(MKOverlayView *)routeTrack:(CLLocation *)startLocation atCurrent2DLocation:(CLLocation *)currentLocation {
    _pointsArray[0]= MKMapPointForCoordinate(startLocation.coordinate);
    _pointsArray[1]= MKMapPointForCoordinate(currentLocation.coordinate);
    
    _routeLine = [MKPolyline polylineWithPoints:_pointsArray count:2];
    
    [_mapView addOverlay:_routeLine];
    return 0;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    _latitude = newLocation.coordinate.latitude;
    _longitude = newLocation.coordinate.longitude;
        
    if (_isRecording) {
        [self routeTrack:oldLocation atCurrent2DLocation:newLocation];
    }

}

- (UIColor *)colorForTrackInteger:(NSInteger)trackColor {
    switch (trackColor) {
        case 0:
            return [UIColor purpleColor];
        case 1:
            return [UIColor blueColor];
        case 2:
            return [UIColor redColor];
        case 3:
            return [UIColor greenColor];
            
        default: 
            return [UIColor blueColor];
    }
}

# pragma mark - Map View Delegate

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    MKOverlayView* overlayView = nil;
    
    
    MKPolylineView  * _routeLineView = [[[MKPolylineView alloc] initWithPolyline:_routeLine] autorelease];
    _routeLineView.fillColor = [self colorForTrackInteger:_trackColor];
    _routeLineView.strokeColor = [self colorForTrackInteger:_trackColor];
    _routeLineView.lineWidth = 5;
    _routeLineView.lineCap = kCGLineCapSquare;
    
    overlayView = _routeLineView;
    
    return overlayView;
    
}

# pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    _pinColorCheck= 0;
    _redColor = NO;
    _greenColor = NO;
    _purpleColor = NO;
    _dropPinColor = NO;
    _myPinColor = YES;
    _trackColor = 0;
    _isPushed = NO;
    _isRecording = NO;
    _location = YES;
    _mapView.showsUserLocation = NO;
    _mapView.delegate = self;
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    _pointsArray = malloc(sizeof(CLLocationCoordinate2D)*2);
}

@end