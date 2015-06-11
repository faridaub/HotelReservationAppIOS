//
//  infoReg2.h
//  toyoko-inn
//
//  Created by toyokoinn on 2015/01/07.
//  Copyright (c) 2015年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToyokoCustomTableVC.h"
#import "ToyokoNetBase.h"

@interface infoReg2 : ToyokoNetBase<ToyokoNetBaseDelegate>
@property (weak, nonatomic) IBOutlet UIView *containerView;
- (IBAction)ConfirmPressed:(id)sender;
- (IBAction)BackPressed:(id)sender;
- (IBAction)RulePressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *ConfirmButton;
@property (weak, nonatomic) IBOutlet UIButton *RuleButton;
@property ToyokoCustomTableVC *targetTableVC;
@end
