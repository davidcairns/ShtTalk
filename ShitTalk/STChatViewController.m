//
//  STChatViewController.m
//  ShitTalk
//
//  Created by David Cairns on 12/5/14.
//  Copyright (c) 2014 David Cairns. All rights reserved.
//

#import "STChatViewController.h"
#import "STChatCell.h"
#import "STChatMessage.h"

@interface UIScrollView (STChats)
- (void)st_scrollToBottomAnimated:(BOOL)animated;
@end
@implementation UIScrollView (STChats)
- (void)st_scrollToBottomAnimated:(BOOL)animated {
	const CGFloat offset = (self.contentSize.height > self.bounds.size.height ? self.contentSize.height - self.bounds.size.height : -1.0 * self.contentInset.top);
	[self setContentOffset:CGPointMake(0.0, offset) animated:animated];
}
@end


NSString *const STChatCellReuseIdentifierLeft = @"STChatCellReuseIdentifierLeft";
NSString *const STChatCellReuseIdentifierRight = @"STChatCellReuseIdentifierRight";
NSString *const STEmoteCellReuseIdentifier = @"STEmoteCellReuseIdentifier";

@interface STChatViewController () <UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong)NSMutableArray *nigelChats;
@property(nonatomic, strong)NSMutableArray *lindseyChats;
@property(nonatomic, strong)NSArray *chats;
@end

@implementation STChatViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.navigationItem.title = @"💩💬";
	
	self.collectionView.backgroundColor = [UIColor blackColor];
	
	[self.collectionView registerNib:[UINib nibWithNibName:@"STChatCellLeft" bundle:nil] forCellWithReuseIdentifier:STChatCellReuseIdentifierLeft];
	[self.collectionView registerNib:[UINib nibWithNibName:@"STChatCellRight" bundle:nil] forCellWithReuseIdentifier:STChatCellReuseIdentifierRight];
	[self.collectionView registerNib:[UINib nibWithNibName:@"STEmoteCell" bundle:nil] forCellWithReuseIdentifier:STEmoteCellReuseIdentifier];
	
	// Load some sample chats!
	self.nigelChats = [NSMutableArray arrayWithArray:@[
													   [STChatMessage chatMessageWithText:@"Hello!" sender:@"Nigel"],
													   [STChatMessage chatMessageWithText:@"How are you?" sender:@"Nigel"],
													   [STChatMessage chatMessageWithText:@"Oh, I’m sorry to hear that." sender:@"Nigel"],
													   [STChatMessage emoteMessageSender:@"Nigel" body:@"💩🚽💨"],
													   [STChatMessage emoteMessageSender:@"Nigel" body:@"🏁"],
													   ]];
	self.lindseyChats = [NSMutableArray arrayWithArray:@[
														 [STChatMessage chatMessageWithText:@"Oh, hello! It’s my first time on SHTTALK!" sender:@"Lindsey"],
														 [STChatMessage chatMessageWithText:@"Not too great. The bank is defaulting on my mortgage." sender:@"Lindsey"],
														 [STChatMessage emoteMessageSender:@"Lindsey" body:@"💩"],
														 [STChatMessage chatMessageWithText:@"I’ve gotta go, the bank is calling" sender:@"Lindsey"],
														 ]];
	self.chats = @[];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	// Listen for keyboard notifications.
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}
- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	if(self.chats.count) {
		[self.collectionView st_scrollToBottomAnimated:YES];
	}
	
	[self.textField becomeFirstResponder];
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self _addNextNigelChat];
	});
}
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.chats.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	STChatCell *cell = nil;
	STChatMessage *const chatMessage = [self _chatForIndexPath:indexPath];
	if(chatMessage.type == STChatEmote) {
		cell = (STChatCell *)[collectionView dequeueReusableCellWithReuseIdentifier:STEmoteCellReuseIdentifier forIndexPath:indexPath];
		cell.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1.0];
		cell.textLabel.text = [NSString stringWithFormat:@"%@ made a %@", chatMessage.senderName, chatMessage.body];
	}
	else {
		const BOOL left = [chatMessage.senderName isEqualToString:@"Nigel"];
		NSString *const reuseIdentifier = (left ? STChatCellReuseIdentifierLeft : STChatCellReuseIdentifierRight);
		cell = (STChatCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
		cell.senderLabel.text = chatMessage.senderName;
		cell.backgroundColor = [UIColor clearColor];
		cell.textLabel.text = chatMessage.body;
		cell.chatBubbleImageView.image = [STChatCell stretchableChatImage:left];
	}
	
	return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	STChatMessage *const chat = [self _chatForIndexPath:indexPath];
	NSDictionary *const attributes = @{
									   NSFontAttributeName: [STChatCell bodyFont],
									   };
	const CGFloat width = 215.0;
	const CGRect r = [chat.body boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
	return CGSizeMake(self.collectionView.bounds.size.width, ceilf(12.0 + r.size.height + 26.0));
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if(!textField.text.length) {
		return YES;
	}
	
	// Submit the chat message!
	STChatMessage *const chat = [STChatMessage chatMessageWithText:textField.text sender:@"Nigel"];
	[self _submitChat:chat];
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self _submitChat:self.lindseyChats.firstObject];
		[self.lindseyChats removeObjectAtIndex:0];
	});
	
	return YES;
}


