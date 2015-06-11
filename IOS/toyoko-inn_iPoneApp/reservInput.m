//
//  reservInput.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/07/24.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "reservInput.h"
#import "Constant.h"
#import "AppDelegate.h"
#import "reservConfirm.h"

@interface reservInput ()

@end

@implementation reservInput

static NSMutableArray *inputItems;
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
    _OKButton.clipsToBounds = YES;
    _OKButton.layer.cornerRadius = 10;
    
    inputItems = [[NSMutableArray alloc]init];
    
    int num_people = [_inputDict[NUM_PEOPLE]intValue];
    int num_rooms = [_inputDict[NUM_ROOMS]intValue];
    int num_nights = [_inputDict[NUM_NIGHTS]intValue];
    int max_people = [_roomDict[MAX_PEOPLE]intValue];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *fmlyName = [ud stringForKey:FAMILY_NAME];
    NSString *givenName = [ud stringForKey:GIVEN_NAME];
    NSString *sex = [ud stringForKey:GENDER];
    NSString *nationCode = [ud stringForKey:NATIONALITY];
    
    int memberIndex;
    BOOL isMember = NO;
    NSString *memberNum;
    if([ud stringForKey:MEMBER_NUM])
    {
        memberIndex = 0;
        isMember = YES;
        memberNum = [ud stringForKey:MEMBER_NUM];
    }
    else
    {
        memberIndex = 1;
        isMember = NO;
        memberNum = @"";
    }
    
    NSString *smokingIcon;
    
    if([_roomDict[SMOKING_FLAG] isEqualToString:@"Y"])
    {
        smokingIcon = @"喫煙マーク";
    }
    else
    {
        smokingIcon = @"禁煙マーク";
    }
    
    BOOL isHideEco;
    if(num_nights == 1)
        isHideEco = YES;
    else
        isHideEco = NO;
    
    NSLog(@"input dict:%@", _inputDict);
    
    NSString *checkoutDate = [Constant calCheckoutDate:_inputDict[CHECKIN_DATE] nights:num_nights];
    
    [inputItems addObject:@{@"cellName":@"Title0", @"type":@"ToyokoCustomCell", @"title":_htlName, @"identifier":@"hotel title"}];
    [inputItems addObject:@{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"チェックイン", @"title2":[Constant convertToLocalDate:_inputDict[CHECKIN_DATE]], /*@"bgColor":[UIColor whiteColor], @"border":@[@"top", @"left", @"right"],*/ @"identifier":CHECKIN_DATE}];
    
    [inputItems addObject:@{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"チェックアウト", @"title2":checkoutDate/*@"2014年12月31日"*/, /*@"bgColor":[UIColor whiteColor], @"border":@[@"bottom", @"left", @"right"],*/ @"identifier":@"chcktDate"}];
    
    for(int i=1;i<=num_rooms;i++)
    {
    
        NSArray *template1 = @[
                              @{@"cellName":@"Title1", @"type":@"ToyokoCustomCell", @"title":[NSString stringWithFormat:@"お部屋%d", i], @"identifier":[NSString stringWithFormat:@"room%d", i], @"bgColor":[UIColor clearColor], @"border":@[@"top",  @"left", @"right"]},
                              @{@"cellName":@"Button", @"type":@"ToyokoButtonCell", @"title":_inputDict[PLAN_NAME]/*_roomDict[ROOM_NAME]*/, @"icon":smokingIcon, @"buttonTitle":@"変更する", @"action":NSStringFromSelector(@selector(BackToRoomList)), @"delegate":self, @"identifier":[NSString stringWithFormat:@"room%d_%@", i,ROOM_TYPE], @"bgColor":[UIColor whiteColor], @"border":@[@"left", @"right"]},
                              [@{@"cellName":@"Stepper", @"type":@"ToyokoStepperCell", @"title":@"ご利用人数", @"format":@"%d名", @"max":@(max_people), @"min":@(1), @"value":@(num_people), @"observer":self, @"identifier":[NSString stringWithFormat:@"room%d_%@",i, NUM_PEOPLE], @"bgColor":[UIColor whiteColor], @"border":@[@"left", @"right"]}mutableCopy],
                              @{@"cellName":@"Title2", @"type":@"ToyokoCustomCell", @"title":@"宿泊者情報", @"identifier":[NSString stringWithFormat:@"room%d_guest", i]}];
        [inputItems addObjectsFromArray:[template1 copy]];
        
        NSArray *template2;
        
        if(i==1) //the 1st room, the logged in user
        {
            template2= @[
                         [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"姓(半角アルファベット)",@"clear":@(YES), @"value":fmlyName, @"hint":@"例：TOYOKO", @"identifier":@"room1_fmlyName", @"valid":@"letter",  @"required":@(YES), @"bgColor":[UIColor whiteColor], @"border":@[@"left", @"right"]}mutableCopy],
                         [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"名(半角アルファベット)", @"value":givenName, @"hint":@"例：TARO", @"clear":@(YES), @"identifier":@"room1_frstName", @"valid":@"letter",  @"required":@(YES), @"bgColor":[UIColor whiteColor], @"border":@[@"left", @"right"]}mutableCopy],
                         //@{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"姓名は半角アルファベットで入力して下さい", @"color":[Constant AppRedColor], @"identifier":[NSString stringWithFormat:@"room%d_name_desc", i], @"bgColor":[UIColor whiteColor], @"border":@[@"left", @"right"]},
#if 0
                         [@{@"cellName":@"Segment", @"type":@"ToyokoSegmentCell", @"title":@"性別", @"choices":[Constant getGenderNames:@"ja"], @"value":[Constant GenderIndexFromCode:sex], @"identifier":@"room1_sex", @"required":@(YES),@"bgColor":[UIColor whiteColor], @"border":@[@"left", @"right"],}mutableCopy],
#else
                         [@{@"cellName":@"Picker", @"type":@"ToyokoPickerCell", @"title":@"性別", @"choices":[Constant getGenderNames:@"ja"], @"value":[Constant GenderIndexFromCode:sex], @"expanded":@(NO), @"minHeight":@(44), @"maxHeight":@(220), @"identifier":@"room1_sex", @"required":@(YES), @"bgColor":[UIColor whiteColor], @"border":@[@"left", @"right"]}mutableCopy],
#endif
                         [@{@"cellName":@"Segment", @"type":@"ToyokoSegmentCell", @"title":@"東横INNｸﾗﾌﾞｶｰﾄﾞ会員", @"choices":@[@"はい",@"いいえ"], @"value":@(memberIndex), @"observer":self, @"identifier":@"room1_mmbrshpFlag",@"bgColor":[UIColor whiteColor], @"border":@[@"left", @"right"],}mutableCopy],
                         [@{@"cellName":@"Text1", @"type":@"ToyokoTextCell", @"title":@"会員番号", @"clear":@(YES), @"value":memberNum,  @"identifier":@"room1_mmbrshpNmbr", @"required":@(NO),@"bgColor":[UIColor whiteColor], @"border":@[@"left", @"right"]}mutableCopy],
                         [@{@"cellName":@"Picker", @"type":@"ToyokoPickerCell", @"title":@"国籍", @"choices":[Constant getNationalityNames:@"ja"], @"value":[Constant NationalityIndexFromCode:nationCode], @"expanded":@(NO), @"minHeight":@(44), @"maxHeight":@(220), @"identifier":@"room1_ntnltyCode", @"required":@(YES),@"bgColor":[UIColor whiteColor], @"border":@[@"left", @"right"]}mutableCopy]];
        }
        else
        {
            template2= @[
                         [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"姓(半角アルファベット)", @"hint":@"例：TOYOKO", @"value":@"", @"identifier":[NSString stringWithFormat:@"room%d_fmlyName", i], @"clear":@(YES), @"valid":@"letter", @"upper":@(YES), @"required":@(YES), @"bgColor":[UIColor whiteColor], @"border":@[@"left", @"right"]}mutableCopy],
                         [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"名(半角アルファベット)", @"value":@"", @"hint":@"例：TARO", @"clear":@(YES), @"identifier":[NSString stringWithFormat:@"room%d_frstName", i], @"valid":@"letter", @"upper":@(YES), @"required":@(YES), @"bgColor":[UIColor whiteColor], @"border":@[@"left", @"right"]}mutableCopy],
                         //@{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"姓名は半角アルファベットで入力して下さい", @"color":[Constant AppRedColor], @"identifier":[NSString stringWithFormat:@"room%d_name_desc", i], @"bgColor":[UIColor whiteColor], @"border":@[@"left", @"right"]},
