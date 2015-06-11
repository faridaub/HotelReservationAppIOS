//
//  reservChange.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/08/01.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "reservChange.h"
#import "reservChangeConfirm.h"
#import "Constant.h"
#import "AppDelegate.h"

@interface reservChange ()

@end

@implementation reservChange

static NSArray *inputItems;
static NSDictionary *inputtedForm; //the retrieved data from form

static BOOL isGettingPrice = NO;

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
    
    _receivedData[RESERV_ID] = _inputDict[RESERV_ID];
    _receivedData[HOTEL_CODE] = _inputDict[HOTEL_CODE];
    
    _OKButton.clipsToBounds = YES;
    _OKButton.layer.cornerRadius = 10;
    
    NSInteger memberIndex = 1;
    BOOL isMember = NO;
    
    if([_receivedData[MEMBER_FLAG] isEqualToString:@"Y"])
    {
        memberIndex =0;
        isMember = YES;
    }
    else
    {
        memberIndex = 1;
        isMember = NO;
    }
    
    NSString *smoking;
    if(_receivedData[SMOKING_FLAG] == nil)
        smoking = @"禁煙マーク";
    else
    {
        if([_receivedData[SMOKING_FLAG] isEqualToString:@"Y"])
            smoking = @"喫煙マーク";
        else
            smoking = @"禁煙マーク";
    }
    
    NSString *tmp = _receivedData[CHECKIN_TIME];
    NSString *checkinTime = [NSString stringWithFormat:@"%@:%@",[tmp substringWithRange:NSMakeRange(0, 2)],[tmp substringWithRange:NSMakeRange(2,2)]];
    NSArray *checkinTimes = [Constant getCheckinTimeList:isMember];
    
    int checkinIndex = 0;
    
    for(int i=0; i<checkinTimes.count; i++)
    {
        if([checkinTimes[i] isEqualToString:checkinTime])
        {
            checkinIndex = i;
            break;
        }
    }
    
    NSArray *dailyInfo = _receivedData[@"dlyInfrmtn"];
    NSMutableString *ecoplan = [[NSMutableString alloc] init];
    
    int ecoCount =0;
    int isEcoUsed = 1;
    BOOL hideEcoplan  = YES;
    NSMutableArray *ecoDates = [[NSMutableArray alloc]init];
    //Count how many days applied with eco plan
    for(NSDictionary *dict in dailyInfo)
    {
        if([dict[ECO_FLAG] isEqualToString:@"Y"])
        {
            ecoCount++;
            isEcoUsed = 0;
            hideEcoplan = NO;
            
            NSString *targetDate = dict[TARGET_DATE];
            tmp = [NSString stringWithFormat:@"%@/%@", [targetDate substringWithRange:NSMakeRange(4,2)], [targetDate substringWithRange:NSMakeRange(6, 2)]];
            
            [ecoDates addObject:tmp];
        }
    }
    //NSLog(@"eco dates: %@", ecoDates);
    
    if([_receivedData[ECOPLAN_CHECKIN_SPECIFY] isEqualToString:@"Y"])
    {
        ecoplan = [@"チェックイン時指定" mutableCopy];
    }
    
    int isBusiUsed = 1;
    BOOL hideBusipak = YES;
    NSString* busipak;
    
    if([_receivedData[BUSI_FLAG] isEqualToString:@"Y"])
    {
        isBusiUsed = 0;
        hideBusipak = NO;
        busipak = _receivedData[BUSI_TYPE];
    }
    else
    {
        busipak = @"-1";
    }
    
    int isSharedBedUsed = 1;
    if([_receivedData[SHARE_BED] isEqualToString:@"Y"])
        isSharedBedUsed = 0;
    
    int isVodUsed = 1;
    if([_receivedData[VOD_FLAG] isEqualToString:@"Y"])
        isVodUsed = 0;
    
    NSUInteger nights = 0;
    
    if(_receivedData[NUM_NIGHTS] == nil) //nights not set
    {
        NSString *checkinDate = _receivedData[CHECKIN_DATE];
        NSString *checkoutDate = _receivedData[CHECKOUT_DATE];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyyMMdd"];
        NSDate *date2 = [dateFormat dateFromString:checkoutDate];
        NSDate *date1 = [dateFormat dateFromString:checkinDate];
        
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSGregorianCalendar];
        NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
        
        NSDateComponents *components = [gregorian components:unitFlags
                                                    fromDate:date1
                                                      toDate:date2 options:0];
        nights = [components day];
        _receivedData[NUM_NIGHTS] = [NSNumber numberWithInteger:nights];
    }
    else
    {
        nights = [_receivedData[NUM_NIGHTS]integerValue];
    }
    
    BOOL isHideEco;
    if(nights == 1)
        isHideEco = YES;
    else
        isHideEco = NO;
    
    NSString *nationality;
    if(_receivedData[NATIONALITY] == nil)
    {
        //the guest is assumed as Japanese by default
        nationality = [Constant NationalityNameFromCode:@"JPN" lang:@"ja"];
    }
    else if([_receivedData[NATIONALITY] isEqualToString:@""]) //empty item
    {
        nationality = [Constant NationalityNameFromCode:@"JPN" lang:@"ja"];
    }
    else
    {
        nationality = [Constant NationalityNameFromCode:_receivedData[NATIONALITY] lang:@"ja"];
    }
    
    NSString *roomName = _receivedData[ROOM_NAME];
    if(roomName == nil) //avoid null pointer
        roomName = @"";
    
    int num_people = [_receivedData[NUM_PEOPLE] intValue];
    
    inputItems = @[
                   @{@"cellName":@"Title0", @"type":@"ToyokoCustomCell", @"title":[NSString stringWithFormat:@"予約番号：%@",_receivedData[RESERV_NUM]], @"identifier":@"room1_rsrvtnNmbr"},
                   @{@"cellName":@"Title1", @"type":@"ToyokoCustomCell", @"title":_receivedData[HOTEL_NAME], @"identifier":HOTEL_NAME},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"宿泊日", @"title2":[NSString stringWithFormat:@"%@〜%ld泊", [Constant convertToLocalDate:_receivedData[CHECKIN_DATE]],(unsigned long)nights], @"identifier":@"room1_chcknDate"},
                   @{@"cellName":@"Button", @"type":@"ToyokoButtonCell", @"title":roomName, @"icon":smoking, @"buttonTitle":@"変更する", @"hidden":@(YES), @"identifier":@"room1_roomType"},
                   [@{@"cellName":@"Stepper", @"type":@"ToyokoStepperCell", @"title":@"ご利用人数", @"format":@"%d名", @"max":@(num_people), @"min":@(num_people), @"value":@(num_people), @"observer":self, @"identifier":@"room1_nmbrPpl"}mutableCopy],
                   @{@"cellName":@"Title2", @"type":@"ToyokoCustomCell", @"title":@"宿泊者情報", @"identifier":@"room1_guest"},
                   [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"姓(半角アルファベット)", @"value":_receivedData[FAMILY_NAME], @"hint":@"例：TOYOKO", @"identifier":@"room1_fmlyName", @"valid":@"letter", @"clear":@(YES), @"upper":@(YES), @"required":@(YES)}mutableCopy],
                   [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"名(半角アルファベット)", @"value":_receivedData[GIVEN_NAME], @"hint":@"例：TARO",
                      @"identifier":@"room1_frstName", @"valid":@"letter", @"clear":@(YES), @"upper":@(YES), @"required":@(YES)}mutableCopy],
                   //@{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"姓名は半角アルファベットで入力して下さい", @"color":[Constant AppRedColor], @"identifier":@"name_desc"},
