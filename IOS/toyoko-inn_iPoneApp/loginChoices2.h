//
//  loginChoices2.h
//  toyoko-inn
//
//  Created by toyokoinn on 2015/01/07.
//  Copyright (c) 2015年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToyokoNetBase.h"

@interface loginChoices2 : ToyokoNetBase<ToyokoNetBaseDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *mailAddr;
@property (weak, nonatomic) IBOutlet UITextField *password;
- (IBAction)loginPressed:(id)sender;
//- (IBAction)autoLoginSwitched:(id)sender;
//- (IBAction)displayPasswdSwitched:(id)sender;
//@property (weak, nonatomic) IBOutlet UISwitch *autoLoginSwitch;
//@property (weak, nonatomic) IBOutlet UISwitch *displayPasswdSwitch;
//- (IBAction)MemberLoginPressed:(id)sender;
- (IBAction)NormalLoginPressed:(id)sender;
- (IBAction)NewRegPressed:(id)sender;
- (IBAction)PasswdResetPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
//@property (weak, nonatomic) IBOutlet UIButton *MemberLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *NormalLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *NewRegButton;
- (IBAction)BackPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *autoLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *DispPasswdButton;
- (IBAction)autoLoginPressed:(id)sender;
- (IBAction)DispPasswdPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *PasswdResetButton;

@end
