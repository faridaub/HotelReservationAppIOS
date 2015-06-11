//
//  AcountSetting.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/06/04.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToyokoNetBase.h"

@interface AcountSetting: ToyokoNetBase<ToyokoNetBaseDelegate> /*UIViewController<NSURLConnectionDataDelegate, NSURLConnectionDelegate>*/
- (IBAction)BackPressed:(id)sender;
- (IBAction)LoginOutPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *LoginOutButton;
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *NumPointsLabel;
@property (weak, nonatomic) IBOutlet UIButton *ConfirmButton;
@property (weak, nonatomic) IBOutlet UIButton *HistoryButton;
@property (weak, nonatomic) IBOutlet UIButton *FavoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *ViewHistoryButton;
@property (weak, nonatomic) IBOutlet UIButton *InfoModifyButton;
@property (weak, nonatomic) IBOutlet UIButton *SettingButton;
- (IBAction)ConfirmPressed:(id)sender;
- (IBAction)HistoryPressed:(id)sender;
- (IBAction)FavoritePressed:(id)sender;
- (IBAction)ViewHistPressed:(id)sender;
- (IBAction)InfoModifyPressed:(id)sender;
- (IBAction)SettingPressed:(id)sender;

@end
