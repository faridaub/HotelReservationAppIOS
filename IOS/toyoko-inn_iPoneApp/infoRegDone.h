//
//  infoRegDone.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/08/07.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToyokoCustomTableVC.h"

@interface infoRegDone : UIViewController
- (IBAction)HomePressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *infoChangeButton;
@property (weak, nonatomic) IBOutlet UIButton *reservButton;
@property ToyokoCustomTableVC *targetTableVC;
- (IBAction)infoChangePressed:(id)sender;
- (IBAction)reservPressed:(id)sender;

@end
