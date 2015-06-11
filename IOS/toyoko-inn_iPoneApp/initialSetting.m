//
//  initialSetting.m
//  toyoko-inn
//
//  Created by toyokoinn on 2015/01/07.
//  Copyright (c) 2015年 中崎拓真. All rights reserved.
//

#import "initialSetting.h"
#import "ToyokoNetBase.h"

@interface initialSetting ()

@end

@implementation initialSetting

#define BORDER_WIDTH 1.0f

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *buttons = @[_MemberLoginButton, _NormalLoginButton, _NewRegButton];
    
    for(UIButton *b in buttons)
    {
        b.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        [b.imageView setContentMode: UIViewContentModeCenter];
        b.layer.borderWidth = 0.5f;
        b.layer.borderColor = [UIColor blackColor].CGColor;
    }
#if 0
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0, _NewRegButton.frame.size.height - BORDER_WIDTH, _NewRegButton.frame.size.width, BORDER_WIDTH);
    bottomBorder.backgroundColor = [UIColor blackColor].CGColor;
    [_NewRegButton.layer addSublayer:bottomBorder];
#endif
    _BackButton.clipsToBounds = YES;
    _BackButton.layer.cornerRadius = 10;
    
#if 0
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:YES forKey:INITIALIZED];
    [ud synchronize];
#endif
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

- (IBAction)MemberLoginPressed:(id)sender {
    //TODO: jump to member login
    UIViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"MemberLogin"];
    [self presentViewController:next animated:YES completion:^ {
        
    }];
}

- (IBAction)NormalLoginPressed:(id)sender {
    //TODO: jump to normal login
    UIViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"BirthdayLogin"];
    [self presentViewController:next animated:YES completion:^ {
        
    }];
}

- (IBAction)NewRegPressed:(id)sender {
    //TODO: jump to infoReg2
    UIViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"infoReg2"];
    [self presentViewController:next animated:YES completion:^ {
        
    }];
}

- (IBAction)BackPressed:(id)sender {
#if 0
    [self dismissViewControllerAnimated:YES completion:^{}];
#else
    //go back to root view
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
#endif
}
@end