#pragma mark -
- (STChatMessage *)_chatForIndexPath:(NSIndexPath *)indexPath {
	return self.chats[indexPath.row];
}

- (void)_keyboardWillShow:(NSNotification *)notification {
	const CGRect keyboardEndFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
	const NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	[UIView animateWithDuration:duration animations:^{
		self.textFieldContainerBottomConstraint.constant = keyboardEndFrame.size.height;
	}];
}
- (void)_keyboardDidShow:(NSNotification *)notification {
	if(self.chats.count) {
		[self.collectionView st_scrollToBottomAnimated:YES];
	}
}
- (void)_keyboardWillHide:(NSNotification *)notification {
	const NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	[UIView animateWithDuration:duration animations:^{
		self.textFieldContainerBottomConstraint.constant = 0.0;
		self.textFieldContainerHeightConstraint.constant = 38.0;
	}];
}
- (void)_keyboardDidHide:(NSNotification *)notification {
	[self.collectionView st_scrollToBottomAnimated:YES];
}


- (void)_submitChat:(STChatMessage *)chat {
	NSIndexPath *const indexPath = [NSIndexPath indexPathForItem:self.chats.count inSection:0];
	[self.collectionView performBatchUpdates:^{
		self.chats = [self.chats arrayByAddingObject:chat];
		[self.collectionView insertItemsAtIndexPaths:@[indexPath]];
	} completion:^(BOOL finished) {
		self.textField.text = @"";
		[self.collectionView reloadData];
		[self.collectionView st_scrollToBottomAnimated:YES];
	}];
}
- (IBAction)emoteButtonTapped:(id)sender {
	NSString *body = [(UIButton *)sender titleLabel].text;
	STChatMessage *emote = [STChatMessage emoteMessageSender:@"Nigel" body:body];
	[self _submitChat:emote];
}


- (void)_typeMessageText:(NSString *)text progress:(NSInteger)progress includeInField:(BOOL)includeInField completion:(dispatch_block_t)completion {
	if(progress < text.length) {
		const NSInteger newProgress = MIN(text.length, progress + 10);
		if(includeInField) {
			self.textField.text = [text substringToIndex:newProgress];
		}
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[self _typeMessageText:text progress:newProgress includeInField:includeInField completion:completion];
		});
	}
	else {
		completion();
	}
}
- (void)_addNextNigelChat {
	if(!self.nigelChats.count) {
		return;
	}
	
	STChatMessage *const c = self.nigelChats.firstObject;
	[self.nigelChats removeObjectAtIndex:0];
	
	const BOOL fakeTyping = (STChatText == c.type);
	[self _typeMessageText:c.body progress:0 includeInField:fakeTyping completion:^{
		[self _submitChat:c];
		
		if(!self.lindseyChats.count) {
			return;
		}
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[self _submitChat:self.lindseyChats.firstObject];
			[self.lindseyChats removeObjectAtIndex:0];
			
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				[self _addNextNigelChat];
			});
		});
	}];
}

@end
