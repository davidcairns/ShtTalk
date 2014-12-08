//
//  STChatCell.h
//  ShitTalk
//
//  Created by David Cairns on 12/6/14.
//  Copyright (c) 2014 David Cairns. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STChatCell : UICollectionViewCell

@property(nonatomic, strong)IBOutlet UIImageView *chatBubbleImageView;
@property(nonatomic, strong)IBOutlet UILabel *senderLabel;
@property(nonatomic, strong)IBOutlet UILabel *textLabel;

+ (UIFont *)bodyFont;
+ (UIImage *)stretchableChatImage:(BOOL)isLeft;

@end
