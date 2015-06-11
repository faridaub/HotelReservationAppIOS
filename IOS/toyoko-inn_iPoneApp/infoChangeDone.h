//
//  infoChangeDone.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/08/07.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToyokoCustomTableVC.h"

@interface infoChangeDone : UIViewController
- (IBAction)HomePressed:(id)sender;
- (IBAction)ConfirmPressed:(id)sender;
@property ToyokoCustomTableVC *targetTableVC;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *ConfirmButton;

@end
