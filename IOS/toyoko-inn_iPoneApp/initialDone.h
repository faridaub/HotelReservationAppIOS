//
//  initialDone.h
//  toyoko-inn
//
//  Created by toyokoinn on 2015/01/06.
//  Copyright (c) 2015年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToyokoCustomTableVC.h"

@interface initialDone : UIViewController
- (IBAction)ConfirmPressed:(id)sender;
- (IBAction)BackPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property ToyokoCustomTableVC *targetTableVC;
@property (weak, nonatomic) IBOutlet UIButton *ConfirmButton;

@end
