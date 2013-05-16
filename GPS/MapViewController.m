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

@synthesize mapView;
@synthesize coordinate;



-(IBAction)pinDrop {
    
    _setPinColorTest = 3;
    dropPinColor = NO;
    [self makePin];
    
}


-(IBAction)startTrack:(UIBarButtonItem*)sender {
    mapView.showsUserLocation = YES;

    if (isPushed == NO) {
        dropPinColor = YES;
        isPushed = YES;
        [sender setTitle:@"Stop Track"];
        _startLocation = [[mapView userLocation] location];
        _isRecording = YES;
        _setPinColorTest = 2;
        [self makePin];
    }
    else if (isPushed == YES) {
        dropPinColor = YES;
        _trackColor ++;
        if(_trackColor == 4) _trackColor = 0;
        isPushed = NO;
        _stopLocation = [[mapView userLocation] location];
        _isRecording = NO;
        _setPinColorTest = 1;
        [self makePin];
        [sender setTitle:@"Start Track"];
    }
}

-(IBAction)myLocation:(id)sender {
    
    MKCoordinateRegion regionUser;
    regionUser.center.latitude = latitude;
    regionUser.center.longitude = longitude;
    regionUser.span.latitudeDelta = 0.01f;
    regionUser.span.longitudeDelta = 0.01f;
    [mapView setRegion:regionUser animated:YES];
    [mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
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


-(MKPinAnnotationView *)pinCheck:(NSInteger)pinCount {
    
    switch (pinCount) {
        case 1: {
            myPinView.pinColor = MKPinAnnotationColorRed;
            myPinView.animatesDrop = YES;
            return myPinView;
        }
        case 2: {
            myPinView.pinColor = MKPinAnnotationColorGreen;
            myPinView.animatesDrop = YES;
            return myPinView;
        }
        case 3: {
            myPinView.pinColor = MKPinAnnotationColorPurple;
            myPinView.animatesDrop = YES;
            myPinView.draggable = YES;
            return myPinView;
        }
    }
    return  0;
}

-(MKPinAnnotationView *)pinCheckTest:(NSInteger)pinCountTest {
    
    switch (pinCountTest) {
        case 1: {
            myPinView.pinColor = MKPinAnnotationColorRed;
            myPinView.animatesDrop = YES;
            return myPinView;
        }
        case 2: {
            myPinView.pinColor = MKPinAnnotationColorGreen;
            myPinView.animatesDrop = YES;
            return myPinView;
        }
        case 3: {
            myPinView.pinColor = MKPinAnnotationColorPurple;
            myPinView.animatesDrop = YES;
            myPinView.draggable = YES;
            return myPinView;
        }
    }
    return  0;
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView1 viewForAnnotation:(id<MKAnnotation>)annotation {
    
    MKPinAnnotationView *pinView = (MKPinAnnotationView*) [mapView1 dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
        
    if (pinView ==nil) {
        
        
        pinView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"Pin"];

        
        if (redColor == YES) {
            pinView.pinColor = MKPinAnnotationColorRed;
            pinView.animatesDrop = YES;
            _setPinColorTest = 1;
            redColor = NO;
            return pinView;
            
        } else if (greenColor == YES) {
            pinView.pinColor = MKPinAnnotationColorGreen;
            pinView.animatesDrop = YES;
            _setPinColorTest = 2;
            greenColor = NO;
            return pinView;
            
        }  else if (purpleColor == YES) {
            pinView.pinColor = MKPinAnnotationColorPurple;
            pinView.animatesDrop = YES;
            pinView.draggable = YES;
            _setPinColorTest = 3;
            purpleColor = NO;
            return pinView;
        }
        
    }
    
    return 0;
    
}

-(void)pinMaker {
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

-(void)makePin {

    if (dropPinColor == NO) {
        purpleColor = YES;
        [self pinMaker];
         
    }
    
    else if(myPinColor == YES) {
        myPinColor = NO;
        dropPinColor = NO;
        greenColor = YES;
        [self pinMaker];
        
    }
    
    else if(myPinColor == NO) {
        myPinColor = YES;
        dropPinColor = NO;
        redColor = YES;
        [self pinMaker];
    }
    
}

-(MKOverlayView *)routeTrack:(CLLocation *)startLocation atCurrent2DLocation:(CLLocation *)currentLocation {
    _pointsArray[0]= MKMapPointForCoordinate(startLocation.coordinate);
    _pointsArray[1]= MKMapPointForCoordinate(currentLocation.coordinate);
    
    _routeLine = [MKPolyline polylineWithPoints:_pointsArray count:2];
    
    [mapView addOverlay:_routeLine];
    return 0;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    latitude = newLocation.coordinate.latitude;
    longitude = newLocation.coordinate.longitude;
        
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

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    _setPinColorTest = 0;
    redColor = NO;
    greenColor = NO;
    purpleColor = NO;
    dropPinColor = NO;
    myPinColor = YES;
    _trackColor = 0;
    isPushed = NO;
    _isRecording = NO;
    location = YES;
    mapView.showsUserLocation = NO;
    mapView.delegate = self;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
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