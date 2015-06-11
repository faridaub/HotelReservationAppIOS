//
//  RoomTypeSetting.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/06/04.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToyokoNetBase.h"

@protocol RoomTypeDelegate<NSObject>
@required
-(void)SetRoomType:(NSString*)roomTypeCode roomTypeName:(NSString*)roomTypeName;
@end

@interface RoomTypeSetting: ToyokoNetBase<ToyokoNetBaseDelegate>//UIViewController
- (IBAction)BackPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *SingleButton;
@property (weak, nonatomic) IBOutlet UIButton *DoubleButton;
@property (weak, nonatomic) IBOutlet UIButton *TwinButton;
@property (weak, nonatomic) IBOutlet UIButton *ConfirmButton;
@property BOOL realTimeMode; //search the num of hotels when constraint changed

@property id<RoomTypeDelegate> RoomDelegate;

- (IBAction)SinglePressed:(id)sender;
- (IBAction)DoublePressed:(id)sender;
- (IBAction)TwinPressed:(id)sender;
- (IBAction)ConfirmPressed:(id)sender;
- (void)HandleRadioGroup:(UIButton*)selected;
- (void)AddImageToButton:(UIButton*)button image:(UIImage*)img;

@end