#if 0
                   [@{@"cellName":@"Segment", @"type":@"ToyokoSegmentCell", @"title":@"性別", @"choices":[Constant getGenderNames:@"ja"], @"value":[Constant GenderIndexFromCode:_receivedData[GENDER]], @"identifier":@"room1_sex", @"required":@(YES)}mutableCopy],
#else
                   [@{@"cellName":@"Picker", @"type":@"ToyokoPickerCell", @"title":@"性別", @"choices":[Constant getGenderNames:@"ja"], @"value":[Constant GenderIndexFromCode:_receivedData[GENDER]], @"expanded":@(NO), @"minHeight":@(44), @"maxHeight":@(220), @"identifier":@"room1_sex", @"required":@(YES)}mutableCopy],
#endif
                   [@{@"cellName":@"Segment", @"type":@"ToyokoSegmentCell", @"title":@"東横INNｸﾗﾌﾞｶｰﾄﾞ会員", @"choices":@[@"はい",@"いいえ"], @"value":@(memberIndex), @"observer":self, @"identifier":@"room1_mmbrshpFlag"}mutableCopy],
                   [@{@"cellName":@"Text1", @"type":@"ToyokoTextCell", @"title":@"会員番号", @"clear":@(YES), @"value":_receivedData[MEMBER_NUM], @"identifier":@"room1_mmbrshpNmbr", @"required":@(NO)}mutableCopy],
                   [@{@"cellName":@"Picker", @"type":@"ToyokoPickerCell", @"title":@"国籍", @"choices":[Constant getNationalityNames:@"ja"], @"value":[Constant NationalityIndexFromCode:_receivedData[NATIONALITY]], @"expanded":@(NO), @"minHeight":@(44), @"maxHeight":@(220), @"identifier":@"room1_ntnltyCode", @"required":@(YES)}mutableCopy],
                   [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"電話番号", @"value":_receivedData[TEL_NUM], @"identifier":@"room1_phnNmbr", @"valid":@"decimal", @"clear":@(YES), @"required":@(YES), /*@"secure":@(YES)*/}mutableCopy],
                   @{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"*当日連絡可能な番号を入力してください",@"color":[Constant AppRedColor], @"identifier":@"room1_tel_desc"},
                   @{@"cellName":@"Title2", @"type":@"ToyokoCustomCell", @"title":@"オプション", @"identifier":@"room1_option"},
                   [@{@"cellName":@"Segment", @"type":@"ToyokoSegmentCell", @"title":@"連泊ECOプラン", @"choices":@[@"利用する",@"利用しない"], @"value":@(isEcoUsed), @"observer":self,@"hidden":@(isHideEco), @"identifier":@"room1_ecoFlag"}mutableCopy],
                   [@{@"cellName":@"EcoplanCell", @"type":@"ToyokoEcoplanCell", @"dates":[Constant genEcoDates:_receivedData[CHECKIN_DATE] nights:(int)nights],@"value":ecoDates, @"observer":self, @"hidden":@(hideEcoplan),@"ecoChckn":@(NO),  @"identifier":@"room1_ecoDtsList"} mutableCopy],
                   @{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"お部屋の清掃、ナイトウェア、シーツ類の交換、アメニティグッズの補充を省かせていただきその分宿泊料金が2泊目以降、1泊につき300円お安くなります。", @"hidden":@(isHideEco), @"identifier":@"room1_ecoplan_desc"},
                   [@{@"cellName":@"Segment", @"type":@"ToyokoSegmentCell", @"title":@"VOD (+500円)", @"choices":@[@"利用する",@"利用しない"], @"value":@(isVodUsed), @"observer":self, @"identifier":@"room1_vodFlag"}mutableCopy],
                   @{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"500円（税込）で200以上のコンテンツ見放題！", @"identifier":@"room1_vod_desc"},
                   [@{@"cellName":@"Segment", @"type":@"ToyokoSegmentCell", @"title":@"ビジネスパック", @"choices":@[@"利用する",@"利用しない"], @"value":@(isBusiUsed), @"observer":self,  @"identifier":@"room1_bsnssPackFlag"}mutableCopy],
                   [@{@"cellName":@"Busipak", @"type":@"ToyokoBusiPak", @"format1":@"ビジネスパック%@", @"format2":@"(%@円分のVISAギフトカード付き)", @"values1":@[@(100), @(200), @(300)], @"values2":@[@(1000), @(2000), @(3000)],@"value":@([busipak intValue]), @"observer":self, @"hidden":@(hideBusipak), @"identifier":@"room1_bsnssPackType"} mutableCopy],
                   @{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"宿泊にVISAギフトカードをつけることができます。領収書の金額はセット料金でお出しします。", @"identifier":@"room1_busi_desc"},
