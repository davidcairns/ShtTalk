//
//  STTransitionViewController.m
//  ShitTalk
//
//  Created by David Cairns on 12/6/14.
//  Copyright (c) 2014 David Cairns. All rights reserved.
//

#import "STTransitionViewController.h"

@interface STTransitionViewController ()

@end

@implementation STTransitionViewController

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self performSegueWithIdentifier:@"ShowMap" sender:self];
	});
}

@end
