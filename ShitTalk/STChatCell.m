//
//  STChatCell.m
//  ShitTalk
//
//  Created by David Cairns on 12/6/14.
//  Copyright (c) 2014 David Cairns. All rights reserved.
//

#import "STChatCell.h"

@implementation STChatCell

+ (UIFont *)bodyFont {
//	return [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0];
	return [UIFont fontWithName:@"Helvetica" size:16.0];
}


+ (UIImage *)stretchableChatImage:(BOOL)isLeft {
	if(isLeft) {
//		UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
		UIImage *const baseImage = [UIImage imageNamed:@"shttalkbubble-left"];
		return [baseImage resizableImageWithCapInsets:UIEdgeInsetsMake(1.0, 29.0, 8.0, 1.0)];
	}
	else {
		UIImage *const baseImage = [UIImage imageNamed:@"shttalkbubble-right"];
		return [baseImage resizableImageWithCapInsets:UIEdgeInsetsMake(1.0, 1.0, 8.0, 29.0)];
	}
}

@end
