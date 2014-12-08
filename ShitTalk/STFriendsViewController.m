//
//  STFriendsViewController.m
//  ShitTalk
//
//  Created by David Cairns on 12/6/14.
//  Copyright (c) 2014 David Cairns. All rights reserved.
//

#import "STFriendsViewController.h"

@interface STFriendEntry : NSObject
@property(nonatomic, strong)NSString *name;
@property(nonatomic, assign)BOOL availableNow;
@end
@implementation STFriendEntry
+ (STFriendEntry *)friendWithName:(NSString *)name available:(BOOL)available {
	STFriendEntry *e = [[STFriendEntry alloc] init];
	e.name = name;
	e.availableNow = available;
	return e;
}
@end


@interface STFriendsViewController ()
@property(nonatomic, strong)NSArray *friendEntries;
@end

@implementation STFriendsViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.navigationItem.title = @"Twitter Friends";
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(_closeButtonTapped:)];
	
	self.friendEntries = @[
						   [STFriendEntry friendWithName:@"@troycarter_atom" available:NO],
						   [STFriendEntry friendWithName:@"@RhettAndLink" available:NO],
						   [STFriendEntry friendWithName:@"@feliciaday" available:NO],
						   [STFriendEntry friendWithName:@"@baratunde" available:YES],
						   ];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.friendEntries.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *const FriendCellReuseIdentifier = @"FriendCellReuseIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FriendCellReuseIdentifier];
	if(!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FriendCellReuseIdentifier];
	}
	
	STFriendEntry *e = self.friendEntries[indexPath.row];
	if(e.availableNow) {
		cell.textLabel.text = [NSString stringWithFormat:@"%@ is pooping now!", e.name];
		cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Italic" size:17.0];
		cell.textLabel.textColor = [UIColor blackColor];
		cell.backgroundColor = [UIColor colorWithRed:0.691 green:0.820 blue:1.000 alpha:1.000];
	}
	else {
		cell.textLabel.text = [NSString stringWithFormat:@"%@ isn’t on the toilet :(", e.name];
		cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Italic" size:17.0];
		cell.textLabel.textColor = [UIColor darkGrayColor];
		cell.backgroundColor = [UIColor lightGrayColor];
	}
	
	return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 48.0;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}


- (void)_closeButtonTapped:(id)sender {
	[self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
}

@end
