//
//  ConstraintInput.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/06/06.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "ConstraintInput.h"
#import "HotelListView.h"
#import "Constant.h"

#define ROW_HEIGHT 58.0
#define LABEL_WIDTH 16
#define LABEL_HEIGHT 21

@interface ConstraintInput ()

@end

@implementation ConstraintInput

static NSArray *items;
//static NSArray *dispItems;

static NSString *RoomTypeCode, *RoomTypeName, *Dest, *CheckinDate;
static float distance;
static int Nights;

static NSDictionary *searchArea;

NSMutableDictionary *dict; //dict for search

double currLatt;
double currLngtd;

CLLocationManager *locationManager;

#define DEFAULT_LATT 35.559511
#define DEFAULT_LNGTD 139.712301
#define DEFAULT_DIST 5.0

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
    //Initialize the item list
    items = [[NSArray alloc] initWithObjects:@"RoomType", @"Nights", @"Smoking", @"Distance", @"Dest", @"Date",  @"Rooms", @"People", nil];
    //dispItems = [[NSArray alloc] initWithObjects:@"RoomType", @"Distance", @"Dest", @"Date", @"Rooms", @"Nights", @"People",@"Smoking", nil];
    
    //Set the height of each row to display multi-line text
    self.tableView.rowHeight = ROW_HEIGHT;
#if 1
    _SearchButton.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [_SearchButton.imageView setContentMode: UIViewContentModeCenter ];
    _SearchButton.clipsToBounds = YES;
    _SearchButton.layer.cornerRadius = 10;
#endif
    //initialize the constraints
    NSDateFormatter *dateformat=[[NSDateFormatter alloc]init];
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [dateformat setDateFormat:@"yyyyMMdd"];
    [dateformat setCalendar:gregorianCalendar];
    CheckinDate =[dateformat stringFromDate:[NSDate date]]; //default date is today
    
    Nights = 1; //default is one night only
    distance = 5.0f; //default is 5.0 km
    Dest = @""; //default is empty -- around the current place
    searchArea = nil; //default is nil
    RoomTypeCode = @""; //default is empty -- not specified
    RoomTypeName = @"指定なし";
    
#if 1
    if(_dispItems.count*_tableView.rowHeight < _tableView.frame.size.height)
    {
        CGFloat diff = _SearchButton.frame.origin.y - _tableView.frame.origin.y - _tableView.frame.size.height;
        _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, _tableView.rowHeight*_dispItems.count);
        CGRect buttonFrame = _SearchButton.frame;
        buttonFrame.origin.y = _tableView.frame.origin.y + _tableView.frame.size.height + diff;
        _SearchButton.frame = buttonFrame;
    }
#endif
    
    //add code for GPS
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    currLatt = 0.0f;
    currLngtd = 0.0f;
}

