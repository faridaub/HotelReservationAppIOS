//
//  ConstraintInput.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/06/06.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToyokoNetBase.h"
#import "DateSelectView.h"
#import "DestSearch.h"
#import "RoomTypeSetting.h"
#import "DistanceSetting.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"

@interface ConstraintInput : ToyokoNetBase<ToyokoNetBaseDelegate, DateSelectDelegate, DestSearchDelegate, RoomTypeDelegate, DistanceSettingDelegate, CLLocationManagerDelegate>//UIViewController
- (IBAction)BackPressed:(id)sender;
- (IBAction)SmokingChanged:(id)sender;
- (IBAction)RoomsChanged:(id)sender;
- (IBAction)PeopleChanged:(id)sender;
- (IBAction)NightsChanged:(id)sender;
- (IBAction)SearchPressed:(id)sender;
-(void)AddFormattedStringToCell:(UITableViewCell*)cell str1:(NSString*)str1 str2:(NSString*)str2;
-(void)FillCell:(UITableViewCell*)cell keyword:(NSString*)keyword;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *SearchButton;
@property (strong, nonatomic) IBOutlet UISwitch *SmokingSwitch;
@property (strong, nonatomic) IBOutlet UIStepper *NightsStepper, *PeopleStepper, *RoomsStepper;
@property (strong, nonatomic) IBOutlet UILabel *NightsLabel, *PeopleLabel, *RoomsLabel;
@property BOOL realTimeMode; //search the num of hotel every time when the constraint changed
@property NSArray *dispItems;
@end
