//
//  infoRegAdd2.h
//  toyoko-inn
//
//  Created by toyokoinn on 2015/01/20.
//  Copyright (c) 2015年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToyokoCustomTableVC.h"
#import "ToyokoNetBase.h"

@interface infoRegAdd2 : ToyokoNetBase<ToyokoNetBaseDelegate, UITextFieldDelegate>
//@property (weak, nonatomic) IBOutlet UITextField *mail1;
//@property (weak, nonatomic) IBOutlet UITextField *mailAddrInput;
//@property (weak, nonatomic) IBOutlet UITextField *passwd1;
//@property (weak, nonatomic) IBOutlet UITextField *passwd2;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *RuleButton;
@property (weak, nonatomic) IBOutlet UIButton *ConfirmButton;
- (IBAction)RulePressed:(id)sender;
- (IBAction)ConfirmPressed:(id)sender;
- (IBAction)BackPressed:(id)sender;
@property NSMutableDictionary *inputDict;
@property ToyokoCustomTableVC *targetTableVC;
@end