#if 0
                         [@{@"cellName":@"Segment", @"type":@"ToyokoSegmentCell", @"title":@"性別", @"choices":[Constant getGenderNames:@"ja"], @"value":@(0), @"identifier":[NSString stringWithFormat:@"room%d_sex", i], @"required":@(YES), @"bgColor":[UIColor whiteColor], @"border":@[@"left", @"right"]}mutableCopy],
#else
                         [@{@"cellName":@"Picker", @"type":@"ToyokoPickerCell", @"title":@"性別", @"choices":[Constant getGenderNames:@"ja"], @"value":@(0), @"expanded":@(NO), @"minHeight":@(44), @"maxHeight":@(220), @"identifier":[NSString stringWithFormat:@"room%d_sex", i], @"required":@(YES), @"bgColor":[UIColor whiteColor], @"border":@[@"left", @"right"]}mutableCopy],
#endif
                         [@{@"cellName":@"Segment", @"type":@"ToyokoSegmentCell", @"title":@"東横INNｸﾗﾌﾞｶｰﾄﾞ会員", @"choices":@[@"はい",@"いいえ"], @"value":@(1), @"observer":self, @"identifier":[NSString stringWithFormat:@"room%d_mmbrshpFlag", i], @"bgColor":[UIColor whiteColor], @"border":@[@"left", @"right"]} mutableCopy],
                         [@{@"cellName":@"Text1", @"type":@"ToyokoTextCell", @"title":@"会員番号", @"value":@"", @"clear":@(YES), @"identifier":[NSString stringWithFormat:@"room%d_mmbrshpNmbr", i], @"required":@(NO), @"bgColor":[UIColor whiteColor], @"border":@[@"left", @"right"]}mutableCopy],
                         [@{@"cellName":@"Picker", @"type":@"ToyokoPickerCell", @"title":@"国籍", @"choices":[Constant getNationalityNames:@"ja"], @"value":@(0), @"expanded":@(NO), @"minHeight":@(44), @"maxHeight":@(220), @"identifier":[NSString stringWithFormat:@"room%d_ntnltyCode", i], @"required":@(YES), @"bgColor":[UIColor whiteColor], @"border":@[@"left", @"right"]}mutableCopy]
                         ];
        }
        
        [inputItems addObjectsFromArray:[template2 copy]];
        
        NSArray *template3=@[
                             [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"電話番号", @"value":@"", @"identifier":[NSString stringWithFormat:@"room%d_phnNmbr",i],@"hint":@"例：09012345678", @"clear":@(YES), @"valid":@"decimal", @"required":@(YES), @"bgColor":[UIColor whiteColor], @"border":@[@"left", @"right"]/*@"secure":@(YES)*/}mutableCopy],
                             @{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"*当日連絡可能な番号を入力してください",@"color":[Constant AppRedColor], @"identifier":[NSString stringWithFormat:@"room%d_tel_desc", i],@"bgColor":[UIColor clearColor], @"border":@[@"left", @"right"]},
                             @{@"cellName":@"Title2", @"type":@"ToyokoCustomCell", @"title":@"オプション", @"identifier":[NSString stringWithFormat:@"room%d_option",i],/*@"bgColor":[UIColor whiteColor], @"border":@[@"left", @"right"]*/},];
        NSArray *temp_eco =@[
                             [@{@"cellName":@"Segment", @"type":@"ToyokoSegmentCell", @"title":@"連泊ECOプラン", @"choices":@[@"利用する",@"利用しない"], @"value":@(1), @"observer":self, @"identifier":[NSString stringWithFormat:@"room%d_ecoFlag", i],@"bgColor":[UIColor whiteColor], @"hidden":@(isHideEco), @"border":@[@"left", @"right"]}mutableCopy],
                             [@{@"cellName":@"EcoplanCell", @"type":@"ToyokoEcoplanCell", @"dates":[Constant genEcoDates:_inputDict[CHECKIN_DATE] nights:num_nights], @"observer":self, @"identifier":[NSString stringWithFormat:@"room%d_ecoDtsList",i], @"ecoChckn":@(NO), @"bgColor":[UIColor whiteColor], @"border":@[@"left", @"right"], @"hidden":@(YES)} mutableCopy],
                             @{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"お部屋の清掃、ナイトウェア、シーツ類の交換、アメニティグッズの補充を省かせていただきその分宿泊料金が2泊目以降、1泊につき300円お安くなります。", @"identifier":[NSString stringWithFormat:@"room%d_ecoplan_desc",i],@"bgColor":[UIColor whiteColor], @"hidden":@(isHideEco), @"border":@[@"left", @"right"]},
                             ];
        NSArray *temp_vod =@[
                             [@{@"cellName":@"Segment", @"type":@"ToyokoSegmentCell", @"title":@"VOD (+500円)", @"choices":@[@"利用する",@"利用しない"], @"value":@(1), @"observer":self, @"identifier":[NSString stringWithFormat:@"room%d_vodFlag",i], @"bgColor":[UIColor whiteColor], @"border":@[@"left", @"right"]}mutableCopy],
                             @{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"500円（税込）で200以上のコンテンツ見放題！", @"identifier":[NSString stringWithFormat:@"room%d_vod_desc",i], @"bgColor":[UIColor whiteColor], @"border":@[@"left", @"right"]},
                             ];
        NSArray *temp_bp =@[
                             [@{@"cellName":@"Segment", @"type":@"ToyokoSegmentCell", @"title":@"ビジネスパック", @"choices":@[@"利用する",@"利用しない"], @"value":@(1), @"observer":self, @"identifier":[NSString stringWithFormat:@"room%d_bsnssPackFlag",i], @"bgColor":[UIColor whiteColor], @"border":@[@"left", @"right"]}mutableCopy],
                             [@{@"cellName":@"Busipak", @"type":@"ToyokoBusiPak", @"format1":@"ビジネスパック%@", @"format2":@"(%@円分のVISAギフトカード付き)", @"values1":@[@(100), @(200), @(300)], @"values2":@[@(1000), @(2000), @(3000)],@"observer":self, @"identifier":[NSString stringWithFormat:@"room%d_bsnssPackType", i], @"bgColor":[UIColor whiteColor], @"value":@(0), @"border":@[@"left", @"right"], @"hidden":@(YES)} mutableCopy],
                             @{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"宿泊にVISAギフトカードをつけることができます。領収書の金額はセット料金でお出しします。", @"identifier":[NSString stringWithFormat:@"room%d_busi_desc",i], @"bgColor":[UIColor whiteColor], @"border":@[@"left", @"right"]},
                             ];
