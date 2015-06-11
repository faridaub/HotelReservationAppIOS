//
//  OtherOptionMenu.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/04/03.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherOptionMenu : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *ReserveButton;
@property (weak, nonatomic) IBOutlet UIButton *PointButton;
@property (weak, nonatomic) IBOutlet UIButton *SettingButton;
@property (weak, nonatomic) IBOutlet UIButton *GuideButton;
@property (weak, nonatomic) IBOutlet UIButton *InquiryButton;
@property (weak, nonatomic) IBOutlet UIToolbar *BackBar;
- (IBAction)ReservePressed:(id)sender;
- (IBAction)PointPessed:(id)sender;
- (IBAction)SettingPressed:(id)sender;
- (IBAction)GuidePressed:(id)sender;
- (IBAction)InquiryPressed:(id)sender;
- (IBAction)BackPressed:(id)sender;

@end
