//
//  reservCancel.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/08/07.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToyokoCustomTableVC.h"
#import "ToyokoNetBase.h"

@interface reservCancel : /*ToyokoNetBase<ToyokoNetBaseDelegate>*/UIViewController
@property ToyokoCustomTableVC *targetTableVC;
@property NSDictionary *inputDict;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *ConfirmButton;
- (IBAction)HomePressed:(id)sender;
- (IBAction)ConfirmPressed:(id)sender;

@end
