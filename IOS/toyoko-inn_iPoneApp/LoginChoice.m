//
//  LoginChoice.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/06/04.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "LoginChoice.h"
#import "Constant.h"

@interface LoginChoice ()

@end

@implementation LoginChoice

NSArray *buttons;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    buttons = [[NSArray alloc]initWithObjects:_BirthPWButton, _NameBirthButton, _MemberButton, _NormalButton, _InfoModifyButton, nil];
    
    for(UIButton *b in buttons)
    {
        b.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        [b.imageView setContentMode: UIViewContentModeCenter];
        b.layer.borderWidth = 0.5f;
        b.layer.borderColor = [UIColor blackColor].CGColor;
    }
    
    _InfoModifyButton.clipsToBounds = YES;
    _InfoModifyButton.layer.cornerRadius = 10;
    
    //disable the "info modify" button if there is no reservation person UID
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if([ud stringForKey:PERSON_UID] == nil)
    {
        _InfoModifyButton.enabled = NO;
    }
    else
    {
        _InfoModifyButton.enabled = YES;
    }
#if 0
    NSLog(@"gender codes: %@", [Constant getGenderNames:@"en"]);
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)BackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)BirthPWPressed:(id)sender {
    UIViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"PWLoginView"];
    [self presentViewController:next animated:YES completion:^ {
        
    }];
}

- (IBAction)NameBirthPressed:(id)sender {
    UIViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"BirthdayLogin"];
    [self presentViewController:next animated:YES completion:^ {
        
    }];
}

- (IBAction)MemberPressed:(id)sender {
    UIViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"MemberLogin"];
    [self presentViewController:next animated:YES completion:^ {
        
    }];
}

- (IBAction)NormalPressed:(id)sender {
    UIViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"infoReg"];
    [self presentViewController:next animated:YES completion:^ {
        
    }];    
}

- (IBAction)InfoModifyPressed:(id)sender {
    UIViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"infoChange"];
    [self presentViewController:next animated:YES completion:^ {
        
    }];
}

@end
