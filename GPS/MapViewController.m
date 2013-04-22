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


-(IBAction)pinDrop {
    
    [self makePin];
    
}

-(IBAction)startTrack:(UIBarButtonItem*)sender {
    mapView.showsUserLocation = YES;

    if (isPushed == NO) {
        isPushed = YES;
        [sender setTitle:@"Stop Track"];
        _startLocation = [[mapView userLocation] location];
        _isRecording = YES;
        
        [self makePin];
    }
    else if (isPushed == YES) {
        _trackColor ++;
        isPushed = NO;
        _stopLocation = [[mapView userLocation] location];
        _isRecording = NO;
        [self makePin];
        [sender setTitle:@"Start Track"];
    }
}

-(IBAction)myLocation:(id)sender {
    mapView.showsUserLocation = YES;
    [mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
    if (location == YES) {
    location = NO;
    }
}
/*
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
*/
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
    
    [mapView addOverlay:_routeLine];  
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
    if(_trackColor == 1) {
    _routeLineView.fillColor = [UIColor blueColor];
    _routeLineView.strokeColor = [UIColor blueColor];
    _routeLineView.lineWidth = 5;
    _routeLineView.lineCap = kCGLineCapSquare;
    }
    else if (_trackColor == 2) {
        _routeLineView.fillColor = [UIColor redColor];
        _routeLineView.strokeColor = [UIColor redColor];
        _routeLineView.lineWidth = 5;
        _routeLineView.lineCap = kCGLineCapSquare;
    }
    
    else if (_trackColor == 3) {
        _routeLineView.fillColor = [UIColor greenColor];
        _routeLineView.strokeColor = [UIColor greenColor];
        _routeLineView.lineWidth = 5;
        _routeLineView.lineCap = kCGLineCapSquare;
    }
    else {
        _trackColor = 0;
        _routeLineView.fillColor = [UIColor purpleColor];
        _routeLineView.strokeColor = [UIColor purpleColor];
        _routeLineView.lineWidth = 5;
        _routeLineView.lineCap = kCGLineCapSquare;
        
    }
    
    overlayView = _routeLineView;
    
    return overlayView;
    
}
/*
- (void)showRouteListView:(id)sender {
	 *controller = [[RouteListViewController alloc] initWithStyle:UITableViewStyleGrouped];
	controller.routes = diretions.routes;
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
	[self presentModalViewController:navigationController animated:YES];
	[controller release];
	[navigationController release];
}
*/

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    _trackColor = 0;
    isPushed = FALSE;
    _isRecording = NO;
    location = TRUE;
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