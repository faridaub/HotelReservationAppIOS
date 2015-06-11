//
//  DateSelectView.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/06/13.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "DateSelectView.h"

@interface DateSelectView ()

@end

@implementation DateSelectView

#define MAX_NIGHTS 7
NSMutableDictionary *dayNames;

NSDate *checkinNSDate, *checkoutNSDate;

static NSUInteger days;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
#if 1
    _OKButton.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    _OKButton.imageView.contentMode = UIViewContentModeCenter;
    _OKButton.clipsToBounds = YES;
    _OKButton.layer.cornerRadius = 10;
#endif
    self.calendar.delegate = self;
    
    //get localized weekday names
    // Get a dictionary of localised day names
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit fromDate:[NSDate date]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"EEE";
    dayNames = [[NSMutableDictionary alloc] init];
    
    for (NSInteger index = 0; index < 7; index++) {
        NSInteger weekday = dateComponents.weekday - [dateComponents.calendar firstWeekday];
        if (weekday < 0) weekday += 7;
        [dayNames setObject:[formatter stringFromDate:dateComponents.date] forKey:@(weekday)];
        
        dateComponents.day = dateComponents.day + 1;
        dateComponents = [dateComponents.calendar components:NSCalendarCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit fromDate:dateComponents.date];
    }
    
    //To initialize the checkin/checkout fields
    [self setCheckDates:dateComponents checkout:dateComponents];
    
    //change the bg color of calendar same as the view
    _calendar.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:233.0/255.0 blue:235.0/255.0 alpha:1.0]/*self.view.backgroundColor*/;
    _calendar.layer.borderWidth = 1.0f;
    _calendar.layer.borderColor = [UIColor blackColor].CGColor;
    
    NSArray *labels = @[_nightsBackLabel, _DateBackLabel];
    
    for(UILabel* label in labels)
    {
        label.layer.cornerRadius = 10;
        label.clipsToBounds = YES;
        label.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        label.layer.borderWidth = 0.5;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)BackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)OKPressed:(id)sender {
    if([_DateDelegate respondsToSelector:@selector(SetCheckin:nights:)])
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyyMMdd"];

        [_DateDelegate SetCheckin:[dateFormat stringFromDate:checkinNSDate] nights:(int)days/*_stepper.value*/];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (IBAction)CheckinDateChanged:(id)sender {
}

- (IBAction)CheckoutDateChanged:(id)sender {
}

- (IBAction)daysChanged:(id)sender {
#if 0
    UIStepper *stepper = (UIStepper*)sender;
#else
    UIButton *btn = (UIButton*)sender;
#endif
    if(btn == _plusButton)
    {
        days++;
        if(days > MAX_NIGHTS)
            days = MAX_NIGHTS;
        
        if(days == MAX_NIGHTS)
        {
            [_plusButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [_minusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _plusButton.enabled = NO;
            _minusButton.enabled = YES;
        }
        else
        {
            [_plusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_minusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            //_plusButton.titleLabel.textColor = [UIColor whiteColor];
            //_minusButton.titleLabel.textColor = [UIColor whiteColor];
            _plusButton.enabled = YES;
            _minusButton.enabled = YES;
        }
    }
    else if(btn == _minusButton)
    {
        days--;
        if(days < 1)
            days = 1;
        
        if(days == 1)
        {
            [_plusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_minusButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            _plusButton.enabled = YES;
            _minusButton.enabled = NO;
            //_plusButton.titleLabel.textColor = [UIColor whiteColor];
            //_minusButton.titleLabel.textColor = [UIColor grayColor];
        }
        else
        {
            [_plusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_minusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _plusButton.enabled = YES;
            _minusButton.enabled = YES;
            //_plusButton.titleLabel.textColor = [UIColor whiteColor];
            //_minusButton.titleLabel.textColor = [UIColor whiteColor];
        }
    }
    
    _days.text = [NSString stringWithFormat:@"%d", (int)days];
    
    //TODO: To change the checkout date according to the stepper value
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp = [[NSDateComponents alloc]init];
    comp.day = (int)days;
    
    NSDate *endDate = [cal dateByAddingComponents:comp toDate:checkinNSDate options:0];
    
    //set the flags just same as startDay, or we cannot get correct computation result
    NSUInteger flg = NSCalendarCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit;
    
    NSDateComponents *endDay = [cal components:flg fromDate:endDate];
    
    DSLCalendarRange *newRange = [[DSLCalendarRange alloc] initWithStartDay:[cal components:flg fromDate:checkinNSDate] endDay:endDay];
    
    [_calendar setSelectedRange:newRange];
    [self setCheckDates:newRange.startDay checkout:newRange.endDay];
}

- (void)calendarView:(DSLCalendarView*)calendarView didSelectRange:(DSLCalendarRange*)range{
    NSCalendar *gregorian = [range.startDay calendar];
    NSUInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit;

#if 1
    NSLog(@"range selected: %@ to %@", range.startDay.date, range.endDay.date);
#endif
    
    //TODO: Check if the checkin/out dates are before today or not
    //      If yes, move to today
    NSDateComponents *components;
    
    components = [gregorian components:unitFlags
                              fromDate:[NSDate date]
                                toDate:range.startDay.date options:0];
    if([components day] < 0) //checkin date is before today, not reservable
    {
        NSDate *startDate = [NSDate date]; //change check-in date to today
        NSDate *endDate = range.endDay.date;
        
        components = [gregorian components:unitFlags
                                  fromDate:startDate
                                    toDate:endDate options:0];
        if([components day] < 0) //checkout date is also before today
        {
            NSDateComponents *comp = [[NSDateComponents alloc]init];
            comp.day = 1;
            endDate = [gregorian dateByAddingComponents:comp toDate:startDate options:0];
        }
        NSUInteger flg = NSCalendarCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit;
        
        NSDateComponents *startDay = [gregorian components:flg fromDate:startDate];
        NSDateComponents *endDay = [gregorian components:flg fromDate:endDate];
        
        DSLCalendarRange *newRange = [[DSLCalendarRange alloc] initWithStartDay:startDay endDay:endDay];
        
        double delayInSeconds = 0.3; //delay 0.3 sec
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            //code to be executed on the main queue after a delay
            [calendarView setSelectedRange:newRange];
            [self setCheckDates:newRange.startDay checkout:newRange.endDay];
        });
        return;
    }
    
    components = [gregorian components:unitFlags fromDate:range.startDay.date
                                toDate:range.endDay.date options:0];
    if([components day] > MAX_NIGHTS)
    {
        NSLog(@"diff: %ld", (long)[components day]);
        NSDateComponents *comp = [[NSDateComponents alloc]init];
        comp.day = MAX_NIGHTS;
        NSDate *endDate = [gregorian dateByAddingComponents:comp toDate:range.startDay.date options:0];
        
        //set the flags just same as startDay, or we cannot get correct computation result
        NSUInteger flg = NSCalendarCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit;
        
        NSDateComponents *endDay = [gregorian components:flg fromDate:endDate];
        
        DSLCalendarRange *newRange = [[DSLCalendarRange alloc] initWithStartDay:range.startDay endDay:endDay];
                                  
        double delayInSeconds = 0.3; //delay 0.3 sec
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            //code to be executed on the main queue after a delay
            [calendarView setSelectedRange:newRange];
            [self setCheckDates:newRange.startDay checkout:newRange.endDay];
        });
    }
    else if([components day] == 0) //only one day selected, check-in == check-out
    {
        NSDateComponents *comp = [[NSDateComponents alloc]init];
        comp.day = 1;
        NSDate *endDate = [gregorian dateByAddingComponents:comp toDate:range.startDay.date options:0];
        
        //set the flags just same as startDay, or we cannot get correct computation result
        NSUInteger flg = NSCalendarCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit;
        
        NSDateComponents *endDay = [gregorian components:flg fromDate:endDate];
        
        DSLCalendarRange *newRange = [[DSLCalendarRange alloc] initWithStartDay:range.startDay endDay:endDay];
        
        double delayInSeconds = 0.3; //delay 0.3 sec
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            //code to be executed on the main queue after a delay
            [calendarView setSelectedRange:newRange];
            [self setCheckDates:newRange.startDay checkout:newRange.endDay];
        });
    }
    else
    {
        [self setCheckDates:range.startDay checkout:range.endDay];
    }
}