- (void)viewWillAppear:(BOOL)animated
{
    if([_dispItems containsObject:@"Dest"] && Dest.length == 0) //destination is changeable and keyword is not set
    {
        locationManager.delegate = self;
        if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
        {
            [locationManager requestAlwaysAuthorization];
        }
        else
        {
            [locationManager startUpdatingLocation];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;
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

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return _dispItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    //To remove the subviews for recycled cells
    for (UIView *subview in [cell.contentView subviews]) {
        [subview removeFromSuperview];
    }
    
    //NSLog(@"cellForRowAtIndexPath called, row=%d", indexPath.row);
    [self FillCell:cell keyword:[_dispItems objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)FillSearchItems:(NSMutableDictionary*)dict
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if([ud stringForKey:MEMBER_NUM])
        dict[MEMBER_FLAG] = @"Y";
    else
        dict[MEMBER_FLAG] = @"N";
    
    //NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    //[dateformate setDateFormat:@"yyyyMMdd"];
    
    dict[CHECKIN_DATE] = CheckinDate;/*@"20140901"*/; //to be replaced by today's date
    dict[NUM_NIGHTS] = [NSString stringWithFormat:@"%d", Nights]; //default value
    
    //if(selectedRoomType == _OnePxOneRoomButton)
    //    dict[NUM_PEOPLE] = @"1"; //only one person
    //else
        dict[NUM_PEOPLE] = [NSString stringWithFormat:@"%d", (int)_PeopleStepper.value];
    
    //if (selectedRoomType == _OnePxOneRoomButton || selectedRoomType == _TwoPxOneRoomButtom)     dict[NUM_ROOMS] = @"1"; //one room for 1 person or 2 people
    //else
        dict[NUM_ROOMS] = [NSString stringWithFormat:@"%d", (int)_RoomsStepper.value];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //TODO: response with the type of cell
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *type = _dispItems[indexPath.row];
    
    if([type isEqualToString:@"RoomType"])
    {
        RoomTypeSetting *next = [self.storyboard instantiateViewControllerWithIdentifier:@"RoomType"];
        
        next.RoomDelegate = self;
        next.realTimeMode = NO;
        
        [self presentViewController:next animated:YES completion:^ {
            
        }];
    }
    else if([type isEqualToString:@"Distance"])
    {
        DistanceSetting *next = [self.storyboard instantiateViewControllerWithIdentifier:@"DistanceSetting"];
        next.SettingDelegate = self;
        next.initDist = distance;
        [self presentViewController:next animated:YES completion:^ {
            
        }];
    }
    else if([type isEqualToString:@"Date"])
    {
        DateSelectView *next = [self.storyboard instantiateViewControllerWithIdentifier:@"DateSelect"];
        next.DateDelegate = self;
        [self presentViewController:next animated:YES completion:^ {
            
        }];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        [dateFormat setDateFormat:@"yyyyMMdd"];
        [dateFormat setCalendar:gregorianCalendar];
        NSDate *convertedDate = [dateFormat dateFromString:CheckinDate];
        
        NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        
        NSDateComponents *comp = [[NSDateComponents alloc]init];
        comp.day = Nights;
        
        NSDate *endDate = [cal dateByAddingComponents:comp toDate:convertedDate options:0];
        
        unsigned unitFlags = NSCalendarCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit;
        
        [next setCheckDates:[cal components:unitFlags fromDate:convertedDate] checkout:[cal components:unitFlags fromDate:endDate]];
    }
    else if([type isEqualToString:@"Dest"])
    {
        DestSearch *next = [self.storyboard instantiateViewControllerWithIdentifier:@"DestSearch"];
        next.searchDelegate = self;
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [self FillSearchItems:dict];
        next.searchDict = dict;
        next.hideNumber = YES;
        [self presentViewController:next animated:YES completion:^ {}];
    }
}

-(void)SetKeyword:(NSString*)keyword
{
    Dest = keyword;
    searchArea = nil;
    NSLog(@"Dest: %@", Dest);
    //NSIndexPath *index;
    //index.row = (NSInteger)[dispItems indexOfObject:@"Dest"];
    [_tableView reloadData];
}

-(void)SetArea:(NSDictionary*)area
{
    Dest = @"";
    searchArea = area;
    //_DestLabel.text = area[STATE_NAME];
    [_tableView reloadData];
}

-(void)SetCheckin:(NSString*)checkinDate nights:(int)nights
{
    CheckinDate = checkinDate;
    Nights = nights;
    [_tableView reloadData];
}

-(void)SettingDone:(CGFloat)dist
{
    distance = dist;
    [_tableView reloadData];
}

-(void)SetRoomType:(NSString*)roomTypeCode roomTypeName:(NSString*)roomTypeName
{
    RoomTypeName = roomTypeName;
    RoomTypeCode = roomTypeCode;
    [_tableView reloadData];
}

-(void)AddFormattedStringToCell:(UITableViewCell*)cell str1:(NSString*)str1 str2:(NSString*)str2{
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.paragraphSpacing += 7.0f;
    
    UIFont *font = [UIFont fontWithName:@"HiraKakuProN-W6" size:15.0f];
    
    NSMutableAttributedString *s1=[[NSMutableAttributedString alloc] initWithString:str1 attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph}];
    
    paragraph.lineHeightMultiple = 1.2f;
    font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12.0f];
    NSAttributedString *s2=[[NSAttributedString alloc] initWithString:str2 attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor whiteColor], NSBackgroundColorAttributeName:[UIColor grayColor], NSParagraphStyleAttributeName: paragraph, NSBaselineOffsetAttributeName: [NSNumber numberWithFloat: 4.0]}];
    
    [s1 appendAttributedString: s2];
    
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.numberOfLines = 2;
    [cell.textLabel setAttributedText:s1];
}