#if 0
                             [@{@"cellName":@"Segment", @"type":@"ToyokoSegmentCell", @"title":@"出張パック", @"choices":@[@"利用する",@"利用しない"], @"value":@(0), @"identifier":@"busitrip_room1"}mutableCopy],
                             [@{@"cellName":@"Busipak", @"type":@"ToyokoBusiPak", @"format1":@"出張パック%@", @"format2":@"(%@円分のVISAギフトカード+VOD付き)", @"values1":@[@(100), @(200), @(300)], @"values2":@[@(1000), @(2000), @(3000)], @"identifier":@"busitrippak_room1"} mutableCopy],
                             @{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"宿泊にVISAギフトカードをつけることができます。領収書の金額はセット料金でお出しします。", @"identifier":@"busitrip_desc_room1"},
#endif
        NSArray *temp_bedshare =@[
                             [@{@"cellName":@"Segment", @"type":@"ToyokoSegmentCell", @"title":@"お子様添い寝", @"choices":@[@"あり",@"なし"], @"value":@(1), @"identifier":[NSString stringWithFormat:@"room%d_chldrnShrngBed",i], @"bgColor":[UIColor whiteColor], @"border":@[@"left", @"right"]}mutableCopy],
                             @{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"小学生以下のお子様が大人と同じベッドで添い寝する場合、1つのベッドにつきお子様1名様まで無料で添い寝可能です。添い寝されるお子様がいる場合は「あり」にしてください。添い寝のお子様のアメニティグッズ、タオル、枕等は付きません。ご利用の場合は、別途料金がかかります。", @"identifier":[NSString stringWithFormat:@"room%d_childfree_desc",i], @"bgColor":[UIColor clearColor], @"border":@[@"left", @"right"]},
                             ];
        NSArray *receipt = @[
                             [@{@"cellName":@"Picker", @"type":@"ToyokoPickerCell", @"title":@"領収書名義種別", @"choices":@[@"宿泊者",@"予約者",@"それ以外"], @"value":@(0), @"expanded":@(NO), @"minHeight":@(44), @"maxHeight":@(220), @"identifier":[NSString stringWithFormat:@"room%d_%@",i, RECEIPT_TYPE], @"required":@(YES),@"bgColor":[UIColor whiteColor], @"border":@[@"left", @"right"]}mutableCopy],
                             [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"領収書名義", @"value":@"", @"identifier":[NSString stringWithFormat:@"room%d_%@",i, RECEIPT_NAME], @"clear":@(YES), @"bgColor":[UIColor whiteColor], @"border":@[@"left", @"right"]}mutableCopy]
                             ];
        
        NSArray *temp_checkintime =@[
                                     [@{@"cellName":@"Picker", @"type":@"ToyokoPickerCell", @"title":@"ﾁｪｯｸｲﾝ予定時刻", @"choices":[Constant getCheckinTimeList:isMember], @"value":@(0), @"expanded":@(NO), @"minHeight":@(44), @"maxHeight":@(220), @"identifier":[NSString stringWithFormat:@"room%d_chcknTime",i], @"bgColor":[UIColor whiteColor], @"border":@[@"bottom", @"left", @"right"],@"required":@(YES), @"bgColor":[UIColor whiteColor], @"border":@[@"bottom", @"left", @"right"]}mutableCopy],
                             //new added for space between each room input
                             @{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@" ", @"identifier":[NSString stringWithFormat:@"room%d_space",i]},
                             ];
        
        [inputItems addObjectsFromArray:[template3 copy]];
        if([_roomDict[ECO_AVAIL] isEqualToString:@"Y"])
            [inputItems addObjectsFromArray:[temp_eco copy]];
        
        if([_roomDict[VOD_AVAIL] isEqualToString:@"Y"])
            [inputItems addObjectsFromArray:[temp_vod copy]];
        
        if([_roomDict[BP_AVAIL] isEqualToString:@"Y"])
            [inputItems addObjectsFromArray:[temp_bp copy]];
        
        if([_roomDict[BEDSHARE_AVAIL] isEqualToString:@"Y"])
            [inputItems addObjectsFromArray:[temp_bedshare copy]];
        
        [inputItems addObjectsFromArray:[receipt copy]];
        [inputItems addObjectsFromArray:[temp_checkintime copy]];
    }
    
