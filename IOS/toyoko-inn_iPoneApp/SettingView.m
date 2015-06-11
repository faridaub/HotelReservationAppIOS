//
//  SettingView.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/06/04.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "SettingView.h"


@interface SettingView ()

@end

@implementation SettingView

static NSDictionary *kwMapping;
static NSString *distanceFormat;
static float distance;
static BOOL isFirstTime;

#define DEFAULT_DISTANCE 5.0f

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
    
    distanceFormat = [_DistanceButton.titleLabel.text copy];
    //TODO: to get distance from distance dialog or setting
    distance = DEFAULT_DISTANCE;
    
    kwMapping = @{@"newsPushFlag":_OfficialRemindSwitch, @"myFvrtsPushFlag":_FavoriteRemindSwitch, @"nrstHtlsPushFlag":_ClosestRemindSwitch};
    
    isFirstTime = NO;
    
    self.delegate = self; //To get calls to callback methods
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSArray *labels = @[_ToyokoPush, _FavoritePush, _NearestPush, _DistanceButton];
    
    for(UIView *label in labels)
    {
        label.layer.borderWidth = 0.5;
        label.layer.borderColor = [UIColor blackColor].CGColor;
    }

    //add indent for text space
    NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentJustified;
    style.firstLineHeadIndent = 10.0f;
    style.headIndent = 10.0f;
    style.tailIndent = -60.0f;
    style.lineBreakMode = NSLineBreakByCharWrapping;
    labels = @[_ToyokoPush, _FavoritePush, _NearestPush];
    
    for(UILabel *label in labels)
    {
        NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:label.text attributes:@{ NSParagraphStyleAttributeName : style}];
        label.attributedText = attrText;
    }
    
    
    if([ud stringForKey:PERSON_UID])
    {
        NSDictionary *dict=@{PERSON_UID:[ud stringForKey:PERSON_UID]};
        
        [self addRequestFields:dict];
        [self setApiName:@"search_customer_setting_api"];
        [self setSecure:NO];
        
        [self sendRequest];
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

- (IBAction)DistancePressed:(id)sender {
    //use distance dialog to get/set distance
    DistanceSetting *next = [self.storyboard instantiateViewControllerWithIdentifier:@"DistanceSetting"];
    next.SettingDelegate = self;
    next.initDist = distance;
    [self presentViewController:next animated:YES completion:^ {
        
    }];
}

-(void)SettingDone:(CGFloat)dist
{
    distance = dist;
    NSString *formattedStr = [NSString stringWithFormat:distanceFormat, distance];
    [_DistanceButton setTitle:formattedStr forState:UIControlStateNormal];
    [self SwitchChanged:_OfficialRemindSwitch]; //use switch changed to send data
}

-(void)ParsedDataReady:(NSDictionary*)data
{
    NSLog(@"data: %@", data);
    
    if([data[@"errrCode"] isEqualToString:@"BCMN0000"])
    {
        //To set the states of UISwitches
        for(NSString* key in [kwMapping allKeys])
        {
            if(data[key])
            {
                [self ConvertToSwitch:data[key] uiSwitch:kwMapping[key]];
            }
        }
        
        //To set the distance display
        if(data[DISTANCE])
        {
            NSString *formattedStr = [NSString stringWithFormat:distanceFormat, [data[DISTANCE] floatValue]];
            [_DistanceButton setTitle:formattedStr forState:UIControlStateNormal];
            distance = [data[DISTANCE] floatValue];
        }
    }
    else if([data[@"errrCode"] isEqualToString:@"HCMN0000"] ||
            [data[@"errrCode"] isEqualToString:@"BCMN1004"]) //no record, 1st time setting
    {
        isFirstTime = YES;
        NSString *formattedStr = [NSString stringWithFormat:distanceFormat, DEFAULT_DISTANCE];
        [_DistanceButton setTitle:formattedStr forState:UIControlStateNormal];
        distance = DEFAULT_DISTANCE;
        [self SwitchChanged:_OfficialRemindSwitch]; //use switch changed to send data
    }
    else
    {
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:@"確認" message:data[@"errrMssg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

-(void)connectionFailed:(NSError*)error
{
}

-(void)ConvertToSwitch:(NSString*)result uiSwitch:(UISwitch*)uiSwitch
{
    if([result isEqualToString:@"Y"])
        uiSwitch.on = YES;
    else
        uiSwitch.on = NO;
}

- (IBAction)SwitchChanged:(id)sender {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    for(NSString *str in [kwMapping allKeys])
    {
        UISwitch *sw = kwMapping[str];
        if(sw.on)
            dict[str] = @"Y";
        else
            dict[str] = @"N";
    }
    
    if(distance < 10.0f)
        dict[DISTANCE] = [NSString stringWithFormat:@"%1.2f", distance];
    else
        dict[DISTANCE] = @"10.0";
        
    self.delegate = self;
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    if([ud stringForKey:PERSON_UID])
    {
        dict[PERSON_UID] = [ud stringForKey:PERSON_UID];
        [ud setObject:dict[DISTANCE] forKey:DISTANCE];
        [ud synchronize];
        
        [self addRequestFields:dict];
        [self setApiName:@"change_customer_setting_api"];
        [self setSecure:NO];
        
        [self sendRequest];
    }
}
@end
