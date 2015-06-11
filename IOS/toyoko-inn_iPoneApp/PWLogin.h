//
//  PWLogin.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/08/14.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToyokoCustomTableVC.h"
#import "ToyokoNetBase.h"

@interface PWLogin : ToyokoNetBase<ToyokoNetBaseDelegate>//UIViewController
- (IBAction)BackPressed:(id)sender;
@property ToyokoCustomTableVC *targetTableVC;
@property (weak, nonatomic) IBOutlet UIButton *LoginButton;
@property (weak, nonatomic) IBOutlet UIButton *NoPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *NewRegButton;
@property (weak, nonatomic) IBOutlet UIView *containerView;
- (IBAction)LoginPressed:(id)sender;
- (IBAction)NoPasswordPressed:(id)sender;
- (IBAction)NewRegPressed:(id)sender;

@end
