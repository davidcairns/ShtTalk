//
//  STMapViewController.h
//  ShitTalk
//
//  Created by David Cairns on 12/6/14.
//  Copyright (c) 2014 David Cairns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "STFriendsViewController.h"
#import "STCelebsViewController.h"

@interface STMapViewController : UIViewController <MKMapViewDelegate>

@property(nonatomic, strong)IBOutlet MKMapView *mapView;

- (IBAction)celebsButtonTapped:(id)sender;
@property(nonatomic, strong)IBOutlet STCelebsViewController *celebsViewController;
- (IBAction)friendsButtonTapped:(id)sender;
@property(nonatomic, strong)IBOutlet STFriendsViewController *friendsViewController;

@end
