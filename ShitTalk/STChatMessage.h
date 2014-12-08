//
//  STChatMessage.h
//  ShitTalk
//
//  Created by David Cairns on 12/6/14.
//  Copyright (c) 2014 David Cairns. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, STChatType) {
	STChatEmote = 0,
	STChatText,
};

@interface STChatMessage : NSObject

@property(nonatomic, assign, readonly)STChatType type;
@property(nonatomic, copy, readonly)NSString *senderName;
@property(nonatomic, copy, readonly)NSString *body;

+ (instancetype)chatMessageWithText:(NSString *)text sender:(NSString *)senderName;
+ (instancetype)emoteMessageSender:(NSString *)senderName body:(NSString *)body;

@end
