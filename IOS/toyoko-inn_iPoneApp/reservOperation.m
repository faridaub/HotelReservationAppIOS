//
//  reservOperation.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/08/12.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "reservOperation.h"
#import "Constant.h"
#import "reservCancelConfirm.h"
#import "reservChange.h"

@interface reservOperation ()

@end

@implementation reservOperation

static NSMutableArray *inputItems;
static NSMutableDictionary *receivedData;

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
    
    NSArray *buttons = @[_CancelButton, _ChangeButton];
    
    for(UIButton *btn in buttons)
    {
        btn.clipsToBounds = YES;
        btn.layer.cornerRadius = 10;
    }
    
    inputItems = [@[
#if 0
                   //TODO: add localized title before reservation number
                   @{@"cellName":@"Title0", @"type":@"ToyokoCustomCell", @"title":@"予約番号：ABCDEFG",   @"identifier":RESERV_NUM},
                   //TODO: combine checkin date and nights to 1 and add localized format
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"宿泊日", @"title2":@"2014年12月30日〜2泊", @"identifier":CHECKIN_DATE},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"宿泊先", @"title2":_inputDict[HOTEL_NAME], @"identifier":HOTEL_NAME},
                   //TODO: actually the room type cannot be changed. To hide the change button
                   //      and convert the smoking flag to icon
                   @{@"cellName":@"Button", @"type":@"ToyokoButtonCell", @"title":@"喫煙ダブル", @"icon":@"喫煙マーク", @"buttonTitle":@"変更する", @"identifier":ROOM_TYPE, @"hidden":@(YES)},
                   //TODO: add localized unit/description after the num of people
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"ご利用人数", @"title2":_inputDict[NUM_PEOPLE], @"identifier":NUM_PEOPLE},
                   @{@"cellName":@"Title2", @"type":@"ToyokoCustomCell", @"title":@"宿泊者情報", @"identifier":@"guest_room1"},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"姓", @"title2":_inputDict[FAMILY_NAME], @"identifier":FAMILY_NAME, /*@"bgcolor":[UIColor lightGrayColor]*/},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"名", @"title2":_inputDict[GIVEN_NAME], @"identifier":GIVEN_NAME, /*@"bgcolor":[UIColor lightGrayColor]*/},
                   //TODO: convert the member flag to localized string
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"会員/一般", @"title2":@"東横INNｸﾗﾌﾞｶｰﾄﾞ会員", @"identifier":MEMBER_FLAG,/* @"bgcolor":[UIColor lightGrayColor]*/},
                   //TODO: convert the nationality to localized string
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"国籍", @"title2":@"日本", @"identifier":NATIONALITY, /*@"bgcolor":[UIColor lightGrayColor]*/},
                   //TODO: convert the gender to localized string
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"性別", @"title2":@"男性", @"identifier":GENDER, /*@"bgcolor":[UIColor lightGrayColor]*/},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"電話番号", @"title2":_inputDict[TEL_NUM], @"identifier":TEL_NUM, /*@"bgcolor":[UIColor lightGrayColor]*/},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"チェックイン予定時刻", @"title2":_inputDict[CHECKIN_TIME], @"identifier":CHECKIN_TIME, /*@"bgcolor":[UIColor lightGrayColor]*/},
                   @{@"cellName":@"Title2", @"type":@"ToyokoCustomCell", @"title":@"選択したオプション", @"identifier":@"options_room1"},
                   //TODO: handle the eco plan data conversion
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"連泊ECOプラン", @"title2":@"1/12, 1/14", @"identifier":@"option1_room1", /*@"bgcolor":[UIColor lightGrayColor]*/},
                   //TODO: handle the business pack data conversion
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"ビジネスパック", @"title2":@"ビジネスパック100", @"identifier":@"option2_room1", /*@"bgcolor":[UIColor lightGrayColor]*/},
                   //TODO: combine 2 prices into 1 line
                   @{@"cellName":@"TotalPrice", @"type":@"ToyokoPriceCell", @"str1":@"お支払金額",  @"str2":@"　29,500円（税込31,860）", @"identifier":@"price_total"},
                   @{@"cellName":@"Title1", @"type":@"ToyokoCustomCell", @"title":@"内訳", @"identifier":@"price_detail"},
                   //TODO: generate each day's price
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"1泊目(会員料金)", @"title2":@"7,000円", @"identifier":@"room1_night1_detail"},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"2泊目(会員料金)", @"title2":@"7,000円", @"identifier":@"room1_night2_detail"},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"オプション", @"title2":_inputDict[OPTION_PRICE], @"identifier":OPTION_PRICE},
                   //TODO: combine 2 prices into 1 line
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"小計", @"title2":@"14,200円\n(税込15,336円)", @"identifier":@"room1_total_detail"}
#endif
                   ]mutableCopy];
    
    CGRect r = [[UIScreen mainScreen] bounds];
    
    CGFloat newHeight = r.size.height - _containerView.frame.origin.y;
    
    r = _containerView.frame;
    r.size.height = newHeight;
    
    [_containerView setFrame:r]; //enlarge the container view to fit longer screen
    
    if(_targetTableVC)
    {
#if 0
        UITableView *tableView = _targetTableVC.tableView;
        if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        
        // Prevent the cell from inheriting the Table View's margin settings
        if ([tableView respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
            [tableView setPreservesSuperviewLayoutMargins:NO];
        }
        
        // Explictly set your cell's layout margins
        if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [tableView setLayoutMargins:UIEdgeInsetsZero];
        }
#endif
        [_targetTableVC reload:inputItems];
    }
    
    if(_inputDict[@"mdfyLckFlag"])
    {
        //modify lock is set, disable the 2 buttons
        if([_inputDict[@"mdfyLckFlag"] isEqualToString:@"1"]) {
            _ChangeButton.enabled = NO;
            _ChangeButton.hidden = !_ChangeButton.enabled;
            
            _CancelButton.enabled = NO;
            _CancelButton.hidden = !_CancelButton.enabled;
        }
        else
        {
            _ChangeButton.enabled = YES;
            _ChangeButton.hidden = !_ChangeButton.enabled;
            
            _CancelButton.enabled = YES;
            _CancelButton.hidden = !_CancelButton.enabled;
        }
    }
    else //flag not available, enable the 2 buttons by default
    {
        _ChangeButton.enabled = YES;
        _ChangeButton.hidden = !_ChangeButton.enabled;
        
        _CancelButton.enabled = YES;
        _CancelButton.hidden = !_CancelButton.enabled;
    }
    
    //To load the reservation detail
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if([ud stringForKey:PERSON_UID])
    {
        self.delegate = self;
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        dict[PERSON_UID] = [ud stringForKey:PERSON_UID];
        dict[RESERV_NUM] = _inputDict[RESERV_NUM];
        dict[HOTEL_CODE] = _inputDict[HOTEL_CODE];
        dict[RESERV_ID] = _inputDict[RESERV_ID];
        //dict[PAGE_NUM] = @"1"; //dummy
        
        [self addRequestFields:dict];
        [self setApiName:@"search_booking_details_api"];
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

- (IBAction)ChangePressed:(id)sender {
    reservChange *next = [self.storyboard instantiateViewControllerWithIdentifier:@"reservChange"];
    next.inputDict = _inputDict;
    next.receivedData = receivedData;
    [self presentViewController:next animated:YES completion:^ {
    }];
}

- (IBAction)CancelPressed:(id)sender {
    reservCancelConfirm *next = [self.storyboard instantiateViewControllerWithIdentifier:@"reservCancelConfirm"];
    next.inputDict = inputItems; //table data to show
    next.receivedData = receivedData; //dictionary used to post
    [self presentViewController:next animated:YES completion:^ {
    }];
}

- (IBAction)BackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)PrepareTableData:(NSMutableDictionary*)data
{
    NSString *member;
    receivedData = data;
    receivedData[RESERV_ID] = _inputDict[RESERV_ID];
    receivedData[HOTEL_CODE] = _inputDict[HOTEL_CODE];
    
    if([data[MEMBER_FLAG] isEqualToString:@"Y"])
        member = @"東横INNｸﾗﾌﾞｶｰﾄﾞ会員";
    else
        member = @"一般";
    
    NSString *smoking;
    if(data[SMOKING_FLAG] == nil)
        smoking = @"禁煙マーク";
    else
    {
        if([data[SMOKING_FLAG] isEqualToString:@"Y"])
            smoking = @"喫煙マーク";
        else
            smoking = @"禁煙マーク";
    }
    
    NSString *tmp = data[CHECKIN_TIME];
    NSString *checkinTime = [NSString stringWithFormat:@"%@:%@",[tmp substringWithRange:NSMakeRange(0, 2)],[tmp substringWithRange:NSMakeRange(2,2)]];
    if([checkinTime isEqualToString:@"00:00"]) //special case for 24:00
    {
        checkinTime = @"24:00";
    }
    
    NSArray *dailyInfo = data[@"dlyInfrmtn"];
    NSMutableString *ecoplan = [[NSMutableString alloc] init];
    
    int ecoCount =0;
    BOOL isEcoUsed = NO;
    //Count how many days applied with eco plan
    for(NSDictionary *dict in dailyInfo)
    {
        if([dict[ECO_FLAG] isEqualToString:@"Y"])
        {
            ecoCount++;
            isEcoUsed = YES;
        }
    }
    
    int i = 0;
    //Construct the ecoplan days string
    for(NSDictionary *dict in dailyInfo)
    {
        if([dict[ECO_FLAG] isEqualToString:@"Y"])
        {
            i++;
            NSString *targetDate = dict[TARGET_DATE];
            tmp = [NSString stringWithFormat:@"%@/%@", [targetDate substringWithRange:NSMakeRange(4,2)], [targetDate substringWithRange:NSMakeRange(6, 2)]];
            [ecoplan appendString:tmp];
            if(i < ecoCount)
                [ecoplan appendString:@", "];
        }
    }
    
    if([data[ECOPLAN_CHECKIN_SPECIFY] isEqualToString:@"Y"])
    {
        ecoplan = [@"チェックイン時指定" mutableCopy];
    }
    
    BOOL isBusiUsed = NO;
    NSString* busipak;
    
    if([data[BUSI_FLAG] isEqualToString:@"Y"])
    {
        isBusiUsed = YES;
        busipak = [NSString stringWithFormat:@"%@00",data[BUSI_TYPE]];
    }
    
    BOOL isSharedBedUsed = NO;
    if([data[SHARE_BED] isEqualToString:@"Y"])
        isSharedBedUsed = YES;
    
    BOOL isVodUsed = NO;
    if([data[VOD_FLAG] isEqualToString:@"Y"])
        isVodUsed = YES;
    
    NSUInteger nights = 0;
    
    if(data[NUM_NIGHTS] == nil) //nights not set
    {
        NSString *checkinDate = data[CHECKIN_DATE];
        NSString *checkoutDate = data[CHECKOUT_DATE];
        
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
        data[NUM_NIGHTS] = [NSNumber numberWithInteger:nights];
    }
    else
    {
        nights = [data[NUM_NIGHTS]integerValue];
    }
    
    NSString *nationality;
    if(data[NATIONALITY] == nil)
    {
        //the guest is assumed as Japanese by default
        nationality = [Constant NationalityNameFromCode:@"JPN" lang:@"ja"];
    }
    else if([data[NATIONALITY] isEqualToString:@""]) //empty item
    {
        nationality = [Constant NationalityNameFromCode:@"JPN" lang:@"ja"];
    }
    else
    {
        nationality = [Constant NationalityNameFromCode:data[NATIONALITY] lang:@"ja"];
    }
    
    NSString *roomName = data[ROOM_NAME];
    if(roomName == nil) //not existing
        roomName = @""; //avoid null pointer
    
    inputItems = [@[
                    @{@"cellName":@"Title0", @"type":@"ToyokoCustomCell", @"title":[NSString stringWithFormat:@"予約番号：%@",data[RESERV_NUM]], @"identifier":RESERV_NUM},
                    @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"宿泊日", @"title2":[NSString stringWithFormat:@"%@〜%ld泊", [Constant convertToLocalDate:data[CHECKIN_DATE]],(unsigned long)nights], @"identifier":CHECKIN_DATE},
                    @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"宿泊先", @"title2":data[HOTEL_NAME], @"identifier":HOTEL_NAME},
                    @{@"cellName":@"Button", @"type":@"ToyokoButtonCell", @"title":roomName, @"icon":smoking, @"buttonTitle":@"変更する", @"identifier":ROOM_NAME, @"hidden":@(YES)},
                    @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"ご利用人数", @"title2":[NSString stringWithFormat:@"%ld名（部屋あたり）",(unsigned long)[data[NUM_PEOPLE] integerValue]], @"identifier":NUM_PEOPLE},
                    @{@"cellName":@"Title2", @"type":@"ToyokoCustomCell", @"title":@"宿泊者情報", @"identifier":@"guest_room1"},
                    @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"姓(半角アルファベット)", @"title2":data[FAMILY_NAME], @"identifier":FAMILY_NAME, /*@"bgcolor":[UIColor lightGrayColor]*/},
                    @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"名(半角アルファベット)", @"title2":data[GIVEN_NAME], @"identifier":GIVEN_NAME, /*@"bgcolor":[UIColor lightGrayColor]*/},
                    @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"会員/一般", @"title2":member, @"identifier":MEMBER_FLAG,/* @"bgcolor":[UIColor lightGrayColor]*/},
                    @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"国籍", @"title2":nationality, @"identifier":NATIONALITY, /*@"bgcolor":[UIColor lightGrayColor]*/},
                    @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"性別", @"title2":[Constant GenderNameFromCode:data[GENDER] lang:@"ja"], @"identifier":GENDER, /*@"bgcolor":[UIColor lightGrayColor]*/},
                    @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"電話番号", @"title2":data[TEL_NUM], @"identifier":TEL_NUM /*@"bgcolor":[UIColor lightGrayColor]*/},
                    @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"チェックイン予定時刻", @"title2":checkinTime, @"identifier":CHECKIN_TIME /*@"bgcolor":[UIColor lightGrayColor]*/},
                    /*@{@"cellName":@"Title2", @"type":@"ToyokoCustomCell", @"title":@"選択したオプション", @"identifier":@"options_room1"}*/]mutableCopy];
    
    //add option title if at least one of the options is used
    if(isEcoUsed || isBusiUsed || isVodUsed || isSharedBedUsed)
    {
        [inputItems addObject:@{@"cellName":@"Title2", @"type":@"ToyokoCustomCell", @"title":@"選択したオプション", @"identifier":@"options"}];
    }
    
    if(isEcoUsed)
    {
        [inputItems addObject:@{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"連泊ECOプラン", @"title2":ecoplan, @"identifier":@"option1", /*@"bgcolor":[UIColor lightGrayColor]*/}];
    }
    
    if(isBusiUsed)
    {
        [inputItems addObject:@{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"ビジネスパック", @"title2":busipak, @"identifier":@"option2" /*@"bgcolor":[UIColor lightGrayColor]*/}];
    }
    
    if(isSharedBedUsed)
    {
        [inputItems addObject:@{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"お子様添い寝", @"title2":@"はい", @"identifier":@"option3" /*@"bgcolor":[UIColor lightGrayColor]*/}];
    }
    
    if(isVodUsed)
    {
        [inputItems addObject:@{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"VOD", @"title2":@"はい", @"identifier":@"option4" /*@"bgcolor":[UIColor lightGrayColor]*/}];
    }
