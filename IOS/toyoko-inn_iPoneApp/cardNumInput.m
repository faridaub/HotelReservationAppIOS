//
//  cardNumInput.m
//  toyoko-inn
//
//  Created by toyokoinn on 2015/01/07.
//  Copyright (c) 2015年 中崎拓真. All rights reserved.
//

#import "cardNumInput.h"

@interface cardNumInput ()

@end

@implementation cardNumInput

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _bgLabel.layer.borderColor = [UIColor redColor].CGColor;
    _bgLabel.layer.borderWidth = 0.5f;
    
    _PrefixButton.layer.borderWidth = 0.5f;
    _PrefixButton.layer.borderColor = [UIColor blackColor].CGColor;
    
    _ConfirmButton.clipsToBounds = YES;
    _ConfirmButton.layer.cornerRadius = 10;
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

- (IBAction)PrefixPressed:(id)sender {
}
- (IBAction)noCardChanged:(id)sender {
}

- (IBAction)ConfirmPressed:(id)sender {
}

- (IBAction)BackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}
@end
