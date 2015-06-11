//
//  SearchEntry.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/06/16.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "SearchEntry.h"
#import "AcountSetting.h"
#import "HotelListView.h"
#import "Constant.h"
#import "AppDelegate.h"
#import "ConstraintInput.h"
#import "UIButton+BGColor.h"
#import "initialSetting.h"

@interface SearchEntry ()

@end

@implementation SearchEntry

static NSArray *buttons;
static UIButton *selectedConstraint;
static UIButton *selectedRoomType;

static NSArray *ConstraintGroup;
static NSArray *RoomTypeGroup;

CLLocationManager *locationManager;
double currLatt;
double currLngtd;

//Added for saving the search keyword, because of the changing from searchbar to uilabel
static NSString *searchKeyword;
static NSDictionary *searchArea;

static BOOL isLoadingSetting;

#define DEFAULT_LATT 0.0/*35.559511*/
#define DEFAULT_LNGTD 0.0/*139.712301*/
#define DEFAULT_DIST 5.0

#define BG_IMGV_TAG 100

#define BOLD_BORDER_WIDTH 1.5f

static NSString const *maskName = @"foregroundMask";

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
    
    buttons = [[NSArray alloc]initWithObjects:_CurrentPlaceButton, _DestButton,_FavoriteButton, _HotelSearchButton, _ConstraintButton, _OnePxOneRoomButton, _TwoPxOneRoomButtom, _OnePxTwoRoomButton, nil];
    
    ConstraintGroup = [[NSArray alloc]initWithObjects:_CurrentPlaceButton, _DestButton, _FavoriteButton, nil];
    RoomTypeGroup = [[NSArray alloc]initWithObjects:_OnePxOneRoomButton, _TwoPxOneRoomButtom, _OnePxTwoRoomButton, nil];
    
    for(UIButton *b in buttons)
    {
        [b.imageView setContentMode: UIViewContentModeScaleAspectFit ];
        [b.layer setBorderWidth:0.5];
        [b.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    }
    for(UIButton *b in RoomTypeGroup)
    {
        b.layer.borderWidth = BOLD_BORDER_WIDTH;
    }
#if 1
    _bgLabel2.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _bgLabel2.layer.borderWidth = BOLD_BORDER_WIDTH;
#endif
    
    [self AddImageToButton:_CurrentPlaceButton image:[UIImage imageNamed:@"現在地周辺検索"]];
    [self AddImageToButton:_DestButton image:[UIImage imageNamed:@"目的地入力アイコン"]];
    [self AddImageToButton:_FavoriteButton image:[UIImage imageNamed:@"お気に入りホテルアイコン"]];
    
#if 1
    NSArray *groupButtons = @[_CurrentPlaceButton, _DestButton,_FavoriteButton, _OnePxOneRoomButton, _TwoPxOneRoomButtom, _OnePxTwoRoomButton];
    
    for(UIButton *btn in groupButtons)
    {
        //add code to change background color
        CALayer *layer = [CALayer layer];
        layer.frame = btn.bounds;
        layer.backgroundColor = [UIColor blackColor].CGColor/*[Constant AppLightGrayColor].CGColor*/;
        layer.name = [maskName copy];
        layer.opacity = 0.0f;
        [btn.layer addSublayer:layer];
    }
#endif
    //[_DestSearchBar.layer setBorderWidth:0.0];
//    [_DestSearchBar.layer setBorderColor:[[UIColor blackColor]CGColor]];
#if 0
    UITextField *txfSearchField = [_DestSearchBar valueForKey:@"_searchField"];
    [txfSearchField.layer setBorderWidth:0.5];
    [txfSearchField.layer setBorderColor:[[UIColor blackColor]CGColor]];
#endif
    
    
    //To set the bg image of navigation bar
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo2.png"]];
    imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    UIBarButtonItem *logoItem = [[UIBarButtonItem alloc] initWithCustomView:imageView];
    _Navibar.topItem.leftBarButtonItem = logoItem;
    
#if 0
    UIBarButtonItem *msgButton = [[UIBarButtonItem alloc] initWithTitle:@"0" style:UIBarButtonItemStylePlain target:self action:@selector(MessagePressed:)];
    [msgButton setBackButtonBackgroundImage:[UIImage imageNamed:@"メッセージアイコン.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
#else
    UIImage *background = [UIImage imageNamed:@"buttonbg.png"/*@"メッセージアイコン.png"*/];
    UIImage *foreground = [UIImage imageNamed:@"メッセージアイコン.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(MessagePressed:) forControlEvents:UIControlEventTouchUpInside]; //adding action

    [button setBackgroundImage:background forState:UIControlStateNormal];
    [button setBackgroundImage:background forState:UIControlStateSelected];
    [button setImage:foreground forState:UIControlStateNormal];
    [button setImage:foreground forState:UIControlStateSelected];
    button.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    button.imageView.contentMode = UIViewContentModeCenter;
    button.frame = /*CGRectMake(0 ,0,22,19);*/CGRectMake(0 ,0,44,38);

    //Adjust the font size to fit the original design
    UIFont *font = [UIFont systemFontOfSize:15.0];
    NSAttributedString *number = [[NSAttributedString alloc] initWithString:@"0" attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor redColor]}];

    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
#if 0
    [button setTitle:@"0" forState:UIControlStateNormal];
#else
    [button setAttributedTitle:number forState:UIControlStateNormal];
#endif
    button.titleEdgeInsets = UIEdgeInsetsMake(-2.0, -42.0, 0.0, 0.0);
    UIBarButtonItem *msgButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    //menu button
    UIButton *menu = [UIButton buttonWithType:UIButtonTypeCustom];
    [menu addTarget:self action:@selector(MenuPressed:) forControlEvents:UIControlEventTouchUpInside]; //adding action
    [menu setBackgroundImage:background forState:UIControlStateNormal];
    [menu setBackgroundImage:background forState:UIControlStateSelected];
    UIImage *menuIcon = [UIImage imageNamed:@"メニューアイコン"];
    menu.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    menu.imageView.contentMode = UIViewContentModeCenter;
    menu.frame = /*CGRectMake(0 ,0,22,19);*/CGRectMake(0 ,0,44,38);
    
    [menu setImage:menuIcon forState:UIControlStateNormal];
    [menu setImage:menuIcon forState:UIControlStateSelected];
    [_MenuButton setCustomView:menu];
#endif
    
    NSArray *baritems = @[_Navibar.topItem.rightBarButtonItem, msgButton];
    _Navibar.topItem.rightBarButtonItems = baritems;
    
    //make the 2 buttons' corner round
    NSArray *roundButtons = @[_HotelSearchButton, _ConstraintButton];
    for(UIButton *btn in roundButtons)
    {
        btn.clipsToBounds = YES;
        btn.layer.cornerRadius = 10;
    }
    
    //setup the destination label with rounded corner
    _DestLabel.clipsToBounds = YES;
    _DestLabel.layer.cornerRadius = 10.0f;
    _DestLabel.layer.borderWidth = 0.5f;
    _DestLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    
    //_Navibar.topItem.titleView = imageView;
    //[_Navibar setBackgroundImage:[UIImage imageNamed:@"logo"] forBarMetrics:UIBarMetricsDefault];
    
    //To handle the hotel search button
#if 0
    _HotelSearchButton.enabled = NO; //disabled by default
#else
    _HotelSearchButton.enabled = YES; //enabled initially
#endif
    //add code for GPS
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    currLatt = 0.0f;
    currLngtd = 0.0f;
    
    //adjust the background label
    [_BGLabel.layer setBorderColor:[UIColor blackColor].CGColor];
    [_BGLabel.layer setBorderWidth:0.5f];
    
    NSArray *resizeButtons = @[_HotelSearchButton, _ConstraintButton, _CurrentPlaceButton, _DestButton, _FavoriteButton];
#if 1
    for(UIButton *btn in resizeButtons)
    {
        btn.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        btn.imageView.contentMode = UIViewContentModeCenter;
    }
#endif
    
    //20150126 -- check autologin setting
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if([ud stringForKey:AUTO_LOGIN]) //auto login exist
    {
        NSString *autologin = [ud stringForKey:AUTO_LOGIN];
        if([autologin isEqualToString:@"N"]) //not auto login
        {
            NSArray *keys=@[PERSON_UID, MEMBER_NUM, FAMILY_NAME, GIVEN_NAME, DISTANCE];
            for(NSString *key in keys)
            {
                if([ud stringForKey:key])
                    [ud removeObjectForKey:key];
            }
            [ud synchronize];
        }
    }
    
    //20150203 added
    searchKeyword = @"";
    
    //NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if([ud boolForKey:INITIALIZED] == NO &&
       [ud stringForKey:PERSON_UID] == nil)
    {
        double delayInSeconds = 0.1f; //delay 0.1 sec
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            initialSetting *next = [self.storyboard instantiateViewControllerWithIdentifier:@"initialSetting"];
            [self presentViewController:next animated:YES completion:^ {}];
             });
    }
    
    //20150422: reset the last view flag
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.lastVC = nil;
}