#if 0
                   [@{@"cellName":@"Segment", @"type":@"ToyokoSegmentCell", @"title":@"出張パック", @"choices":@[@"利用する",@"利用しない"], @"value":@(0), @"identifier":@"busitrip_room1"}mutableCopy],
                   [@{@"cellName":@"Busipak", @"type":@"ToyokoBusiPak", @"format1":@"出張パック%@", @"format2":@"(%@円分のVISAギフトカード+VOD付き)", @"values1":@[@(100), @(200), @(300)], @"values2":@[@(1000), @(2000), @(3000)], @"identifier":@"busitrippak_room1"} mutableCopy],
                   @{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"宿泊にVISAギフトカードをつけることができます。領収書の金額はセット料金でお出しします。", @"identifier":@"busitrip_desc_room1"},
#endif
                   [@{@"cellName":@"Segment", @"type":@"ToyokoSegmentCell", @"title":@"お子様添い寝", @"choices":@[@"あり",@"なし"], @"value":@(isSharedBedUsed), @"identifier":@"room1_chldrnShrngBed"}mutableCopy],
                   @{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"小学生以下のお子様が大人と同じベッドで添い寝する場合、1つのベッドにつきお子様1名様まで無料で添い寝可能です。添い寝されるお子様がいる場合は「あり」にしてください。添い寝のお子様のアメニティグッズ、タオル、枕等は付きません。ご利用の場合は、別途料金がかかります。", @"identifier":@"room1_childfree_desc"},
                   [@{@"cellName":@"Picker", @"type":@"ToyokoPickerCell", @"title":@"ﾁｪｯｸｲﾝ予定時刻", @"choices":checkinTimes, @"value":@(checkinIndex), @"expanded":@(NO), @"minHeight":@(44), @"maxHeight":@(220), @"identifier":@"room1_chcknTime", @"required":@(YES)}mutableCopy],
                   [@{@"cellName":@"TotalPrice", @"type":@"ToyokoPriceCell", @"str1":@"お支払金額",  @"str2":[NSString stringWithFormat:@"　%@（税込%@）",_receivedData[TOTAL_PRICE], _receivedData[TOTAL_PRICE_TAX]], @"identifier":@"price_total"}mutableCopy],
                   ];
