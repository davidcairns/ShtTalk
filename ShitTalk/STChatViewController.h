//
//  STChatViewController.h
//  ShitTalk
//
//  Created by David Cairns on 12/5/14.
//  Copyright (c) 2014 David Cairns. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STChatViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate>

@property(nonatomic, strong)IBOutlet UICollectionView *collectionView;

@property(nonatomic, strong)IBOutlet NSLayoutConstraint *textFieldContainerBottomConstraint;
@property(nonatomic, strong)IBOutlet NSLayoutConstraint *textFieldContainerHeightConstraint;
@property(nonatomic, strong)IBOutlet UIView *textFieldContainerView;
@property(nonatomic, strong)IBOutlet UIButton *emoteButton1;
@property(nonatomic, strong)IBOutlet UIButton *emoteButton2;
@property(nonatomic, strong)IBOutlet UIButton *emoteButton3;
@property(nonatomic, strong)IBOutlet UIButton *emoteButton4;
@property(nonatomic, strong)IBOutlet UIButton *emoteButton5;
@property(nonatomic, strong)IBOutlet UIButton *emoteButton6;
@property(nonatomic, strong)IBOutlet UITextField *textField;

- (IBAction)emoteButtonTapped:(id)sender;

@end