#if 0
- (void)viewDidAppear:(BOOL)animated
{
#if 1
    [super viewDidAppear:animated];
    
    //set the bar button availability every time
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if([ud stringForKey:PERSON_UID] == nil)
    {
#if 0
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"確認" message:@"今ログインしますか？"
                                  delegate:self cancelButtonTitle:@"あとで" otherButtonTitles:@"はい", nil];
        [alert show];

        _Navibar.topItem.rightBarButtonItem.enabled = NO;
#endif
    }
    else
    {
        _Navibar.topItem.rightBarButtonItem.enabled = YES;
    }
#else
    
#endif
}
#endif

- (void)viewWillAppear:(BOOL)animated
{
    if(selectedConstraint == _CurrentPlaceButton) //destination is changeable
    {
        locationManager.delegate = self;
        [locationManager startUpdatingLocation];
    }
#if 1
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if([ud stringForKey:PERSON_UID] != nil
       && [ud stringForKey:DISTANCE] == nil) //distance not set
    {
        //preload distance
        self.delegate = self;
        NSDictionary *dict=@{PERSON_UID:[ud stringForKey:PERSON_UID]};
        [self addRequestFields:dict];
        [self setApiName:@"search_customer_setting_api"];
        [self setSecure:NO];
        
        isLoadingSetting = YES;
        
        [self sendRequest];
    }
#endif
}

