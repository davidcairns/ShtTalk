//
//  STMapViewController.m
//  ShitTalk
//
//  Created by David Cairns on 12/6/14.
//  Copyright (c) 2014 David Cairns. All rights reserved.
//

#import "STMapViewController.h"

double randf(double min, double max) {
	const double i = (rand() % 1000) / 1000.0;
	return i * (max - min) + min;
}
CLLocationCoordinate2D randLocationNear(CLLocationCoordinate2D l) {
	return CLLocationCoordinate2DMake(l.latitude + randf(-0.0001, 0.0001), l.longitude + randf(-0.0001, 0.0001));
}

@interface STMapViewController () <CLLocationManagerDelegate>
@property(nonatomic, strong)CLLocationManager *locationManager;
@property(nonatomic, strong)CLLocation *currentLocation;
@property(nonatomic, strong)NSArray *nearbyPeopleAnnotations;
@end

@implementation STMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIView *const titleView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 240.0, 44.0)];
	UIImage *const titleImage = [UIImage imageNamed:@"darkSHTTALK"];
	UIImageView *const titleImageView = [[UIImageView alloc] initWithImage:titleImage];
	titleImageView.bounds = CGRectMake(0.0, 0.0, titleImage.size.width, titleImage.size.height);
	titleImageView.opaque = NO;
	titleImageView.center = CGPointMake(CGRectGetMidX(titleView.bounds), CGRectGetMidY(titleView.bounds));
	[titleView addSubview:titleImageView];
	self.navigationItem.titleView = titleView;
	
	// Make sure we can use the user's location.
	self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.delegate = self;
	if([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways) {
		[self.locationManager requestAlwaysAuthorization];
	}
	else {
		[self _startTrackingLocation];
	}
}

- (IBAction)celebsButtonTapped:(id)sender {
	[self performSegueWithIdentifier:@"ShowCelebs" sender:self];
}
- (IBAction)friendsButtonTapped:(id)sender {
	[self performSegueWithIdentifier:@"ShowFriends" sender:self];
}



#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
	if(!self.nearbyPeopleAnnotations) {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[self _addTestAnnotationsInRegion:MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 1000.0, 1000.0)];
		});
	}
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self performSegueWithIdentifier:@"PushChat" sender:self];
	});
}
	- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
	const CGRect visibleRect = [mapView annotationVisibleRect];
	for(MKAnnotationView *view in views) {
		if([view.annotation isKindOfClass:[MKUserLocation class]]) {
			continue;
		}
		
		const CGRect endFrame = view.frame;
		const CGRect startFrame = CGRectMake(endFrame.origin.x, visibleRect.origin.y - endFrame.size.height, endFrame.size.width, endFrame.size.height);
		view.frame = startFrame;
		
		[UIView animateWithDuration:0.3 animations:^{
			view.frame = endFrame;
		}];
	}
}



#pragma mark - CLLocationManagerDelegate
- (void)_addTestAnnotationsInRegion:(MKCoordinateRegion)region {
	// Show a couple annotations!
	NSMutableArray *annotations = [NSMutableArray array];
	const CLLocationDegrees minLatSpan = -0.5 * region.span.latitudeDelta;
	const CLLocationDegrees maxLatSpan = 0.5 * region.span.latitudeDelta;
	const CLLocationDegrees minLongSpan = -0.5 * region.span.longitudeDelta;
	const CLLocationDegrees maxLongSpan = 0.5 * region.span.longitudeDelta;
	for(NSInteger i = 0; i < 6; i++) {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(((float)i * 0.2) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			MKPointAnnotation *const nearbyPooper = [[MKPointAnnotation alloc] init];
			nearbyPooper.coordinate = CLLocationCoordinate2DMake(region.center.latitude + randf(minLatSpan, maxLatSpan), region.center.longitude + randf(minLongSpan, maxLongSpan));
			nearbyPooper.title = @"💩";
			[self.mapView addAnnotation:nearbyPooper];
		});
	}
	self.nearbyPeopleAnnotations = [NSArray arrayWithArray:annotations];
}
- (void)_startTrackingLocation {
	[self.locationManager startUpdatingLocation];
	
	// Zoom to the user's location.
	self.mapView.showsUserLocation = YES;
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	NSLog(@"CLLocationManager errored: %@", error);
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
	if(kCLAuthorizationStatusNotDetermined == status) {
		return;
	}
	else if(kCLAuthorizationStatusAuthorizedAlways == status) {
		[self _startTrackingLocation];
	}
	else {
		NSLog(@"Fuck! Location Services not authorized! FUUUUUCK!!!");
	}
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
	self.currentLocation = locations.firstObject;
	const MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.currentLocation.coordinate, 1000.0, 1000.0);
	[self.mapView setRegion:region animated:YES];
}

@end
