//
//  DateSelectView.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/06/13.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSLCalendarView.h"

@protocol DateSelectDelegate<NSObject>
@required
-(void)SetCheckin:(NSString*)checkinDate nights:(int)nights;
@end

@interface DateSelectView : UIViewController<DSLCalendarViewDelegate>
- (IBAction)BackPressed:(id)sender;
- (IBAction)OKPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *days;
//@property (weak, nonatomic) IBOutlet UITextField *CheckinDate;
//@property (weak, nonatomic) IBOutlet UITextField *CheckoutDate;
@property (weak, nonatomic) IBOutlet UILabel *CheckinDate;
@property (weak, nonatomic) IBOutlet UILabel *CheckoutDate;
@property (weak, nonatomic) IBOutlet DSLCalendarView *calendar;
@property (weak, nonatomic) IBOutlet UIButton *OKButton;
//@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (weak, nonatomic) IBOutlet UILabel *DateBackLabel;
@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;
@property (weak, nonatomic) IBOutlet UILabel *nightsBackLabel;

@property id<DateSelectDelegate> DateDelegate;

- (IBAction)CheckinDateChanged:(id)sender;
- (IBAction)CheckoutDateChanged:(id)sender;
- (IBAction)daysChanged:(id)sender;
- (void)setCheckDates:(NSDateComponents*)checkin checkout:(NSDateComponents*)checkout;

@end