- (void)viewWillDisappear:(BOOL)animated
{
    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"button %li pressed", (long)buttonIndex);
    
    //Yes pressed
    if(buttonIndex == 1)
    {
        UIViewController *next=[self.storyboard instantiateViewControllerWithIdentifier:@"loginChoices2"/*@"loginView"*/];
        [self presentViewController:next animated:YES completion:^ {
            
        }];
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

- (void)HandleRadioGroup:(UIButton*)selected group:(NSArray *)group bgOnly:(bool)bgOnly
{
    for(UIButton *b in group)
    {
        if(b == selected)
        {
            if(!bgOnly)
                [b setImage: [UIImage imageNamed:@"ラジオオン"] forState:UIControlStateNormal ];
#if 0
            if(group == ConstraintGroup)
                [b setBackgroundColor:[Constant AppLightGrayColor]/*[UIColor lightGrayColor]*/];
#endif
#if 1
            for(CALayer *layer in b.layer.sublayers)
            {
                if([layer.name isEqualToString:(NSString*)maskName])
                {
                    layer.opacity = 0.11f;
                }
            }
#endif
        }
        else
        {
            if(!bgOnly)
                [b setImage: [UIImage imageNamed:@"ラジオオフ"] forState:UIControlStateNormal ];
#if 0
            if(group == ConstraintGroup)
                [b setBackgroundColor:[UIColor whiteColor]];
#endif
#if 1
            for(CALayer *layer in b.layer.sublayers)
            {
                if([layer.name isEqualToString:(NSString*)maskName])
                {
                    layer.opacity = 0.0f;
                }
            }
#endif
        }
    }
}

- (IBAction)MessagePressed:(id)sender
{
    UIViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"MessageList"];
    [self presentViewController:next animated:YES completion:^ {
        
    }];
}
                                  
- (IBAction)MenuPressed:(id)sender {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if([ud stringForKey:PERSON_UID])
    {
        UIViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountSetting"];
        [self presentViewController:next animated:YES completion:^ {
            
        }];
    }
    else
    {
        UIViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"loginChoices2"];
        [self presentViewController:next animated:YES completion:^ {
            
        }];
    }
}


- (void)AddImageToButton:(UIButton*)button image:(UIImage*)img
{
    UIImageView *imgv = [[UIImageView alloc]initWithImage:img];
#if 1
    imgv.tag = BG_IMGV_TAG;
#endif
    int offset = (button.frame.size.height - img.size.height/2)/2;
    
    [imgv setContentMode: UIViewContentModeScaleAspectFit ];
    [imgv setFrame:CGRectMake(button.frame.size.width-offset-(img.size.width/2),
                              offset,
                              img.size.width/2,
                              img.size.height/2)];
#if 1 //make the corners round
    imgv.clipsToBounds = YES;
    imgv.layer.cornerRadius = 3.0f;
#endif
    [button addSubview:imgv];
}

