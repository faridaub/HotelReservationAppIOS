//
//  SettingView.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/06/04.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToyokoNetBase.h"
#import "DistanceSetting.h"

@interface SettingView : ToyokoNetBase<ToyokoNetBaseDelegate, DistanceSettingDelegate>//UIViewController
- (IBAction)BackPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *OfficialRemindSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *FavoriteRemindSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *ClosestRemindSwitch;
- (IBAction)DistancePressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *DistanceButton;
- (IBAction)SwitchChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *ToyokoPush;
@property (weak, nonatomic) IBOutlet UILabel *FavoritePush;
@property (weak, nonatomic) IBOutlet UILabel *NearestPush;

@end