- (void)setCheckDates:(NSDateComponents*)checkin checkout:(NSDateComponents*)checkout
{
    NSString *format = @"%d/%02d/%02d(%@)";

    NSString *checkinDate = [NSString stringWithFormat:format, [checkin year], [checkin month], [checkin day],[self getLocalizedWeekday:[checkin weekday]]];
    NSString *checkoutDate = [NSString stringWithFormat:format, [checkout year], [checkout month], [checkout day], [self getLocalizedWeekday:[checkout weekday]]];
    
    _CheckinDate.text = checkinDate;
    _CheckoutDate.text = checkoutDate;
    
    NSCalendar *gregorian = [checkin calendar];
    NSUInteger unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit | NSDayCalendarUnit;
    
    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:checkin.date
                                                  toDate:checkout.date options:0];
    checkinNSDate = checkin.date;
    checkoutNSDate = checkout.date;
    
    DSLCalendarRange *newRange = [[DSLCalendarRange alloc] initWithStartDay:checkin endDay:checkout];
    [_calendar setSelectedRange:newRange];
    
    _days.text = [NSString stringWithFormat:@"%ld", (long)[components day]];
    days = (NSUInteger)[components day];
    
    if(days == MAX_NIGHTS)
    {
        _plusButton.enabled = NO;
        [_plusButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _minusButton.enabled = YES;
        [_minusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else if(days == 1)
    {
        _plusButton.enabled = YES;
        [_plusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _minusButton.enabled = NO;
        [_minusButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    else
    {
        _plusButton.enabled = YES;
        [_plusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _minusButton.enabled = YES;
        [_minusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

-(NSString*)getLocalizedWeekday:(NSInteger)weekday
{
    NSLog(@"weekday %ld:%@",(long)weekday, dayNames[@(weekday-1)]);
    return dayNames[@(weekday-1)];
}
@end