- (IBAction)ConstraintPressed:(id)sender {
    selectedConstraint = (UIButton*)sender;
    [self HandleRadioGroup:selectedConstraint group:ConstraintGroup bgOnly:NO];
    
    //fix the issue that search bar is covered by other view
    if(selectedConstraint == _DestButton)
    {
        [self.view bringSubviewToFront:_DestLabel];
        DestSearch *next = [self.storyboard instantiateViewControllerWithIdentifier:@"DestSearch"];
        next.searchDelegate = self;
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [self FillSearchItems:dict];
        next.searchDict = dict;
        next.hideNumber = NO;
        [self presentViewController:next animated:YES completion:^ {}];
    }
#if 0
    //handle hotel search button
    if(selectedRoomType != nil)
        _HotelSearchButton.enabled = YES;
    else
        _HotelSearchButton.enabled = NO;
#endif
#if 0
    //hide the keyboard if other option is chosen.
    if(sender != _DestButton)
        [_DestSearchBar resignFirstResponder];
#endif
    if(selectedConstraint == _CurrentPlaceButton)
    {
        locationManager.delegate = self;
        //add code for iOS 8 new requirement
        if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
        {
            [locationManager requestAlwaysAuthorization];
        }
        else
        {
            [locationManager startUpdatingLocation];
        }
    }
    else
    {
        [locationManager stopUpdatingLocation];
        locationManager.delegate = nil;
    }
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    selectedConstraint = _DestButton;
    [self HandleRadioGroup:selectedConstraint group:ConstraintGroup bgOnly:NO];
#if 1
    DestSearch *next = [self.storyboard instantiateViewControllerWithIdentifier:@"DestSearch"];
    next.searchDelegate = self;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [self FillSearchItems:dict];
    next.searchDict = dict;
    next.hideNumber = NO;
    [self presentViewController:next animated:YES completion:^ {}];
#endif
}

#if 0
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchBar resignFirstResponder];
}
#endif

- (IBAction)ConstraintButtonPressed:(id)sender {
    //TODO: to pass parameters and show the contraint view
    ConstraintInput *next = [self.storyboard instantiateViewControllerWithIdentifier:@"ConstraintInput"];
    next.dispItems = @[@"Dest", @"Date", @"Rooms", @"People",@"Smoking"];
    
    [self presentViewController:next animated:YES completion:^ {}];
}

- (IBAction)RoomTypePressed:(id)sender {
    selectedRoomType = (UIButton*)sender;
    [self HandleRadioGroup:selectedRoomType group:RoomTypeGroup bgOnly:YES];
#if 0
    if(selectedConstraint != nil)
        _HotelSearchButton.enabled = YES;
    else
        _HotelSearchButton.enabled = NO;
#endif
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;
    [self handleSearch:searchBar];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    //[self handleSearch:searchBar];
    [searchBar resignFirstResponder];
}

-(void)SetKeyword:(NSString*)keyword
{
    _DestLabel.text = keyword;
    searchKeyword = keyword;
    searchArea = nil;
}

-(void)SetArea:(NSDictionary*)area
{
    searchKeyword = @"";
    searchArea = area;
    _DestLabel.text = area[STATE_NAME];
}

- (void)FillSearchItems:(NSMutableDictionary*)dict
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if([ud stringForKey:MEMBER_NUM])
        dict[MEMBER_FLAG] = @"Y";
    else
        dict[MEMBER_FLAG] = @"N";
    
    NSDateFormatter *dateformat=[[NSDateFormatter alloc]init];
    [dateformat setDateFormat:@"yyyyMMdd"];
    NSString *date_String=[dateformat stringFromDate:[NSDate date]];
    
    dict[CHECKIN_DATE] = date_String/*@"20140901"*/; //to be replaced by today's date
    dict[NUM_NIGHTS] = @"1"; //default value
    
    if(selectedRoomType == _OnePxOneRoomButton || selectedRoomType == _OnePxTwoRoomButton)
        dict[NUM_PEOPLE] = @"1"; //only one person, 2 rooms 2 people
    else
        dict[NUM_PEOPLE] = @"2"; //one room 2 people
    
    if (selectedRoomType == _OnePxOneRoomButton || selectedRoomType == _TwoPxOneRoomButtom)     dict[NUM_ROOMS] = @"1"; //one room for 1 person or 2 people
    else
        dict[NUM_ROOMS] = @"2";
}