#if 0
    CGRect r = [[UIScreen mainScreen] bounds];
    
    [_OKButton setFrame:CGRectMake(_OKButton.frame.origin.x, r.size.height-_OKButton.frame.size.height,_OKButton.frame.size.width, _OKButton.frame.size.height)];
    [_containerView setFrame:CGRectMake(_containerView.frame.origin.x, _containerView.frame.origin.y,
                                    _containerView.frame.size.width, r.size.height-_containerView.frame.origin.y-_OKButton.frame.size.height)];
#endif
    if(_targetTableVC)
    {
#if 0
        UITableView *tableview = _targetTableVC.tableView;
        [tableview.layer setBorderWidth:0.0f];
        tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableview.separatorColor = [UIColor clearColor];
        
        //For iOS 6/7 compatiblilty, because setSeparatorInset is available from iOS 7
        if ([tableview respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableview setSeparatorInset:UIEdgeInsetsMake(0.f, 0.f, 0.f, tableview.bounds.size.width)];
        }
#endif
        _targetTableVC.removeSeparator = YES;
        [_targetTableVC reload:inputItems];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(_targetTableVC)
        [_targetTableVC HookObserver];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_targetTableVC)
        [_targetTableVC UnhookObserver];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"table_embed"]) {
        NSLog(@"found childVC");
        _targetTableVC = (ToyokoCustomTableVC *) [segue destinationViewController];
        [_targetTableVC.tableView.layer setBorderColor:[UIColor blackColor].CGColor];
        [_targetTableVC.tableView.layer setBorderWidth:0.5f];
        //_targetTableVC.dialogScript = inputItems;
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

//return YES if required items are all available; return NO elsewise
-(BOOL)GetInput:(NSMutableDictionary*)dict required:(BOOL)required
{
    UIAlertView *alert;
    
    NSString *VALUE = @"value";
    NSString *ID = @"identifier";
    
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    //To check the required items
    NSLog(@"count of inputItems: %lu", (unsigned long)inputItems.count);
    
    if(required)
    {
        for(id tmp in inputItems)
        {
            //item for input
#if 0
            NSLog(@"tmp's class: %@", NSStringFromClass([tmp class]));
#endif
            if([tmp isKindOfClass:[NSMutableDictionary class]])
            {
                NSMutableDictionary *item = (NSMutableDictionary*)tmp;
                if(item[@"required"] == nil) //required not set
                    continue; //nothing to check, go to next one
                
                if([item[@"required"] boolValue] == NO) //not required
                    continue; //go to next one
                
                if([item[@"type"] isEqualToString:@"ToyokoTextCell"] == NO) //not text field
                    continue;
                
                NSString *str = item[@"value"];
                if([str length] == 0) //required item is empty string
                {
                    alert =
                    [[UIAlertView alloc] initWithTitle:@"確認" message:@"未入力の必須項目があります。ご確認ください。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    [alert show];
                    return NO;
                }
            }
        }
    }
    
    NSString *telnum = [_targetTableVC findRow:TEL_NUM][VALUE];
    if(telnum.length > 0) //avoid empty mobile email
    {
        if([Constant IsValidTelnum:telnum] == NO) //phone number format invalid
        {
            alert =
            [[UIAlertView alloc] initWithTitle:@"確認" message:@"電話番号が短すぎます。正しい番号を入力してください。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            return NO;
        }
    }
    
    //retrieve the text items
    for(NSDictionary *item in inputItems)
    {
        if([item isKindOfClass:[NSMutableDictionary class]] == NO) //not input item
            continue;
        if([item[@"type"] isEqualToString:@"ToyokoTextCell"] == NO) //not text field
            continue;
        
        //get the keyword
        NSString *identifier = item[ID];
        //copy the value with associated keyword
        dict[identifier] = item[VALUE];
    }
    
    int num_rooms = 1;
    //NSArray *dailyInfo = _receivedData[@"dlyInfrmtn"];
    
    //TODO: handle extra nights
    //int num_nights = (int)dailyInfo.count;
    NSString *checkoutDate = _receivedData[CHECKOUT_DATE];
    
    NSArray *YNItems = @[@"room%d_vodFlag", @"room%d_ecoFlag", @"room%d_mmbrshpFlag", @"room%d_bsnssPackFlag", @"room%d_chldrnShrngBed"];
    
    for(int i=1; i<=num_rooms; i++)
    {
        NSString *identifier;
        
        //handle sex
        identifier = [NSString stringWithFormat:@"room%d_sex",i];
        NSUInteger index = [[_targetTableVC findRow:identifier][VALUE] integerValue];
        dict[identifier] = [Constant getGenderCode:index];
        
        //handle Y/N items
        for(NSString *key in YNItems)
        {
            identifier = [NSString stringWithFormat:key, i];
            index = [[_targetTableVC findRow:identifier][VALUE] integerValue];
            if(index == 0)
                dict[identifier] = @"Y";
            else
                dict[identifier] = @"N";
        }
        
        //handle picker items
        identifier = [NSString stringWithFormat:@"room%d_ntnltyCode", i];
        index = [[_targetTableVC findRow:identifier][VALUE] integerValue];
        dict[identifier] = [Constant getNationalityCode:index];
        
        identifier = [NSString stringWithFormat:@"room%d_chcknTime", i];
        index = [[_targetTableVC findRow:identifier][VALUE] integerValue];
        NSArray *checkinTimes = [_targetTableVC findRow:identifier][@"choices"];
        dict[identifier] = checkinTimes[index];
        
        //get eco dates if eco flag is Y
        if([dict[[NSString stringWithFormat:@"room%d_ecoFlag", i]] isEqualToString:@"Y"])
        {
#if 1
            identifier = [NSString stringWithFormat:@"room%d_ecoDtsList", i];
            
            BOOL isCorrect = YES;
            NSArray *dates = [_targetTableVC findRow:identifier][VALUE];
            NSString *ecoChckn = @"N"/*[_targetTableVC findRow:identifier][@"ecoChckn"]*/;
            
            if(dates == nil)
                dates = @[];
            
            if(dates.count == 0) //no date is set
            {
                if(ecoChckn) //ecoChckn is not nil
                {
                    if([ecoChckn isEqualToString:@"N"])
                        isCorrect = NO;
                }
                else
                    isCorrect = NO;
            }
            
            if(isCorrect && dates.count > 1) //more than 1 date
            {
                NSArray *possibleDates = [_targetTableVC findRow:identifier][@"dates"];
                BOOL isContiguous = NO;
                NSUInteger prevIndex = [possibleDates indexOfObject:dates[0]];
                for(int j=1; j<dates.count; j++)
                {
                    NSUInteger index = [possibleDates indexOfObject:dates[j]];
                    NSLog(@"date %@ index %lu", dates[j], (unsigned long)index);
                    if(index == prevIndex + 1) //contiguous
                    {
                        if(isContiguous) //already contiguous
                        {
                            isCorrect = NO;
                            break;
                        }
                        else
                            isContiguous = YES;
                    }
                    else
                        isContiguous = NO;
                    
                    prevIndex = index;
                }
            }
#if 1
            if(!isCorrect) //incorrect format
            {
                if(required)
                {
                    UIAlertView *alert;
                    alert = [[UIAlertView alloc] initWithTitle:@"確認" message:@"連泊ECOプランは、3日連続は選択できません。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    [alert show];
                }
                return NO;
            }
#endif
            NSString *checkinDate = _inputDict[CHECKIN_DATE];
            NSString *checkinYear = [checkinDate substringWithRange:NSMakeRange(0, 4)];
            NSString *checkoutYear = [checkoutDate substringWithRange:NSMakeRange(0, 4)];
            
            NSString *year;
            
            if([checkinYear isEqualToString:checkoutYear])
            {
                year = checkinYear;
                
                for(int j=0; j<dates.count; j++)
                {
                    NSString *ID = [NSString stringWithFormat:@"%@[%d]", identifier, j];
                    NSString *date = dates[j];
                    
                    //create year + MMDD string
                    date = [year stringByAppendingString:[[date componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""]];
                    
                    dict[ID] = date;
                }
            }
            else if(dates.count > 0)//checkout year is the next year
            {
                int nextYearIndex = -1; //not exist
                
                NSString *currMonth = dates[0];
                currMonth = [currMonth substringWithRange:NSMakeRange(0,2)];
                
                NSString *lastMonth = dates[dates.count-1];
                lastMonth = [lastMonth substringWithRange:NSMakeRange(0, 2)];
                
                NSString *year;
                
                if([currMonth isEqualToString:@"01"]) //1st day is already the next year
                {
                    year = checkoutYear;
                }
                else if([lastMonth isEqualToString:@"12"]) //last day is the current year
                {
                    year = checkinYear;
                }
                else //different year
                {
                    //because the checkin/out years are different, there must be at least 2 dates
                    //find out from which index the month changed
                    for(int j=1;j<dates.count; j++)
                    {
                        NSString *tmp = dates[j];
                        tmp = [tmp substringWithRange:NSMakeRange(0,2)];
                        if([tmp isEqualToString:currMonth]) //same month
                        {
                            continue;
                        }
                        else //different month, index found
                        {
                            nextYearIndex = j;
                            break;
                        }
                    }
                    
                    if(nextYearIndex == -1)
                    {
                        for(int j=0; j<dates.count; j++)
                        {
                            NSString *ID = [NSString stringWithFormat:@"%@[%d]", identifier, j];
                            NSString *date = dates[j];
                            
                            //create year + MMDD string
                            date = [year stringByAppendingString:[[date componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""]];
                            
                            dict[ID] = date;
                        }
                    }
                    else
                    {
                        for(int j=0; j<dates.count; j++)
                        {
                            if(j < nextYearIndex)
                                year = checkinYear;
                            else
                                year = checkoutYear;
                            
                            NSString *ID = [NSString stringWithFormat:@"%@[%d]", identifier, j];
                            NSString *date = dates[j];
                            
                            //create year + MMDD string
                            date = [year stringByAppendingString:[[date componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""]];
                            
                            dict[ID] = date;
                        }
                    }
                }
            }
            
            NSString *ID = [NSString stringWithFormat:@"room%d_ecoChckn", i];
            if(ecoChckn) //value is set
            {
                dict[ID] = [ecoChckn copy];
                //the date array is reset when ecoChckn is Y, so no further handling
            }
            else
            {
                dict[ID] = @"N"; //the default value
            }
#endif
        }
        else
        {
            identifier = [NSString stringWithFormat:@"room%d_ecoChckn",i];
            dict[identifier] = @"N";
        }
        
        //get business pack type if busi flag is Y
        if([dict[[NSString stringWithFormat:@"room%d_bsnssPackFlag", i]] isEqualToString:@"Y"])
        {
            identifier = [NSString stringWithFormat:@"room%d_bsnssPackType", i];
            index = [[_targetTableVC findRow:identifier][VALUE] integerValue];
            //NSArray *types = [_targetTableVC findRow:identifier][@"values1"];
            //the types of business pack should be 1,2,3,...
            dict[identifier] = [NSString stringWithFormat:@"%lu", (unsigned long)index+1];
        }
        
        identifier = [NSString stringWithFormat:@"room%d_chcknDate", i];
        dict[identifier] = _receivedData[CHECKIN_DATE];
        
        identifier = [NSString stringWithFormat:@"room%d_chcktDate", i];
        dict[identifier] = checkoutDate;
        
        identifier = [NSString stringWithFormat:@"room%d_roomType", i];
        dict[identifier] = _receivedData[ROOM_TYPE];
        
        //stepper item
        identifier = [NSString stringWithFormat:@"room%d_%@",i, NUM_PEOPLE];
        index = [[_targetTableVC findRow:identifier][VALUE] integerValue];
        dict[identifier] = [NSString stringWithFormat:@"%lu", (unsigned long)index];
    }
    
    //fill other items
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    dict[PERSON_UID] = [ud stringForKey:PERSON_UID];
    dict[NUM_ROOMS] = @"1";
    
    dict[HOTEL_CODE] = _receivedData[HOTEL_CODE];
    dict[@"room1_rsrvtnNmbr"] = _receivedData[RESERV_NUM];
    
    dict[@"room1_rsrvId"] = _inputDict[RESERV_ID];
    
    //dummy total price
    dict[TOTAL_PRICE_TAX] = @"0";
    
    return YES;
}

- (IBAction)BackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)OKPressed:(id)sender {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    if(![self GetInput:dict required:YES]) //failed, some required items are empty
    {
        return;
    }
    
    inputtedForm = dict; //keep the retrieved data
    
    dict[@"mode"] = @"1";
    
    //send the data to reservation check
    self.delegate = self;
    [self addRequestFields:dict];
    [self setApiName:@"check_booking_api"];
    [self setSecure:NO];
    
    isGettingPrice = NO;
    [self sendRequest];
}

-(void)ParsedDataReady:(NSDictionary*)data
{
    NSLog(@"data: %@", data);
    
    if([data[@"errrCode"] isEqualToString:@"BCMN0000"] ||
       [data[@"errrCode"] isEqualToString:@"BRSV0006"]) //ignore duplicated reservation error
    {
        if(!isGettingPrice)
        {
            reservChangeConfirm *next = [self.storyboard instantiateViewControllerWithIdentifier:@"reservChangeConfirm"];
            next.inputtedForm = inputtedForm;
            next.inputDict = _inputDict;
            //        next.roomDict = _roomDict;
            //        next.htlDict = _htlDict;
            //        next.htlName = _htlName;
            next.priceDetail = data;
            next.receivedData = _receivedData;
            
            [self presentViewController:next animated:YES completion:^{}];
        }
        else
        {
            //modify the total price and reload the table
            NSMutableDictionary *dict = (NSMutableDictionary*)[_targetTableVC findRow:@"price_total"];
            dict[@"str2"] = [NSString stringWithFormat:@"　%@（税込%@）", data[TOTAL_PRICE], data[TOTAL_PRICE_TAX]];
            
            //To update the last cell of table, the price.
            NSIndexPath *path = [NSIndexPath indexPathForRow:inputItems.count-1 inSection:0];
            
            [_targetTableVC.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
            isGettingPrice = NO;
        }
    }
    else
    {
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:@"確認" message:data[@"errrMssg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

//get the new price once the flag changes
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    NSLog(@"obj %@ %@ changed", object, keyPath);
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [self GetInput:dict required:NO];
    
    //inputtedForm = [dict mutableCopy]; //keep the retrieved data
    
    dict[@"mode"] = @"2"; //new added parameter for price calculation/real check switch
#if 1
    for(int i=1;i<=4;i++)
    {
        NSString *ID = [NSString stringWithFormat:@"room%d_chcknTime",i];
        NSString *checkinTime = dict[ID];
        if(checkinTime == nil)
            continue; //no such room
        
        checkinTime = [[checkinTime componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
        checkinTime = [NSString stringWithFormat:@"%@00", checkinTime];
        dict[ID] = checkinTime;
    }
#endif
    
    //send room1's reservation number
    //dict[@"room1_rsrvtnNmbr"] = _receivedData[RESERV_NUM];
    
    //send the data to reservation check
    self.delegate = self;
    [self addRequestFields:dict];
    [self setApiName:@"check_booking_api"];
    [self setSecure:NO];
    
    isGettingPrice = YES;
    [self sendRequest];
    
    //TODO: eco plan/business pack option enable/disable
    NSString *busipak = @"bsnssPackFlag";
    NSString *ecoplan = @"ecoFlag";
    NSString *membership= @"mmbrshpFlag";
    
    BOOL isMatched = NO;
    
    NSArray *keys = @[busipak, ecoplan, membership];
    
    NSMutableDictionary *dictObj = (NSMutableDictionary*)object;
    NSString *identifier = dictObj[@"identifier"];
    
    NSRange range;
    
    for(NSString *str in keys)
    {
        range = [identifier rangeOfString:str];
        if (range.location != NSNotFound)
            isMatched |= YES;
    }
    
    if (isMatched) {
        range = [identifier rangeOfString:membership];
        
        //added for check-in time range adjustment
        if(range.location != NSNotFound) //membership changed
        {
            //get the value of membership
            NSInteger index = [_targetTableVC findRowIndex:identifier];
            NSMutableDictionary *tmpDict = inputItems[index];
            index = [tmpDict[@"value"]integerValue];
            BOOL isMember = NO;
            
            if(index == 0)
                isMember = YES;
            else
                isMember = NO;
            
            //get and set the checkin time item
            NSString *roomName = [identifier componentsSeparatedByString:@"_"][0];
            NSString *checkinTimeID = [NSString stringWithFormat:@"%@_chcknTime",roomName];
            index = [_targetTableVC findRowIndex:checkinTimeID];
            tmpDict = inputItems[index];
            
            //change the value for new choices
            index = [tmpDict[@"value"]integerValue];
            if(isMember)
                index += 2;
            else
                index -=2;
            
            //boundary check
            if (index < 0)
                index = 0;
            
            NSArray *choices = [Constant getCheckinTimeList:isMember];
            
            if(index >= choices.count)
            {
                index = choices.count - 1;
            }
            
            tmpDict[@"choices"] = choices;
            tmpDict[@"value"] = @(index);
            
            NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
            [_targetTableVC.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else
        {
            NSInteger value = [dictObj[@"value"] integerValue];
            NSInteger index = [_targetTableVC findRowIndex:identifier];
            NSMutableDictionary *tmpDict = inputItems[index+1]; //get the next one
            
            if(value == 0) //0: yes
            {
                tmpDict[@"hidden"] = @(NO);
            }
            else
            {
                tmpDict[@"hidden"] = @(YES);
            }
            NSIndexPath *path = [NSIndexPath indexPathForRow:index+1 inSection:0];
            
            [_targetTableVC.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

-(void)connectionFailed:(NSError*)error
{
}
@end