#if 1
    if(data[RECEIPT_TYPE])
    {
        NSArray *types = @[@"",@"宿泊者",@"予約者",@"それ以外"];
        [inputItems addObject:@{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"領収書名義種別", @"title2":types[[data[RECEIPT_TYPE]intValue]], @"identifier":RECEIPT_TYPE /*@"bgcolor":[UIColor lightGrayColor]*/}];
    }
    if(data[RECEIPT_NAME])
    {
        [inputItems addObject:@{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"領収書名義", @"title2":data[RECEIPT_NAME], @"identifier":RECEIPT_NAME /*@"bgcolor":[UIColor lightGrayColor]*/}];
    }
#endif
#if 1 //plan added
    if(data[PLAN_NAME])
    {
        if([data[PLAN_CODE] isEqualToString:@"0000"])
        {
            [inputItems insertObject:@{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"プラン", @"title2":data[PLAN_NAME], @"identifier":PLAN_NAME /*@"bgcolor":[UIColor lightGrayColor]*/} atIndex:4];
        }
    }
#endif
    
    //Add total prices
    [inputItems addObject:@{@"cellName":@"TotalPrice", @"type":@"ToyokoPriceCell", @"str1":@"お支払金額",  @"str2":[NSString stringWithFormat:@"%@（税込%@）", data[TOTAL_PRICE], data[TOTAL_PRICE_TAX]], @"identifier":@"price_total"}];
    
    [inputItems addObject:@{@"cellName":@"Title1", @"type":@"ToyokoCustomCell", @"title":@"内訳", @"identifier":@"price_detail"}];
    
    //generate each day's price
    i = 1;
    NSString *priceType;
    if([data[MEMBER_FLAG] isEqualToString:@"Y"])
        priceType = @"会員料金";
    else
        priceType = @"一般料金";
    
    //each night price
    for(NSDictionary *dict in dailyInfo)
    {
        [inputItems addObject:@{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":[NSString stringWithFormat:@"%d泊目(%@)",i,priceType], @"title2":[NSString stringWithFormat:@"%@", dict[@"prc"]], @"identifier":[NSString stringWithFormat:@"night%d_detail", i]}];
        i++;
    }
    
    //option price
    [inputItems addObject:@{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"オプション", @"title2":[NSString stringWithFormat:@"%@",data[OPTION_PRICE]], @"identifier":OPTION_PRICE}];
    
    //summary
    [inputItems addObject:@{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"小計", @"title2":[NSString stringWithFormat:@"%@(税込%@)",data[TOTAL_PRICE], data[TOTAL_PRICE_TAX]], @"identifier":@"room1_total_detail"}];
}

-(void)ParsedDataReady:(NSDictionary*)data
{
    NSLog(@"data: %@", data);
    
    if([data[@"errrCode"] isEqualToString:@"BCMN0000"])
    {
        [self PrepareTableData:[data mutableCopy]];
#if 1
        [_targetTableVC reload:inputItems];
#endif
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