#if 1
    NSArray *template4 = @[
                           [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"クレジットカード名義", @"value":@"", @"identifier":@"crdtCardHldr",@"hint":@"例：TARO TOYOKO", @"clear":@(YES), @"required":@(YES), /*@"bgColor":[UIColor whiteColor], @"border":@[@"left", @"right"]*//*@"secure":@(YES)*/}mutableCopy],
                           [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"クレジットカード番号(ﾊｲﾌﾝ無し)", @"value":@"", @"identifier":@"crdtCardNmbr",@"hint":@"例：1234567890123456", @"valid":@"decimal", @"clear":@(YES), @"required":@(YES), /*@"bgColor":[UIColor whiteColor], @"border":@[@"left", @"right"]*/ /*@"secure":@(YES)*/}mutableCopy],
                           [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"クレジットカード有効期限(月年)", @"value":@"", @"identifier":@"crdtCardexprtnDate",@"hint":@"例：1214", @"valid":@"decimal", @"clear":@(YES), @"required":@(YES), /*@"bgColor":[UIColor whiteColor], @"border":@[@"left", @"right"]*/ /*@"secure":@(YES)*/}mutableCopy],
                           ];
    
    if(_htlDict[NOSHOW_CARD_FLAG])
    {
        if([_htlDict[NOSHOW_CARD_FLAG] isEqualToString:@"Y"])
            [inputItems addObjectsFromArray:[template4 copy]];
    }
    
    
