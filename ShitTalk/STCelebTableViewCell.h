//
//  STCelebTableViewCell.h
//  ShitTalk
//
//  Created by David Cairns on 12/7/14.
//  Copyright (c) 2014 David Cairns. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STCelebTableViewCell : UITableViewCell

@property(nonatomic, strong)IBOutlet UIImageView *headshotView;
@property(nonatomic, strong)IBOutlet UILabel *titleLabel;
@property(nonatomic, strong)IBOutlet UILabel *timeLabel;

@end
