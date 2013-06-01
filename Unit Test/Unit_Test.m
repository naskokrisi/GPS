//
//  Unit_Test.m
//  Unit Test
//
//  Created by Nasko on 5/12/13.
//  Copyright (c) 2013 Nasko. All rights reserved.
//

#import "Unit_Test.h"
#import "MapViewController.h"

@implementation Unit_Test

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testTrackColorZero
{
    MapViewController *mvc = [[MapViewController alloc] init];
    STAssertEqualObjects([mvc colorForTrackInteger:0], [UIColor purpleColor], @"If the track integer is 0, the color should be purple.");
}

- (void)testTrackColorOne
{
    MapViewController *mvc = [[MapViewController alloc] init];
    STAssertEqualObjects([mvc colorForTrackInteger:1], [UIColor blueColor], @"If the track integer is 1, the color should be blue.");
}

- (void)testTrackColorTwo
{
    MapViewController *mvc = [[MapViewController alloc] init];
    STAssertEqualObjects([mvc colorForTrackInteger:2],[UIColor redColor], @"If the track integer is 2, the color should be red.");
}

- (void)testTrackColorTree
{
    MapViewController *mvc = [[MapViewController alloc] init];
    STAssertEqualObjects([mvc colorForTrackInteger:3],[UIColor greenColor], @"If the track integer is 3, the color should be green.");
}
- (void)testTrackColorFour
{
    MapViewController *mvc = [[MapViewController alloc] init];
    STAssertEqualObjects([mvc colorForTrackInteger:4],[UIColor blueColor], @"If the track integer is 4, the color should be blue.");
}

@end
