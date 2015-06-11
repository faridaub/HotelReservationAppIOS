//
//  MailPasswdConfirm.h
//  toyoko-inn
//
//  Created by toyokoinn on 2015/01/08.
//  Copyright (c) 2015年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToyokoCustomTableVC.h"
#import "ToyokoNetBase.h"

@interface MailPasswdConfirm : ToyokoNetBase<ToyokoNetBaseDelegate>
- (IBAction)BackPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *RegButton;
- (IBAction)RegPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property ToyokoCustomTableVC *targetTableVC;
@property NSDictionary *inputDict;

@end
