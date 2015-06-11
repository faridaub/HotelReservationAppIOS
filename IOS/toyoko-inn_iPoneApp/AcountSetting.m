//
//  AcountSetting.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/06/04.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "AcountSetting.h"
#import "AppDelegate.h"

@interface AcountSetting ()

@end

@implementation AcountSetting

NSArray *buttons;

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
    
    buttons = [[NSArray alloc]initWithObjects:_ConfirmButton, _HistoryButton, _FavoriteButton, _ViewHistoryButton, _InfoModifyButton, _SettingButton, nil];
    
    for(UIButton *b in buttons)
    {
        [b.imageView setContentMode: UIViewContentModeScaleAspectFit ];
        [b.layer setBorderWidth:0.5];
        [b.layer setBorderColor:[[UIColor blackColor]CGColor]];
    }

    self.delegate = self; //To get calls to callback methods
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    if([ud stringForKey:FAMILY_NAME] && [ud stringForKey:GIVEN_NAME]) //both names exist
    {
        _NameLabel.text = [NSString stringWithFormat:@"%@ %@様", [ud stringForKey:FAMILY_NAME], [ud stringForKey:GIVEN_NAME]];
    }
    if([ud stringForKey:MEMBER_NUM])
    {
        NSDictionary *dict=@{MEMBER_NUM:[ud stringForKey:MEMBER_NUM]};
        
        [self addRequestFields:dict];
        [self setApiName:@"search_point_api"];
        [self setSecure:NO];
        
        [self sendRequest];
    }
    
    if([ud stringForKey:PERSON_UID] == nil)
    {
        _LoginOutButton.title = @"ログイン";
        
        for(UIButton *b in buttons)
        {
            b.enabled = NO;
        }
    }
    else
    {
        _LoginOutButton.title = @"ログアウト";
        
        for(UIButton *b in buttons)
        {
            b.enabled = YES;
        }
    }
    
    //personal setting route, erase the reservation settings
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if(appDelegate.reservData != nil)
    {
        appDelegate.reservData = nil;
        //appDelegate.reservData = [[NSMutableDictionary alloc]init];
        //[appDelegate.reservData removeAllObjects];
    }
#if 1
    NSArray *buttons = @[_ConfirmButton, _HistoryButton, _FavoriteButton, _ViewHistoryButton, _InfoModifyButton, _SettingButton];
    for(UIButton *btn in buttons)
    {
        btn.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        btn.imageView.contentMode = UIViewContentModeCenter;
    }
#endif
}

-(void)ParsedDataReady:(NSDictionary*)data
{
    if([data[@"errrCode"] isEqualToString:@"BCMN0000"])
    {
        if(data[@"nmbrPoints"])
            _NumPointsLabel.text = data[@"nmbrPoints"];
    }
    else
    {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"確認" message:data[@"errrMssg"]
                                  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"はい", nil];
        [alert show];
        return;
    }
}

-(void)connectionFailed:(NSError*)error
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    if([ud stringForKey:FAMILY_NAME] && [ud stringForKey:GIVEN_NAME]) //both names exist
    {
        _NameLabel.text = [NSString stringWithFormat:@"%@ %@様", [ud stringForKey:FAMILY_NAME], [ud stringForKey:GIVEN_NAME]];
    }
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
#if 0
    [self dismissViewControllerAnimated:YES completion:^{}];
#else
    //jump to the home view in one line
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
#endif
}

- (IBAction)LoginOutPressed:(id)sender {
    //To delete the keys
    //20150427: delete the distance key to reset the distance search range
    NSArray *keys=@[PERSON_UID, MEMBER_NUM, FAMILY_NAME, GIVEN_NAME, DISTANCE];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    for(NSString *key in keys)
    {
        if([ud stringForKey:key])
            [ud removeObjectForKey:key];
        
    }
    [ud synchronize]; //write back the data
    
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)ConfirmPressed:(id)sender {
    UIViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"ReservList"];
    [self presentViewController:next animated:YES completion:^ {
        
    }];
}

- (IBAction)HistoryPressed:(id)sender {
    UIViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"HistoryList"];
    [self presentViewController:next animated:YES completion:^ {
        
    }];
    
}

- (IBAction)FavoritePressed:(id)sender {
    UIViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"FavoriteList"];
    [self presentViewController:next animated:YES completion:^ {
        
    }];
}

- (IBAction)ViewHistPressed:(id)sender {
    UIViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewHistoryList"];
    [self presentViewController:next animated:YES completion:^ {
        
    }];
}

- (IBAction)InfoModifyPressed:(id)sender {
    UIViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"infoChange"];
    [self presentViewController:next animated:YES completion:^ {
        
    }];
}

- (IBAction)SettingPressed:(id)sender {
    UIViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"AppSetting"];
    [self presentViewController:next animated:YES completion:^ {
        
    }];
    
}
@end
