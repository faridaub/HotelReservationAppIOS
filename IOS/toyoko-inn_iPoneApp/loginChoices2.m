//
//  loginChoices2.m
//  toyoko-inn
//
//  Created by toyokoinn on 2015/01/07.
//  Copyright (c) 2015年 中崎拓真. All rights reserved.
//

#import "loginChoices2.h"
#import "Constant.h"
#import "AppDelegate.h"
#import "reservInput.h"

@interface loginChoices2 ()

@end



@implementation loginChoices2

static NSArray *textfields;

#define BORDER_WIDTH 1.0f

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _loginButton.clipsToBounds = YES;
    _loginButton.layer.cornerRadius = 10;
#if 0
    NSArray *buttons = @[_MemberLoginButton, _NormalLoginButton];
    
    for(UIButton *b in buttons)
    {
        b.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        [b.imageView setContentMode: UIViewContentModeCenter];
        b.layer.borderWidth = 0.5f;
        b.layer.borderColor = [UIColor blackColor].CGColor;
    }
#endif
    NSArray *buttons = @[_PasswdResetButton, _NormalLoginButton, /*_NewRegButton, _autoLoginButton, _DispPasswdButton*/];
    for(UIButton *b in buttons)
    {
        b.layer.borderWidth = 0.5f;
        b.layer.borderColor = [UIColor blackColor].CGColor;
    }
    
    NSArray *checkbuttons = @[_autoLoginButton, _DispPasswdButton];
    for(UIButton *b in checkbuttons)
    {
        b.selected = NO;
        [b setImage:[UIImage imageNamed:@"チェックオン"] forState:UIControlStateSelected];
#if 0
        b.imageView.contentMode = UIViewContentModeCenter;
        b.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        [b setImage:[UIImage imageNamed:@"大きいチェックマーク"] forState:UIControlStateSelected];
#endif
    }
    _autoLoginButton.selected = YES;
    
#if 0
    _MemberLoginButton.layer.borderWidth = 0.5f;
    _MemberLoginButton.layer.borderColor = [UIColor blackColor].CGColor;
    
    _NormalLoginButton.layer.borderColor = [UIColor blackColor].CGColor;
    _NormalLoginButton.layer.borderWidth = 0.5f;
#endif
#if 0
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0, _NewRegButton.frame.size.height - BORDER_WIDTH, _NewRegButton.frame.size.width, BORDER_WIDTH);
    bottomBorder.backgroundColor = [UIColor blackColor].CGColor;
    [_NewRegButton.layer addSublayer:bottomBorder];
#endif
#if 0
    _mailAddr.delegate = self;
    _password.delegate = self;
    
    [self textChanged:_mailAddr];
    [self textChanged:_password];
