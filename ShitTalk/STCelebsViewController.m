//
//  STCelebsViewController.m
//  ShitTalk
//
//  Created by David Cairns on 12/6/14.
//  Copyright (c) 2014 David Cairns. All rights reserved.
//

#import "STCelebsViewController.h"
#import "STCelebTableViewCell.h"

@interface STCelebEntry : NSObject
@property(nonatomic, strong)UIImage *image;
@property(nonatomic, strong)NSString *name;
@property(nonatomic, strong)NSString *time;
@end
@implementation STCelebEntry
+ (STCelebEntry *)celebWithName:(NSString *)name image:(UIImage *)image time:(NSString *)time {
	STCelebEntry *e = [[STCelebEntry alloc] init];
	e.name = name;
	e.image = image;
	e.time = time;
	return e;
}
@end


@interface STCelebsViewController ()
@property(nonatomic, strong)NSArray *celebEntries;
@end

@implementation STCelebsViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	UIView *const titleView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 160.0, 44.0)];
	UILabel *const titleLabel = [[UILabel alloc] initWithFrame:titleView.bounds];
	titleLabel.textAlignment = NSTextAlignmentCenter;
	titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
	titleLabel.text = @"Verified Shitters";
	[titleView addSubview:titleLabel];
	UIImage *const checkImage = [UIImage imageNamed:@"verified check"];
	UIImageView *const checkmarkImageView = [[UIImageView alloc] initWithImage:checkImage];
	checkmarkImageView.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame) - checkImage.size.width, 5.0, checkImage.size.width, checkImage.size.height);
	[titleView addSubview:checkmarkImageView];
	self.navigationItem.titleView = titleView;
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(_closeButtonTapped:)];
	
	self.celebEntries = @[
						  [STCelebEntry celebWithName:@"Angelina Jolie" image:[UIImage imageNamed:@"ANGELINAJOLIE"] time:@"2:00 am"],
						  [STCelebEntry celebWithName:@"Ice Cube" image:[UIImage imageNamed:@"icecube"] time:@"11:59pm"],
						  [STCelebEntry celebWithName:@"Betty White" image:[UIImage imageNamed:@"bettywhite"] time:@"1:12 pm"],
						  [STCelebEntry celebWithName:@"Carrot Top" image:[UIImage imageNamed:@"carlos mencia"] time:@"3:44pm"],
						  [STCelebEntry celebWithName:@"Carlos Mencia" image:[UIImage imageNamed:@"carrottop"] time:@"4:30 tea"],
//						  [STCelebEntry celebWithName:@"Bill Clinton" image:[UIImage imageNamed:@"billclinton"] time:@"8:30 am"],
//						  [STCelebEntry celebWithName:@"Taylor Swift" image:[UIImage imageNamed:@"taylorswift"] time:@"12:00 pm"],
//						  [STCelebEntry celebWithName:@"Bernie Madoff" image:[UIImage imageNamed:@"berniemadoff"] time:@"10:07 am"],
//						  [STCelebEntry celebWithName:@"Chris Bosh" image:[UIImage imageNamed:@"chrisbosh"] time:@"5:16 pm"],
//						  [STCelebEntry celebWithName:@"Tina Fey" image:[UIImage imageNamed:@"tinafey"] time:@"8:10 pm"],
						  ];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.celebEntries.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *const CelebReuseIdentifier = @"CelebReuseIdentifier";
	STCelebTableViewCell *cell = (STCelebTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CelebReuseIdentifier];
	if(!cell) {
		cell = [[STCelebTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CelebReuseIdentifier];
	}
	
	STCelebEntry *e = self.celebEntries[indexPath.row];
	cell.headshotView.image = e.image;
#if 1
	const int numPoops = (indexPath.row == 4 ? 1 : rand() % 5 + 1);
	NSMutableString *const poopsString = [NSMutableString string];
	for(NSInteger i = 0; i < numPoops; i++) {
		[poopsString appendString:@"💩"];
	}
	cell.titleLabel.text = [NSString stringWithFormat:@"%@!", poopsString];
#else
	cell.titleLabel.text = [NSString stringWithFormat:@"did a 💩!"];
#endif
	cell.timeLabel.text = e.time;
	
	return cell;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//	return 48.0;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	UIImage *heartImage = [UIImage imageNamed:@"heart"];
	UIImageView *imageView = [[UIImageView alloc] initWithImage:heartImage];
	imageView.bounds = CGRectMake(0.0, 0.0, heartImage.size.width, heartImage.size.height);
	imageView.opaque = NO;
	imageView.alpha = 0.0;
	imageView.backgroundColor = [UIColor colorWithRed:1.0 green:0.6 blue:0.6 alpha:0.7];
	imageView.layer.cornerRadius = 10.0;
	[self.view.window addSubview:imageView];
	imageView.center = CGPointMake(CGRectGetMidX(self.view.window.bounds), CGRectGetMidY(self.view.window.bounds));
	[UIView animateWithDuration:0.3 animations:^{
		imageView.alpha = 1.0;
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:0.3 delay:0.5 options:0 animations:^{
			imageView.alpha = 0.0;
		} completion:^(BOOL finished) {
			[imageView removeFromSuperview];
		}];
	}];
}


- (void)_closeButtonTapped:(id)sender {
	[self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
}

@end
