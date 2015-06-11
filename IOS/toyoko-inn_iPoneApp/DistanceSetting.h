//
//  DistanceSetting.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/06/04.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToyokoNetBase.h"

@protocol DistanceSettingDelegate<NSObject>
@optional
-(void)SettingDone:(CGFloat)dist;
-(void)SettingChanged:(CGFloat)dist;
@end

@interface DistanceSetting : ToyokoNetBase<ToyokoNetBaseDelegate>//UIViewController
@property (weak, nonatomic) id<DistanceSettingDelegate>SettingDelegate;
@property (nonatomic) float initDist;
- (void)setDistance:(CGFloat)distance;
- (IBAction)BackPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *DistIndicator;
- (IBAction)DistanceChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *SaveButton;
- (IBAction)SavePressed:(id)sender;
@property (weak, nonatomic) IBOutlet UISlider *DistanceSlider;

@end