#endif
    textfields = @[_mailAddr, _password];
    
    for(UITextField *tf in textfields)
    {
        tf.delegate = self;
        [self textChanged:tf];
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if(appDelegate.loginID != nil)
    {
        _mailAddr.text = appDelegate.loginID;
        appDelegate.loginID = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self textChanged:textField];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(UITextFieldTextDidChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //NSLog(@"tf.text = %@", textField.text);
    // enter closes the keyboard
    if ([string isEqualToString:@"\n"])
    {
        [textField resignFirstResponder];
        return NO;
    }
    else if ([string isEqualToString:@""]) //handle backspace
    {
        return YES;
    }
    
    return YES;
}

#if 1
- (IBAction)textChanged:(id)sender {
#if 0
    UITextField *tf = (UITextField*)sender;

    NSLog(@"text changed: %@", tf.text);
#endif
    
#if 0
    NSString *value = tf.text;
    //TODO: add warning mark
    if(value.length == 0)
    {
        UIImage *warning = [UIImage imageNamed:@"警告"];
        UIImageView *warningMark = [[UIImageView alloc] initWithImage:warning];
        warningMark.transform = CGAffineTransformMakeScale(0.5, 0.5);
        warningMark.contentMode = UIViewContentModeCenter;
        warningMark.frame = CGRectMake(0, 0, warning.size.width+10.0f, warning.size.height);
        tf.rightView = warningMark;
        tf.rightViewMode = UITextFieldViewModeUnlessEditing;
    }
    else
    {
        tf.rightView = nil;
    }
#endif
}
#endif

- (void) UITextFieldTextDidChange:(NSNotification*)notification
{
    UITextField * textfield = (UITextField*)notification.object;
    [self textChanged:textfield];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loginPressed:(id)sender {
    NSString *mail = _mailAddr.text;
    NSString *pass = _password.text;
    
    UIAlertView *alert;
    
    if (mail.length == 0) {
        alert = [[UIAlertView alloc] initWithTitle:@"確認" message:@"メールアドレスが未入力です。"delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    
    if (pass.length == 0) {
        alert = [[UIAlertView alloc] initWithTitle:@"確認" message:@"パスワードが未入力です。"delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    
    //check the e-mail address
    if(![Constant IsValidEmail:mail])
    {
        alert =
        [[UIAlertView alloc] initWithTitle:@"確認" message:@"メールアドレスは正しくありません。もう一度ご確認ください。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    
    NSDictionary *dict = @{@"lgnId": mail, @"lgnPsswrd":pass};
    
    self.delegate = self;
    [self addRequestFields:dict];
    [self setApiName:@"login_api"];
    [self setSecure:NO];
    
    [self sendRequest];
}

#if 0
- (IBAction)autoLoginSwitched:(id)sender {
}

- (IBAction)displayPasswdSwitched:(id)sender {
    UISwitch *sw = (UISwitch*)sender;
    
    _password.secureTextEntry = !sw.on;
}
#endif

- (IBAction)MemberLoginPressed:(id)sender {
    //TODO: jump to member login
    UIViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"MemberLogin"];
    [self presentViewController:next animated:YES completion:^ {
        
    }];
}

- (IBAction)NormalLoginPressed:(id)sender {
    //TODO: jump to normal login
    UIViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"initialSetting"/*@"BirthdayLogin"*/];
    [self presentViewController:next animated:YES completion:^ {
        
    }];
}

- (IBAction)NewRegPressed:(id)sender {
    //TODO: jump to infoReg2
    UIViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"infoReg2"];
    [self presentViewController:next animated:YES completion:^ {
        
    }];
}

- (IBAction)PasswdResetPressed:(id)sender {
    //TODO: jump to ResetPasswd1
    UIViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"ResetPasswd1"];
    [self presentViewController:next animated:YES completion:^ {
        
    }];
}
- (IBAction)BackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)ParsedDataReady:(NSDictionary*)data
{
    NSLog(@"data: %@", data);
    
    if([data[@"errrCode"] isEqualToString:@"BCMN0000"])
    {
        NSString *uid = data[PERSON_UID];
        NSString *fmlyName = data[FAMILY_NAME];
        NSString *frstName = data[GIVEN_NAME];
        NSString *sex = data[GENDER];
        NSString *nationCode = data[NATIONALITY];
        NSString *loginId = data[LOGIN_ID];
        NSString *loginPass = data[LOGIN_PASSWD];
        NSString *member_num = data[MEMBER_NUM];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setObject:uid forKey:PERSON_UID];
        [defaults setObject:fmlyName forKey:FAMILY_NAME];
        [defaults setObject:frstName forKey:GIVEN_NAME];
        [defaults setObject:sex forKey:GENDER];
        [defaults setObject:nationCode forKey:NATIONALITY];
        [defaults setObject:loginId forKey:LOGIN_ID];
        [defaults setObject:loginPass forKey:LOGIN_PASSWD];
        
        if(member_num)
            [defaults setObject:member_num forKey:MEMBER_NUM];

        if(_autoLoginButton.selected)
        {
            [defaults setObject:@"Y" forKey:AUTO_LOGIN];
        }
        else
        {
            [defaults setObject:@"N" forKey:AUTO_LOGIN];
        }
        
        [defaults setBool:YES forKey:INITIALIZED];
        [defaults removeObjectForKey:DISTANCE]; //reset the distance setting
        [defaults synchronize];
        
        UIViewController *ToVC = self.presentingViewController;
        while(ToVC != nil)
        {
            if ([NSStringFromClass([ToVC class]) isEqualToString:@"RoomInfoView"])
            {
                break;
            }
            ToVC = ToVC.presentingViewController;
        }
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        if(ToVC != nil && appDelegate.reservData != nil) //jumped from room info view
        {
            //go back to room info view and use room info view to open the reserv input view
            reservInput *next = [self.storyboard instantiateViewControllerWithIdentifier:@"reservInput"];
            next.inputDict = appDelegate.reservData;
            next.roomDict = appDelegate.roomDict;
            next.htlName = appDelegate.htlName;
            
            //use room info view to open new view in order to avoid login twice
            [ToVC dismissViewControllerAnimated:YES completion:^{
                [ToVC presentViewController:next animated:YES completion:nil];
            }];
        }
        else if(appDelegate.lastVC) //last VC exists
        {
            UIViewController *ToVC = self.presentingViewController;
            while(ToVC != nil)
            {
                if (ToVC == appDelegate.lastVC) //check if last VC is in hierarchy
                {
                    break;
                }
                ToVC = ToVC.presentingViewController;
            }
            
            if(ToVC) //jump back to last VC
            {
                [ToVC dismissViewControllerAnimated:YES completion:nil];
                appDelegate.lastVC = nil;
            }
            else //not in the hierarchy, last VC should be reset
            {
                appDelegate.lastVC = nil;
                UIViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountSetting"];
                [self presentViewController:next animated:YES completion:^ {
                    
                }];
            }
        }
        else
        {
#if 0
            //go back to root view
            [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
#else
            UIViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountSetting"];
            [self presentViewController:next animated:YES completion:^ {
                
            }];
#endif
        }
    }
    else
    {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"確認" message:/*data[@"errrMssg"]*/@"ログインに失敗しました。ID・パスワードをご確認の上、再度お試しください。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"はい", nil];
        [alert show];
    }
}

-(void)connectionFailed:(NSError*)error
{
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    //NSLog(@"touch.view: %@", touch.view);
    
    BOOL tfTouched = NO;
    
    for(UITextField *tf in textfields)
    {
        if(tf == touch.view)
        {
            tfTouched = YES;
            break;
        }
    }
    
    if(!tfTouched)
    {
        [self.view endEditing:YES];
    }
    
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)autoLoginPressed:(id)sender {
    _autoLoginButton.selected = !_autoLoginButton.selected;
}

- (IBAction)DispPasswdPressed:(id)sender {
    _DispPasswdButton.selected = !_DispPasswdButton.selected;
    _password.secureTextEntry = !_DispPasswdButton.selected;
}
@end

