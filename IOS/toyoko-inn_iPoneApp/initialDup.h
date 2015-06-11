//
//  initialDup.h
//  toyoko-inn
//
//  Created by toyokoinn on 2015/01/08.
//  Copyright (c) 2015年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface initialDup : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *LoginButton;
@property (weak, nonatomic) IBOutlet UIButton *PasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *OtherMailButton;
- (IBAction)loginPressed:(id)sender;
- (IBAction)passwordPressed:(id)sender;
- (IBAction)OtherMailPressed:(id)sender;
- (IBAction)BackPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *bgLabel;

@end
