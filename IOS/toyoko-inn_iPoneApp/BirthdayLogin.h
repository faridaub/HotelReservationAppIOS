//
//  BirthdayLogin.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/08/14.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToyokoCustomTableVC.h"
#import "ToyokoNetBase.h"

@interface BirthdayLogin : ToyokoNetBase<ToyokoNetBaseDelegate>//UIViewController
@property ToyokoCustomTableVC *targetTableVC;
- (IBAction)BackPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *LoginButton;
@property (weak, nonatomic) IBOutlet UIButton *NewRegButton;
- (IBAction)LoginPressed:(id)sender;
- (IBAction)NewRegPressed:(id)sender;

@end
