//
//  ResetPasswd4.h
//  toyoko-inn
//
//  Created by toyokoinn on 2015/01/09.
//  Copyright (c) 2015年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToyokoCustomTableVC.h"

@interface ResetPasswd4 : UIViewController
- (IBAction)BackPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *Step1;
@property (weak, nonatomic) IBOutlet UILabel *Step2;
@property (weak, nonatomic) IBOutlet UILabel *Step3;
@property (weak, nonatomic) IBOutlet UILabel *Step4;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *ConfirmButton;
- (IBAction)ConfirmPressed:(id)sender;
@property ToyokoCustomTableVC *targetTableVC;
@end