- (void)locationManager:(CLLocationManager *)manager
didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusAuthorizedAlways ||
        status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        //For iOS 8
        if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
        {
            [locationManager startUpdatingLocation];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currLocation = locations.lastObject;
    
    currLngtd = currLocation.coordinate.longitude;
    currLatt = currLocation.coordinate.latitude;
    NSLog(@"curr loc= %f, %f", currLatt, currLngtd);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //[locationManager stopUpdatingLocation];
    //locationManager.delegate = nil;
    currLatt = 0.0;
    currLngtd = 0.0;
    
    NSLog(@"gps error: %@", error);
    
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:@"確認" message:@"現在地情報が取得できません。"
                              delegate:nil cancelButtonTitle:nil otherButtonTitles:@"はい", nil];
    [alert show];
}

- (void)handleSearch:(UISearchBar *)searchBar{
    //TODO: add code to handle search
    [searchBar resignFirstResponder]; // if you want the keyboard to go away
    
    if(selectedRoomType == nil) //room type not selected
    {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"確認" message:@"人数と部屋タイプをお選びください。"
                                  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"はい", nil];
        [alert show];
        return;
    }
    
    self.delegate = self;
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    
    [self FillSearchItems:dict];
    
    dict[KEYWORD] = searchBar.text;
    
    [self addRequestFields:dict];
    [self setApiName:@"search_hotel_keyword_api"];
    [self setSecure:NO];
    
    [self sendRequest];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if(appDelegate.reservData == nil)
    {
        appDelegate.reservData = [[NSMutableDictionary alloc]init];
        [appDelegate.reservData addEntriesFromDictionary: dict];
    }
    else
    {
        [appDelegate.reservData removeAllObjects];
        [appDelegate.reservData addEntriesFromDictionary:dict];
    }
}

