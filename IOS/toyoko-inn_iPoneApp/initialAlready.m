//
//  initialAlready.m
//  toyoko-inn
//
//  Created by toyokoinn on 2015/01/22.
//  Copyright (c) 2015年 中崎拓真. All rights reserved.
//

#import "initialAlready.h"
#import "infoRegAdd2.h"
#import "AppDelegate.h"

@interface initialAlready ()

@end

@implementation initialAlready

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _bgLabel.layer.borderColor = [UIColor redColor].CGColor;
    _bgLabel.layer.borderWidth = 0.5f;
    
    NSArray *buttons = @[_loginButton, _resetPasswdButton/*, _otherIDButton*/];
    
    for(UIButton *button in buttons)
    {
        button.layer.borderWidth = 0.5f;
        button.layer.borderColor = [UIColor blackColor].CGColor;
    }
    
    _mailAddr.text = _inputDict[LOGIN_ID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.loginID = _inputDict[LOGIN_ID];
    
    UIViewController *ToVC = self.presentingViewController;
    while(ToVC != nil)
    {
        if ([NSStringFromClass([ToVC class]) isEqualToString:@"loginChoices2"])
        {
            break;
        }
        ToVC = ToVC.presentingViewController;
    }
    
    if(ToVC!=nil)
    {
        [ToVC dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        //go back to root view
        UIViewController *root = self.view.window.rootViewController;
        [root dismissViewControllerAnimated:YES completion:^{
            UIViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"loginChoices2"];
            [root presentViewController:next animated:YES completion:^ {
                
            }];
        }];
    }
}

- (IBAction)resetPasswdPressed:(id)sender {
    UIViewController *ToVC = self.presentingViewController;
    while(ToVC != nil)
    {
        if ([NSStringFromClass([ToVC class]) isEqualToString:@"loginChoices2"])
        {
            break;
        }
        ToVC = ToVC.presentingViewController;
    }
    
    if(ToVC!=nil)
    {
        [ToVC dismissViewControllerAnimated:YES completion:^{
            UIViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"ResetPasswd1"];
            [ToVC presentViewController:next animated:YES completion:nil];
        }];
    }
    else
    {
        UIViewController *root = self.view.window.rootViewController;
        [root dismissViewControllerAnimated:NO completion:^{
            UIViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"ResetPasswd1"];
            [root presentViewController:next animated:YES completion:nil];
        }];
    }
}

- (IBAction)otherIDPressed:(id)sender {
    //move to inforegadd2
    infoRegAdd2 *next = (infoRegAdd2*)[self.storyboard instantiateViewControllerWithIdentifier:@"infoRegAdd2"];
    next.inputDict = _inputDict;
    [self presentViewController:next animated:YES completion:nil];
}

- (IBAction)BackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}
@end
