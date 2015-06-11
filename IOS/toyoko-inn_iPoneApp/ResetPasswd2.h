//
//  ResetPasswd2.h
//  toyoko-inn
//
//  Created by toyokoinn on 2015/01/09.
//  Copyright (c) 2015年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToyokoCustomTableVC.h"
#import "ToyokoNetBase.h"

@interface ResetPasswd2 : UIViewController
- (IBAction)BackPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *Step1;
@property (weak, nonatomic) IBOutlet UILabel *Step2;
@property (weak, nonatomic) IBOutlet UILabel *Step3;
@property (weak, nonatomic) IBOutlet UILabel *Step4;
@property (weak, nonatomic) IBOutlet UILabel *mailAddr;
@property (weak, nonatomic) IBOutlet UIView *containerView;
- (IBAction)ConfirmPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *ConfirmButton;
@property ToyokoCustomTableVC *targetTableVC;
@property NSDictionary *inputDict;
@property NSString *inputMailAddr;

@end