- (IBAction)SearchPressed:(id)sender
{
    //code added for UI flow modification
    if(selectedRoomType == nil && selectedConstraint == nil)
    {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"確認" message:@"「行き先」と「人数・室数」をお選びください。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"はい", nil];
        [alert show];
        return;
    }
    
    if(selectedConstraint == nil)
    {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"確認" message:@"「行き先」をお選びください。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"はい", nil];
        [alert show];
        return;
    }
    
    if(selectedRoomType == nil)
    {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"確認" message:@"「人数・室数」をお選びください。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"はい", nil];
        [alert show];
        return;
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict removeAllObjects];
    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;
    
    [self FillSearchItems:dict];
    
    if(selectedConstraint == _DestButton)
    {
        if(searchKeyword.length == 0 && searchArea == nil) //keyword not set
        {
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle:@"確認" message:@"目的地を入力してください。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"はい", nil];
            [alert show];
            return;
        }
        //[self handleSearch:_DestSearchBar];
        //new code: to search by keyword
        if(searchArea == nil)
        {
            dict[KEYWORD] = searchKeyword;
            dict[@"mode"] = @"1";
        }
        else //search by area
        {
            dict[@"mode"] = @"2";
            dict[COUNTRY_CODE] = searchArea[COUNTRY_CODE];
            dict[AREA_CODE] = searchArea[AREA_CODE];
            dict[STATE_CODE] = searchArea[STATE_CODE];
        }
        
        self.delegate = self;
        
        [self addRequestFields:dict];
        [self setApiName:@"search_hotel_vacant_api"];
        [self setSecure:NO];
        
        [self sendRequest];
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        if(appDelegate.reservData == nil)
        {
            appDelegate.reservData = [[NSMutableDictionary alloc]init];
            [appDelegate.reservData addEntriesFromDictionary: dict];
        }
        else
        {
            [appDelegate.reservData removeAllObjects];
            [appDelegate.reservData addEntriesFromDictionary:dict];
        }
    }
    else
    {
        if(selectedConstraint == _FavoriteButton)
        {
            //[self FillSearchItems:dict];
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            if(appDelegate.reservData == nil)
            {
                appDelegate.reservData = [[NSMutableDictionary alloc]init];
                [appDelegate.reservData addEntriesFromDictionary: dict];
            }
            else
            {
                [appDelegate.reservData removeAllObjects];
                [appDelegate.reservData addEntriesFromDictionary:dict];
            }
            
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            if(![ud stringForKey:PERSON_UID])
            {
                UIAlertView *alert =
                [[UIAlertView alloc] initWithTitle:@"確認" message:@"お気に入りの検索にはログインが必要です。ログインしてからもう一度お試しください。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"はい", nil];
                [alert show];
                return;
            }
            
            //TODO: search by favorite hotel list
            UIViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"FavoriteList"];
            [self presentViewController:next animated:YES completion:^ {
                
            }];
        }
        else
        {
#if 1
            if(currLngtd == 0.0f && currLatt == 0.0f)
            {
                UIAlertView *alert =
                [[UIAlertView alloc] initWithTitle:@"確認" message:@"現在地情報が取得できません。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"はい", nil];
                [alert show];
                return;
            }
#endif
            dict[LATITUDE] = [NSString stringWithFormat:@"%f", currLatt];
            dict[LONGITUDE] = [NSString stringWithFormat:@"%f", currLngtd];
            
            dict[@"mode"] = @"3";
#if 0
            dict[DISTANCE] = [NSString stringWithFormat:@"%f", DEFAULT_DIST];
#else
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            if([ud stringForKey:DISTANCE])
                dict[DISTANCE] = [ud stringForKey:DISTANCE];
            else
                dict[DISTANCE] = [NSString stringWithFormat:@"%f", DEFAULT_DIST];
#endif
            self.delegate = self;
            
            [self addRequestFields:dict];
            [self setApiName:@"search_hotel_vacant_api"];
            [self setSecure:NO];
            
            [self sendRequest];
            
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            if(appDelegate.reservData == nil)
            {
                appDelegate.reservData = [[NSMutableDictionary alloc]init];
                [appDelegate.reservData addEntriesFromDictionary: dict];
            }
            else
            {
                [appDelegate.reservData removeAllObjects];
                [appDelegate.reservData addEntriesFromDictionary:dict];
            }
        }
    }
}

-(void)ParsedDataReady:(NSDictionary*)data
{
    NSLog(@"data: %@",data);
    
    if(isLoadingSetting)
    {
        isLoadingSetting = NO;
        if([data[@"errrCode"] isEqualToString:@"BCMN0000"])
        {
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:data[DISTANCE] forKey:DISTANCE];
            [ud synchronize];
        }
        return;
    }
    
    if([data[@"errrCode"] isEqualToString:@"BCMN0000"]) //success
    {
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        [self FillSearchItems:dict];
        
        if(selectedConstraint == _DestButton)
        {
#if 0
            DestSearch *next = [self.storyboard instantiateViewControllerWithIdentifier:@"DestSearch"];
            NSDictionary *destResult = data[@"keyword_info"];
            next.DestResult = [destResult mutableCopy];
            next.searchKeyword = _DestSearchBar.text;
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [self FillSearchItems:dict];
            next.searchDict = dict;
            next.hideNumber = NO;
            
            [self presentViewController:next animated:YES completion:^ {}];
#else
            NSArray *hotelList = data[@"htlList"];
            HotelListView *next = [self.storyboard instantiateViewControllerWithIdentifier:@"HotelList"];
            next.inputArray = hotelList;
            next.title = [NSString stringWithFormat:@"%@~%@泊 %@名%@室\nキーワード:%@ %lu軒",
                          [Constant convertToLocalDate:dict[CHECKIN_DATE]],
                          dict[NUM_NIGHTS], dict[NUM_PEOPLE], dict[NUM_ROOMS], _DestLabel.text, (unsigned long)[hotelList count]];
            next.keyword = _DestLabel.text;
            next.searchDict = dict;
            
            next.lngtd = 0.0f;
            next.lttd = 0.0f;
            
            [self presentViewController:next animated:YES completion:^ {}];
#endif
        }
        else if(selectedConstraint == _CurrentPlaceButton)
        {
            NSArray *hotelList = data[@"htlList"];
            HotelListView *next = [self.storyboard instantiateViewControllerWithIdentifier:@"HotelList"];
            next.inputArray = hotelList;
            next.title = [NSString stringWithFormat:@"%@~%@泊 %@名%@室\n現在地周辺 %lu軒",
                          [Constant convertToLocalDate:dict[CHECKIN_DATE]],
                          dict[NUM_NIGHTS], dict[NUM_PEOPLE], dict[NUM_ROOMS],
                          (unsigned long)[hotelList count]];
            next.lngtd = currLngtd;
            next.lttd = currLatt;
            next.searchDict = dict;
            
            [self presentViewController:next animated:YES completion:^ {}];
        }
    }
    else if([data[@"errrCode"] isEqualToString:@"BAPI1004"])
    {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"確認" message:@"該当するホテルがありません。条件を変更して再度お試しください。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"はい", nil];
        [alert show];
    }
    else if([data[@"errrCode"] isEqualToString:@"BAPI1007"])
    {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"確認" message:@"検索対象ホテルは全部満室です。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"はい", nil];
        [alert show];
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



@end
