//
//  ToyokoButtonCell.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/07/15.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "ToyokoCustomCell.h"

@interface ToyokoButtonCell : ToyokoCustomCell
@property (nonatomic) NSString *buttonTitle;
@property (nonatomic) NSString *Tag;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property SEL PressedAction;
@property id delegate;
- (void)setIcon:(UIImage*)icon;
- (IBAction)buttonPressed:(id)sender;
- (void)setButtonTitle:(NSString*)title;
- (void)setAction:(SEL)action;
- (void)setDelegate:(id)target;
- (void)setButtonHidden:(BOOL)hidden;
@end
