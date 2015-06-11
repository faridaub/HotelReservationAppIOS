//
//  sameBirthWarning.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/08/15.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToyokoCustomTableVC.h"
#import "ToyokoNetBase.h"

@interface sameBirthWarning : ToyokoNetBase<ToyokoNetBaseDelegate>//UIViewController
@property ToyokoCustomTableVC *targetTableVC;
@property NSMutableDictionary *inputDict;
- (IBAction)BackPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *LoginButton;
- (IBAction)LoginPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end