- (IBAction)SmokingChanged:(id)sender{
    //To find out the cell
    UITableViewCell *cell=[self searchTableCell:sender];
    if(cell == nil)
        return;
    
    if(_SmokingSwitch.on)
    {
        [self AddFormattedStringToCell:cell str1:@"禁煙ルーム\n" str2:@" 指定あり "];
    }
    else
    {
        [self AddFormattedStringToCell:cell str1:@"禁煙ルーム\n" str2:@" 指定なし "];
    }    
}

- (IBAction)RoomsChanged:(id)sender{
    _RoomsLabel.text = [NSString stringWithFormat:@"%d", (int)_RoomsStepper.value];
}

- (IBAction)PeopleChanged:(id)sender{
    _PeopleLabel.text = [NSString stringWithFormat:@"%d", (int)_PeopleStepper.value];
}

- (IBAction)NightsChanged:(id)sender{
    _NightsLabel.text = [NSString stringWithFormat:@"%d", (int)_NightsStepper.value];
}

- (IBAction)SearchPressed:(id)sender {
    if(!_realTimeMode)
    {
        dict = [[NSMutableDictionary alloc] init];
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        if([ud stringForKey:MEMBER_NUM])
            dict[MEMBER_FLAG] = @"Y";
        else
            dict[MEMBER_FLAG] = @"N";
        
        dict[CHECKIN_DATE] = CheckinDate;
        dict[NUM_NIGHTS] = [NSString stringWithFormat:@"%d", Nights];
        dict[NUM_PEOPLE] = [NSString stringWithFormat:@"%d", (int)_PeopleStepper.value];
        dict[NUM_ROOMS] = [NSString stringWithFormat:@"%d", (int)_RoomsStepper.value];
        
        if(_SmokingSwitch.on)
            dict[SMOKING_FLAG] = @"N"; //on -- non-smoking
        else
            dict[SMOKING_FLAG] = @"Y";
        
        if([Dest isEqualToString:@""] && searchArea == nil) //empty -- around current place
        {
            if(currLngtd == 0.0f && currLatt == 0.0f)
            {
                UIAlertView *alert =
                [[UIAlertView alloc] initWithTitle:@"確認" message:@"現在地情報が取得できません。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"はい", nil];
                [alert show];
                return;
            }
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
        }
        else if(searchArea == nil)
        {
            dict[@"mode"] = @"1";
            dict[KEYWORD] = Dest;
        }
        else
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
}

- (void)locationManager:(CLLocationManager *)manager
didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusAuthorizedAlways ||
        status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        [locationManager startUpdatingLocation];
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

-(void)FillRoomType:(UITableViewCell*)cell
{
    NSString *roomtypename;
    if([RoomTypeName isEqualToString:@""])
        roomtypename = @"指定なし";
    else
        roomtypename = RoomTypeName;
    
    [self AddFormattedStringToCell:cell str1:@"部屋タイプ\n" str2:[NSString stringWithFormat: @" %@ ", roomtypename]];
    cell.imageView.image = [UIImage imageNamed:@"部屋タイプアイコン"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

-(void)FillDistance:(UITableViewCell*)cell
{
    NSString *target;
    if([Dest isEqualToString:@""]) //empty -- current place
        target = @"現在地";
    else
        target = Dest;
    
    [self AddFormattedStringToCell:cell str1:@"距離指定\n" str2:[NSString stringWithFormat: @" %@から%fkm ", target, distance]];
    cell.imageView.image = [UIImage imageNamed:@"距離アイコン"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

-(void)FillDate:(UITableViewCell*)cell
{
    [self AddFormattedStringToCell:cell str1:@"宿泊日\n" str2:[NSString stringWithFormat:@" %@〜%d泊 ",[Constant convertToLocalDate:CheckinDate], Nights] /*@"　2014年1月10日〜1泊　"*/];
    cell.imageView.image = [UIImage imageNamed:@"宿泊日アイコン"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault; //enable selection
}

-(void)FillDest:(UITableViewCell*)cell
{
    NSString *formattedDest;
    if([Dest isEqualToString:@""] && searchArea == nil)
        formattedDest = @" 現在地周辺 ";
    else if(searchArea == nil)
        formattedDest = [NSString stringWithFormat:@" %@ ", Dest];
    else
        formattedDest = [NSString stringWithFormat:@" %@ ", searchArea[STATE_NAME]];
    [self AddFormattedStringToCell:cell str1:@"目的地\n" str2:formattedDest/*@"　現在地周辺　"*/];
    cell.imageView.image = [UIImage imageNamed:@"目的地アイコン"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault; //enable selection
}

-(void)FillRooms:(UITableViewCell*)cell
{
    [cell.textLabel setText:@"部屋数"];
    cell.imageView.image = [UIImage imageNamed:@"部屋数アイコン"];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if(_RoomsStepper == nil)
    {
        _RoomsStepper = [[UIStepper alloc] init];
        _RoomsStepper.maximumValue = 4.0; //max 4 rooms at once
        _RoomsStepper.minimumValue = 1.0; //at least one room
        _RoomsStepper.value = 1.0;
        _RoomsStepper.stepValue = 1.0;
        
        _RoomsStepper.tintColor = [UIColor whiteColor];
        _RoomsStepper.backgroundColor = [UIColor blueColor];
    }
    int offset;
    
    //Add stepper
    offset = (ROW_HEIGHT - _RoomsStepper.frame.size.height)/2;
    [_RoomsStepper setFrame:CGRectMake(cell.contentView.frame.size.width-/*offset-*/_RoomsStepper.frame.size.width,
                                       offset,
                                       _RoomsStepper.frame.size.width,
                                       _RoomsStepper.frame.size.height)];
    [_RoomsStepper addTarget:self action:@selector(RoomsChanged:) forControlEvents:UIControlEventValueChanged];
    [cell.contentView addSubview:_RoomsStepper];
    
    //Add label
    if(_RoomsLabel==nil)
    {
        _RoomsLabel = [[UILabel alloc] init];
    }
    offset = (ROW_HEIGHT - LABEL_HEIGHT)/2;
    _RoomsLabel.textColor = [UIColor blackColor];
    _RoomsLabel.text = [NSString stringWithFormat:@"%d", (int)_RoomsStepper.value];
    [_RoomsLabel setFrame:CGRectMake(cell.contentView.frame.size.width-offset-_RoomsStepper.frame.size.width-LABEL_WIDTH,
                                       offset,
                                       LABEL_WIDTH,
                                       LABEL_HEIGHT)];
    
    [cell.contentView addSubview:_RoomsLabel];
}

-(void)FillNights:(UITableViewCell*)cell
{
    [cell.textLabel setText:@"宿泊数"];
    cell.imageView.image = [UIImage imageNamed:@"宿泊数アイコン"];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if(_NightsStepper==nil)
    {
        _NightsStepper = [[UIStepper alloc] init];
        _NightsStepper.maximumValue = 7.0; //max 7 nights
        _NightsStepper.minimumValue = 1.0; //at least one night
        _NightsStepper.value = 1.0;
        _NightsStepper.stepValue = 1.0;
        
        _NightsStepper.tintColor = [UIColor whiteColor];
        _NightsStepper.backgroundColor = [UIColor blueColor];
    }
    int offset;
    
    //Add stepper
    offset = (ROW_HEIGHT -_NightsStepper.frame.size.height)/2;
    [_NightsStepper setFrame:CGRectMake(cell.contentView.frame.size.width-offset-_NightsStepper.frame.size.width,
                                       offset,
                                       _NightsStepper.frame.size.width,
                                       _NightsStepper.frame.size.height)];
    [_NightsStepper addTarget:self action:@selector(NightsChanged:) forControlEvents:UIControlEventValueChanged];
    [cell.contentView addSubview:_NightsStepper];
    
    //Add label
    if(_NightsLabel==nil)
        _NightsLabel = [[UILabel alloc] init];
    offset = (ROW_HEIGHT - LABEL_HEIGHT)/2;
    _NightsLabel.textColor = [UIColor blackColor];
    _NightsLabel.text = [NSString stringWithFormat:@"%d", (int)_NightsStepper.value];
    [_NightsLabel setFrame:CGRectMake(cell.contentView.frame.size.width-offset-_NightsStepper.frame.size.width-LABEL_WIDTH,
                                     offset,
                                     LABEL_WIDTH,
                                     LABEL_HEIGHT)];
    
    [cell.contentView addSubview:_NightsLabel];
}

-(void)FillPeople:(UITableViewCell*)cell
{
    [cell.textLabel setText:@"人数"];
    cell.imageView.image = [UIImage imageNamed:@"人数アイコン"];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if(_PeopleStepper==nil)
    {
        _PeopleStepper = [[UIStepper alloc] init];
        _PeopleStepper.maximumValue = 5.0; //max 7 people
        _PeopleStepper.minimumValue = 1.0; //at least one person
        _PeopleStepper.value = 1.0;
        _PeopleStepper.stepValue = 1.0;
#if 1
        _PeopleStepper.tintColor = [UIColor whiteColor];
        _PeopleStepper.backgroundColor = [UIColor blueColor];
        //NSLog(@"stepper border width: %f", _PeopleStepper.layer.borderWidth);
        //NSLog(@"stepper border corner: %f", _PeopleStepper.layer.cornerRadius);
#endif
    }
    int offset;
    
    //Add stepper
    offset = (ROW_HEIGHT -_PeopleStepper.frame.size.height)/2;
    [_PeopleStepper setFrame:CGRectMake(cell.contentView.frame.size.width-/*offset-*/_PeopleStepper.frame.size.width,
                                        offset,
                                        _PeopleStepper.frame.size.width,
                                        _PeopleStepper.frame.size.height)];
    [_PeopleStepper addTarget:self action:@selector(PeopleChanged:) forControlEvents:UIControlEventValueChanged];
    [cell.contentView addSubview:_PeopleStepper];
    NSLog(@"people stepper: %@", NSStringFromCGRect(_PeopleStepper.frame));
    
    //Add label
    if(_PeopleLabel==nil)
        _PeopleLabel = [[UILabel alloc] init];
    offset = (ROW_HEIGHT - LABEL_HEIGHT)/2;
    _PeopleLabel.textColor = [UIColor blackColor];
    _PeopleLabel.text = [NSString stringWithFormat:@"%d", (int)_PeopleStepper.value];
    [_PeopleLabel setFrame:CGRectMake(cell.contentView.frame.size.width-offset-_PeopleStepper.frame.size.width-LABEL_WIDTH,
                                      offset,
                                      LABEL_WIDTH,
                                      LABEL_HEIGHT)];
    
    [cell.contentView addSubview:_PeopleLabel];
}

//To find out the UITableViewCell object
-(UITableViewCell*)searchTableCell:(UIView*)view
{
    id target = [view superview];
    if(!target)
        return nil;
    if([target isKindOfClass:[UITableViewCell class]])
    {
        return target;
    }
    return [self searchTableCell:target];
}

-(void)FillSmoking:(UITableViewCell*)cell
{
    [self AddFormattedStringToCell:cell str1:@"禁煙ルーム\n" str2:@" 指定なし "];
    cell.imageView.image = [UIImage imageNamed:@"喫煙アイコン"];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if(_SmokingSwitch==nil)
    {
        _SmokingSwitch = [[UISwitch alloc]init];
        _SmokingSwitch.on = NO;
        _SmokingSwitch.onTintColor = [Constant AppDarkBlueColor];
    }
    
    int offset = (ROW_HEIGHT - _SmokingSwitch.frame.size.height)/2;
    
    [_SmokingSwitch setFrame:CGRectMake(cell.contentView.frame.size.width-offset-_SmokingSwitch.frame.size.width,
                              offset,
                              _SmokingSwitch.frame.size.width,
                              _SmokingSwitch.frame.size.height)];

    [_SmokingSwitch addTarget:self action:@selector(SmokingChanged:) forControlEvents:UIControlEventValueChanged];

    [cell.contentView addSubview:_SmokingSwitch];
}

-(void)FillCell:(UITableViewCell*)cell keyword:(NSString*)keyword
{
    if([keyword isEqualToString:@"RoomType"])
    {
        [self FillRoomType:cell];
    }
    else if([keyword isEqualToString:@"Dest"])
    {
        [self FillDest:cell];
    }
    else if([keyword isEqualToString:@"Date"])
    {
        [self FillDate:cell];
    }
    else if([keyword isEqualToString:@"Distance"])
    {
        [self FillDistance:cell];
    }
    else if([keyword isEqualToString:@"Smoking"])
    {
        [self FillSmoking:cell];
    }
    else if([keyword isEqualToString:@"Rooms"])
    {
        [self FillRooms:cell];
    }
    else if([keyword isEqualToString:@"Nights"])
    {
        [self FillNights:cell];
    }
    else if([keyword isEqualToString:@"People"])
    {
        [self FillPeople:cell];
    }
//    Adjust the image size to half of cell height
    [cell.layer setBorderWidth:0.5];
    [cell.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];

    cell.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [cell.imageView setContentMode: UIViewContentModeScaleAspectFit ];
    
}

-(void)ParsedDataReady:(NSDictionary*)data
{
    NSLog(@"data: %@",data);
    
    if([data[@"errrCode"] isEqualToString:@"BCMN0000"]) //success
    {
        if(_realTimeMode)
        {
        }
        else
        {
            if([Dest isEqualToString:@""] && searchArea == nil) //location search
            {
                NSArray *hotelList = data[@"htlList"];
                HotelListView *next = [self.storyboard instantiateViewControllerWithIdentifier:@"HotelList"];
                next.inputArray = hotelList;
                next.title = [NSString stringWithFormat:@"%@~%d泊 %d名%d室\n現在地周辺 %lu軒",[Constant convertToLocalDate:CheckinDate], Nights, (int)_PeopleStepper.value, (int)_RoomsStepper.value, (unsigned long)[hotelList count]];
                next.lngtd = currLngtd;
                next.lttd = currLatt;
                next.searchDict = dict;
                
                //stop gps
                [locationManager stopUpdatingLocation];
                locationManager.delegate = nil;
                
                [self presentViewController:next animated:YES completion:^ {}];
            }
            else if(searchArea!=nil)
            {
                NSArray *hotelList = data[@"htlList"];
                HotelListView *next = [self.storyboard instantiateViewControllerWithIdentifier:@"HotelList"];
                next.inputArray = hotelList;
                next.title = [NSString stringWithFormat:@"%@~%d泊 %d名%d室\nエリア:%@ %lu軒",
                              [Constant convertToLocalDate:CheckinDate],
                              Nights, (int)_PeopleStepper.value, (int)_RoomsStepper.value,searchArea[STATE_NAME], (unsigned long)[hotelList count]];
                next.keyword = Dest;
                next.searchDict = dict;
                
                next.lngtd = 0.0f;
                next.lttd = 0.0f;
                
                [self presentViewController:next animated:YES completion:^ {}];
            }
            else //keyword search
            {
                NSArray *hotelList = data[@"htlList"];
                HotelListView *next = [self.storyboard instantiateViewControllerWithIdentifier:@"HotelList"];
                next.inputArray = hotelList;
                next.title = [NSString stringWithFormat:@"%@~%d泊 %d名%d室\nキーワード:%@ %lu軒",
                              [Constant convertToLocalDate:CheckinDate],
                              Nights, (int)_PeopleStepper.value, (int)_RoomsStepper.value,Dest, (unsigned long)[hotelList count]];
                next.keyword = Dest;
                next.searchDict = dict;
                
                next.lngtd = 0.0f;
                next.lttd = 0.0f;
                
                [self presentViewController:next animated:YES completion:^ {}];
            }
        }
    }
    else if([data[@"errrCode"] isEqualToString:@"BAPI1004"])
    {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"確認" message:/*data[@"errrMssg"]*/ @"該当するホテルがありません。条件を変更して再度お試しください。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"はい", nil];
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
