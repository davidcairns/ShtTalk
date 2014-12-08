//
//  STChatMessage.m
//  ShitTalk
//
//  Created by David Cairns on 12/6/14.
//  Copyright (c) 2014 David Cairns. All rights reserved.
//

#import "STChatMessage.h"

@interface STChatMessage ()
@property(nonatomic, assign)STChatType type;
@property(nonatomic, copy)NSString *senderName;
@property(nonatomic, copy)NSString *body;
@end

@implementation STChatMessage

+ (instancetype)chatMessageWithText:(NSString *)text sender:(NSString *)senderName {
	STChatMessage *m = [[STChatMessage alloc] init];
	m.type = STChatText;
	m.senderName = senderName;
	m.body = text;
	return m;
}
+ (instancetype)emoteMessageSender:(NSString *)senderName body:(NSString *)body {
	STChatMessage *m = [[STChatMessage alloc] init];
	m.type = STChatEmote;
	m.senderName = senderName;
	m.body = body;
	return m;
}

@end