#endif
    
    NSString *totalPrice, *totalPriceTax;
    if(memberIndex == 0) //logged user is member
    {
        totalPrice = _roomDict[@"ttlMmbrPrc"];
        totalPriceTax = _roomDict[@"ttlMmbrPrcIncldngTax"];
    }
    else
    {
        totalPrice = _roomDict[@"ttlListPrc"];
        totalPriceTax = _roomDict[@"ttlListPrcIncldngTax"];
    }
    
    NSMutableDictionary *total_price=[@{@"cellName":@"TotalPrice", @"type":@"ToyokoPriceCell", @"str1":@"お支払金額",  @"str2":[NSString stringWithFormat:@"　%@（税込%@）", totalPrice, totalPriceTax], @"identifier":@"price_total"}mutableCopy];
    
    [inputItems addObject:total_price];
#if 0
    CGRect r = [[UIScreen mainScreen] bounds];
    
    [_OKButton setFrame:CGRectMake(_OKButton.frame.origin.x, r.size.height-_OKButton.frame.size.height,_OKButton.frame.size.width, _OKButton.frame.size.height)];
    [_contaierView setFrame:CGRectMake(_contaierView.frame.origin.x, _contaierView.frame.origin.y,
                                        _contaierView.frame.size.width, r.size.height-_contaierView.frame.origin.y-_OKButton.frame.size.height)];
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
#if 0
        if ([tableview respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableview setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([tableview respondsToSelector:@selector(setLayoutMargins:)]) {
            [tableview setLayoutMargins:UIEdgeInsetsZero];
        }
#endif
#endif
        _targetTableVC.removeSeparator = YES;
        [_targetTableVC reload:inputItems];
    }
    
    //to reload the price if num of rooms is greater than 1
    if(num_rooms > 1)
    {
        [self RecalculatePrice];
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

- (IBAction)BackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

//return YES if required items are all available; return NO elsewise
-(BOOL)GetInput:(NSMutableDictionary*)dict required:(BOOL)required
{
    UIAlertView *alert;
    
    NSString *VALUE = @"value";
    NSString *ID = @"identifier";
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
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
#if 1
                    //To scroll to the 1st item not inputted
                    NSString *identifier = item[ID];
                    NSInteger index = [_targetTableVC findRowIndex:identifier];
                    [_targetTableVC.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                    NSString *title = item[@"title"];
                    NSString *roomName = [identifier componentsSeparatedByString:@"_"][0];
                    NSString *roomIndex = [roomName substringFromIndex:4];
                    NSString *alertMsg = [NSString stringWithFormat:@"お部屋%@の%@が未入力です。", roomIndex, title];
#endif
                    alert =
#if 1
                    [[UIAlertView alloc] initWithTitle:@"確認" message:alertMsg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
#else
                    [[UIAlertView alloc] initWithTitle:@"確認" message:@"未入力の必須項目があります。ご確認ください。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
#endif
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
    
    int num_rooms = [_inputDict[NUM_ROOMS]intValue];
    int num_nights = [_inputDict[NUM_NIGHTS]intValue];
    NSString *checkoutDate = [Constant calCheckoutDate2:_inputDict[CHECKIN_DATE] nights:num_nights];
    
    NSArray *YNItems = @[@"room%d_vodFlag", @"room%d_ecoFlag", @"room%d_mmbrshpFlag", @"room%d_bsnssPackFlag", @"room%d_chldrnShrngBed"];
    
    for(int i=1; i<=num_rooms; i++)
    {
        NSString *identifier;
        
        //handle sex
        identifier = [NSString stringWithFormat:@"room%d_sex",i];
        NSUInteger index = [[_targetTableVC findRow:identifier][VALUE] integerValue];
        dict[identifier] = [Constant getGenderCode:index];
        
        //plan code
        identifier = [NSString stringWithFormat:@"room%d_%@",i, PLAN_CODE];
        dict[identifier] = _inputDict[PLAN_CODE];
        
        //handle Y/N items
        for(NSString *key in YNItems)
        {
            identifier = [NSString stringWithFormat:key, i];
            if(![_targetTableVC findRow:identifier]) //not found
            {
                dict[identifier] = @"N"; //N as default value
                continue;
            }
            
            index = [[_targetTableVC findRow:identifier][VALUE] integerValue];
            if(index == 0)
                dict[identifier] = @"Y";
            else
                dict[identifier] = @"N";
        }
        NSString *memberFlag = [NSString stringWithFormat:@"room%d_mmbrshpFlag", i];
        if([dict[memberFlag] isEqualToString:@"Y"])
        {
            NSString *memberNum = [NSString stringWithFormat:@"room%d_mmbrshpNmbr", i];
            //member number is a required item
            if([dict[memberNum] isEqualToString:@""] && required)
            {
                NSString *alertMsg = [NSString stringWithFormat:@"お部屋%dの会員番号が未入力です。", i];
                UIAlertView *alert =
                [[UIAlertView alloc] initWithTitle:@"確認" message:alertMsg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
                return NO;
            }
        }
        
        //handle picker items
        identifier = [NSString stringWithFormat:@"room%d_ntnltyCode", i];
        index = [[_targetTableVC findRow:identifier][VALUE] integerValue];
        dict[identifier] = [Constant getNationalityCode:index];
        
        identifier = [NSString stringWithFormat:@"room%d_chcknTime", i];
        index = [[_targetTableVC findRow:identifier][VALUE] integerValue];
        NSArray *checkinTimes = [_targetTableVC findRow:identifier][@"choices"];
        dict[identifier] = checkinTimes[index];
        
        //receipt type/name
        identifier = [NSString stringWithFormat:@"room%d_%@", i, RECEIPT_TYPE];
        index = [[_targetTableVC findRow:identifier][VALUE] integerValue];
        index = index + 1; //parameter starts from 1
        dict[identifier] = [NSString stringWithFormat:@"%lu", (unsigned long)index];
        if(index == 3) //other name
        {
            identifier = [NSString stringWithFormat:@"room%d_%@", i, RECEIPT_NAME];
            NSString *receipt_name = [_targetTableVC findRow:identifier][VALUE];
            if(receipt_name.length == 0)
            {
                NSString *alertMsg = [NSString stringWithFormat:@"お部屋%dの領収書名義が未入力です。", i];
                UIAlertView *alert =
                [[UIAlertView alloc] initWithTitle:@"確認" message:alertMsg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
                return NO;
            }
            
            dict[identifier] = receipt_name;
        }        
        
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
        dict[identifier] = _inputDict[CHECKIN_DATE];
        
        identifier = [NSString stringWithFormat:@"room%d_chcktDate", i];
        dict[identifier] = checkoutDate;
        
        identifier = [NSString stringWithFormat:@"room%d_roomType", i];
        dict[identifier] = /*_roomDict[ROOM_TYPE];*/appDelegate.reservData[ROOM_TYPE];
        
        //stepper item
        identifier = [NSString stringWithFormat:@"room%d_%@",i, NUM_PEOPLE];
        index = [[_targetTableVC findRow:identifier][VALUE] integerValue];
        dict[identifier] = [NSString stringWithFormat:@"%lu", (unsigned long)index];
    }
    
    //fill other items
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    dict[PERSON_UID] = [ud stringForKey:PERSON_UID];
    dict[NUM_ROOMS] = _inputDict[NUM_ROOMS];
    
    dict[HOTEL_CODE] = appDelegate.reservData[HOTEL_CODE];
    
    //dummy total price
    dict[TOTAL_PRICE_TAX] = @"0";

    return YES;
}

- (IBAction)OKPressed:(id)sender {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    if(![self GetInput:dict required:YES]) //failed, some required items are empty
    {
        return;
    }
    
    inputtedForm = [dict mutableCopy]; //keep the retrieved data

    dict[@"mode"] = @"1"; //new added parameter for price calculation/real check switch
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

    if([data[@"errrCode"] isEqualToString:@"BCMN0000"])
    {
        if(!isGettingPrice)
        {
            reservConfirm *next = [self.storyboard instantiateViewControllerWithIdentifier:@"reservConfirm"];
            next.inputtedForm = inputtedForm;
            next.inputDict = _inputDict;
            next.roomDict = _roomDict;
            next.htlDict = _htlDict;
            next.htlName = _htlName;
            next.priceDetail = data;
            
            //[_targetTableVC UnhookObserver];
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
    [self RecalculatePrice];
    
    NSString *busipak = @"bsnssPackFlag";
    NSString *ecoplan = @"ecoFlag";
    NSString *membership= @"mmbrshpFlag";
    
    BOOL isMatched = NO;

    NSArray *keys = @[busipak, ecoplan, membership];
    
    NSMutableDictionary *dict = (NSMutableDictionary*)object;
    NSString *identifier = dict[@"identifier"];
    
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
            NSInteger value = [dict[@"value"] integerValue];
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

//new added for booking check request
-(void)RecalculatePrice
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    if([self GetInput:dict required:NO] == NO)//non required item is incorrect
        return;
    
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
    
    //send the data to reservation check
    self.delegate = self;
    [self addRequestFields:dict];
    [self setApiName:@"check_booking_api"];
    [self setSecure:NO];
    
    isGettingPrice = YES;
    [self sendRequest];
}

-(void)BackToRoomList
{
    UIViewController *ToVC = self.presentingViewController;
    while(ToVC != nil)
    {
        if ([NSStringFromClass([ToVC class]) isEqualToString:@"RoomTypeList"])
        {
            break;
        }
        ToVC = ToVC.presentingViewController;
    }
    
    if(ToVC!=nil)
    {
        [ToVC dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)connectionFailed:(NSError*)error
{
}
@end
