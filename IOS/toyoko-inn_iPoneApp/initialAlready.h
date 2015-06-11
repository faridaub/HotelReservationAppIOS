//
//  initialAlready.h
//  toyoko-inn
//
//  Created by toyokoinn on 2015/01/22.
//  Copyright (c) 2015年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface initialAlready : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *bgLabel;
@property (weak, nonatomic) IBOutlet UILabel *mailAddr;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *resetPasswdButton;
//@property (weak, nonatomic) IBOutlet UIButton *otherIDButton;
- (IBAction)loginPressed:(id)sender;
- (IBAction)resetPasswdPressed:(id)sender;
- (IBAction)otherIDPressed:(id)sender;
- (IBAction)BackPressed:(id)sender;
@property NSMutableDictionary *inputDict;

@end
