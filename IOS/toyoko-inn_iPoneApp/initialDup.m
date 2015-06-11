//
//  initialDup.m
//  toyoko-inn
//
//  Created by toyokoinn on 2015/01/08.
//  Copyright (c) 2015年 中崎拓真. All rights reserved.
//

#import "initialDup.h"

@interface initialDup ()

@end

@implementation initialDup

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _bgLabel.layer.borderColor = [UIColor redColor].CGColor;
    _bgLabel.layer.borderWidth = 0.5f;
    
    NSArray *buttons = @[_LoginButton, _PasswordButton, _OtherMailButton];
    
    for(UIButton *button in buttons)
    {
        button.layer.borderWidth = 0.5f;
        button.layer.borderColor = [UIColor blackColor].CGColor;
    }
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
        [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)passwordPressed:(id)sender {
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

- (IBAction)OtherMailPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)BackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}
@end
