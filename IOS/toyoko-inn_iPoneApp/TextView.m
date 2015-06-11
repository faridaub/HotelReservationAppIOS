//
//  TextView.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/12/03.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "TextView.h"

@interface TextView ()

@end

@implementation TextView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _NaviBar.topItem.title = _viewTitle;
    _textView.text = _text;    
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

- (IBAction)BackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}
@end
