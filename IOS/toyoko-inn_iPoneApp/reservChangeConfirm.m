//
//  reservChangeConfirm.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/08/12.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "reservChangeConfirm.h"
#import "reservDone.h"
#import "Constant.h"

@interface reservChangeConfirm ()

@end

@implementation reservChangeConfirm

static NSMutableArray *inputItems;

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
    
    NSString *smokingIcon;
    if([_receivedData[SMOKING_FLAG] isEqualToString:@"Y"])
    {
        smokingIcon = @"喫煙マーク";
    }
    else
    {
        smokingIcon = @"禁煙マーク";
    }
    
    NSArray *dailyInfo = _receivedData[@"dlyInfrmtn"];
    int num_nights = (int)dailyInfo.count;
    
    NSString *roomName = _receivedData[PLAN_NAME/*ROOM_NAME*/];
    if(roomName == nil) //avoid null pointer
        roomName = @"";
    
    NSString *memberFlag;
    memberFlag = _inputtedForm[@"room1_mmbrshpFlag"];
    if([memberFlag isEqualToString:@"Y"])
    {
        memberFlag = @"東横INNｸﾗﾌﾞｶｰﾄﾞ会員";
    }
    else
    {
        memberFlag = @"一般";
    }
    
    NSString *nationCode = _inputtedForm[@"room1_ntnltyCode"];
    NSString *gender = _inputtedForm[@"room1_sex"];
    NSString *checkinTime = _inputtedForm[@"room1_chcknTime"];
    
    NSString *ecoDates, *businessPak;
    NSString *ecoPlan = _inputtedForm[@"room1_ecoFlag"];
    if([ecoPlan isEqualToString:@"Y"])
    {
        NSString *keyword = @"room1_ecoDtsList";
        int j = 0;
        ecoDates = @"";
        NSMutableArray *dates = [[NSMutableArray alloc]init];
        
        while(1)
        {
            NSString *item = [NSString stringWithFormat:@"%@[%d]", keyword, j];
            NSString *date = _inputtedForm[item];
            if(date)
            {
                [dates addObject:date];
                j++;
            }
            else
            {
                break;
            }
        }
        
        ecoDates = [Constant genEcoDateStr:dates];
    }
    else
    {
        ecoDates = @"";
    }
    
    NSString *busiFlag = _inputtedForm[@"room1_bsnssPackFlag"];
    if([busiFlag isEqualToString:@"Y"])
    {
        businessPak = [NSString stringWithFormat:@"ビジネスパック%@00",_inputtedForm[@"room1_bsnssPackType"]];
    }
    else
    {
        businessPak = @"";
    }
    
    NSString *vodFlag = _inputtedForm[@"room1_vodFlag"];
    NSString *shareBedFlag = _inputtedForm[@"room1_chldrnShrngBed"];
    
    NSString *total_price = _priceDetail[TOTAL_PRICE];
    NSString *total_price_tax = _priceDetail[TOTAL_PRICE_TAX];
    
    inputItems = [[NSMutableArray alloc]init];
    
    [inputItems addObjectsFromArray:@[
                   //TODO: add localized title before reserv num
                   @{@"cellName":@"Title0", @"type":@"ToyokoCustomCell", @"title":[NSString stringWithFormat:@"予約番号：%@",_receivedData[RESERV_NUM]],   @"identifier":RESERV_NUM},
                   //TODO: combine checkin date and nights into 1 line
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"宿泊日", @"title2":[NSString stringWithFormat:@"%@〜%d泊",[Constant convertToLocalDate:_receivedData[CHECKIN_DATE]], num_nights], @"identifier":CHECKIN_DATE},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"宿泊先", @"title2":_receivedData[HOTEL_NAME], @"identifier":HOTEL_NAME},
                   //TODO: convert room type and smoking flag to icon
                   @{@"cellName":@"Button", @"type":@"ToyokoButtonCell", @"title":roomName, @"icon":smokingIcon, @"buttonTitle":@"変更する", @"identifier":ROOM_TYPE, @"hidden":@(YES)},
                   //TODO: add localized unit and description
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"ご利用人数", @"title2":[NSString stringWithFormat:@"%@名（部屋あたり）", _receivedData[NUM_PEOPLE]], @"identifier":NUM_PEOPLE},
                   @{@"cellName":@"Title2", @"type":@"ToyokoCustomCell", @"title":@"宿泊者情報", @"identifier":@"guest_room1"},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"姓(半角アルファベット)", @"title2":_inputtedForm[@"room1_fmlyName"], @"identifier":FAMILY_NAME, /*@"bgcolor":[UIColor lightGrayColor]*/},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"名(半角アルファベット)", @"title2":_inputtedForm[@"room1_frstName"], @"identifier":GIVEN_NAME, /*@"bgcolor":[UIColor lightGrayColor]*/},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"会員/一般", @"title2":memberFlag, @"identifier":MEMBER_FLAG,/* @"bgcolor":[UIColor lightGrayColor]*/},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"国籍", @"title2":[Constant NationalityNameFromCode:nationCode lang:@"ja"], @"identifier":NATIONALITY, /*@"bgcolor":[UIColor lightGrayColor]*/},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"性別", @"title2":[Constant GenderNameFromCode:gender lang:@"ja"], @"identifier":GENDER, /*@"bgcolor":[UIColor lightGrayColor]*/},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"電話番号", @"title2":_inputtedForm[@"room1_phnNmbr"], @"identifier":TEL_NUM, /*@"bgcolor":[UIColor lightGrayColor]*/},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"チェックイン予定時刻", @"title2":checkinTime, @"identifier":CHECKIN_TIME, /*@"bgcolor":[UIColor lightGrayColor]*/},
                   /*@{@"cellName":@"Title2", @"type":@"ToyokoCustomCell", @"title":@"選択したオプション", @"identifier":@"options_room1"}*/]];
    
    if([ecoPlan isEqualToString:@"Y"] ||
       [busiFlag isEqualToString:@"Y"] ||
       [vodFlag isEqualToString:@"Y"] ||
       [shareBedFlag isEqualToString:@"Y"])
    {
        [inputItems addObject:@{@"cellName":@"Title2", @"type":@"ToyokoCustomCell", @"title":@"選択したオプション", @"identifier":@"options_room1"}];
    }
    
    if([ecoPlan isEqualToString:@"Y"])
    {
        [inputItems addObject:@{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"連泊ECOプラン", @"title2":ecoDates, @"identifier":@"room1_ecoDtsList", /*@"bgcolor":[UIColor lightGrayColor]*/}];
    }
    
    if([busiFlag isEqualToString:@"Y"])
    {
        [inputItems addObject:@{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"ビジネスパック", @"title2":businessPak, @"identifier":@"room1_bsnssPackType", /*@"bgcolor":[UIColor lightGrayColor]*/}];
    }
    
    if([vodFlag isEqualToString:@"Y"])
    {
        [inputItems addObject:@{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"VOD", @"title2":@"", @"identifier":@"room1_vodFlag", /*@"bgcolor":[UIColor lightGrayColor]*/}];
    }
    
    if([shareBedFlag isEqualToString:@"Y"])
    {
        [inputItems addObject:@{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"お子様添い寝", @"title2":@"", @"identifier":@"room1_chldrnShrngBed", /*@"bgcolor":[UIColor lightGrayColor]*/}];
    }
    
    NSArray *template3 = @[
                   @{@"cellName":@"TotalPrice", @"type":@"ToyokoPriceCell", @"str1":@"お支払金額",  @"str2":[NSString stringWithFormat:@"　%@（税込%@）", total_price, total_price_tax], @"identifier":@"price_total"},
                   @{@"cellName":@"Title1", @"type":@"ToyokoCustomCell", @"title":@"内訳", @"identifier":@"price_detail"}];
    
    [inputItems addObjectsFromArray:template3];
     
    if([memberFlag isEqualToString:@"Y"])
    {
        memberFlag = @"会員";
    }
    else
    {
        memberFlag = @"一般";
    }
    
    NSString *identifer = [NSString stringWithFormat:@"room1_prcList"];
    NSArray *priceList = _priceDetail[identifer];
    
    for(int i=1;i<= num_nights; i++)
    {
        NSDictionary *priceDict = priceList[i-1];
        NSDictionary *template =
        @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":[NSString stringWithFormat:@"%d泊目(%@料金)", i, memberFlag], @"title2":priceDict[@"prc"], @"identifier":[NSString stringWithFormat:@"room1_night%d_detail",i]};
        [inputItems addObject:template];
        
    }
    NSArray *template2 = @[
                           @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"オプション", @"title2":_priceDetail[@"room1_optnPrc"], @"identifier":OPTION_PRICE},
                           @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"小計", @"title2":[NSString stringWithFormat:@"%@(税込%@)", _priceDetail[@"room1_sbttlPrc"], _priceDetail[@"room1_sbttlPrcIncldngTax"]], @"identifier":@"room1_total_detail"},
                           ];
    [inputItems addObjectsFromArray: template2];
#if 0
    CGRect r = [[UIScreen mainScreen] bounds];
    
    //change the Y coordinate of OK button for longer screen
    CGFloat newY = r.size.height - _OKButton.frame.size.height;
    CGRect btnRect = _OKButton.frame;
    btnRect.origin.y = newY;
    [_OKButton setFrame: btnRect];
    
    CGFloat newHeight = newY - _containerView.frame.origin.y;
    CGRect viewRect = _containerView.frame;
    viewRect.size.height = newHeight;
    [_containerView setFrame:viewRect];
#endif
    if(_targetTableVC)
    {
        [_targetTableVC reload:inputItems];
    }
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

- (IBAction)OKPressed:(id)sender {
    self.delegate = self;
    
    NSMutableDictionary *tmpDict = [_inputtedForm mutableCopy];
    
    NSArray *keys = @[@"room1_prcIncldngTaxList", @"room1_optnPrc", @"room1_sbttlPrcIncldngTax"];
    
    //fill the necessary items
    for(NSString *key in keys)
    {
        NSString *tmp = _priceDetail[key];
        if(tmp)
        {
            tmp = [[tmp componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
        }
        else
            tmp = @"0";
        
        tmpDict[key] = tmp;
    }
    
    NSString *ID = @"room1_chcknTime";
    NSString *checkinTime = tmpDict[ID];
    
    checkinTime = [[checkinTime componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
    checkinTime = [NSString stringWithFormat:@"%@00", checkinTime];
    tmpDict[ID] = checkinTime;
    
    tmpDict[@"room1_rsrvId"] = _receivedData[RESERV_ID];
    tmpDict[@"room1_rsrvtnNmbr"] = _receivedData[RESERV_NUM];
    tmpDict[@"room1_htlCode"] = tmpDict[HOTEL_CODE];
    
    [tmpDict removeObjectForKey:@"rsrvtnNmbr"];
    [tmpDict removeObjectForKey:TOTAL_PRICE_TAX];
    [tmpDict removeObjectForKey:HOTEL_CODE];
    
    [self addRequestFields:tmpDict];
    [self setApiName:@"change_reservation_api"];
    [self setSecure:NO];
    
    [self sendRequest];
}

- (IBAction)BackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)ParsedDataReady:(NSDictionary*)data
{
    NSLog(@"data: %@", data);
    
    if([data[@"errrCode"] isEqualToString:@"BCMN0000"])
    {
        NSLog(@"data: %@", data);
        
        if([data[@"errrCode"] isEqualToString:@"BCMN0000"])
        {
            NSDictionary *dict = @{@"room1_rsrv_nmbr":_receivedData[RESERV_NUM],
                                   @"room1_chcknDate":_receivedData[CHECKIN_DATE],
                                   @"room1_chcktDate":_receivedData[CHECKOUT_DATE]};
            reservDone *next = [self.storyboard instantiateViewControllerWithIdentifier:@"reservDone"];
            next.priceDetail = _priceDetail;
            next.resultDict = dict;
            next.inputDict = dict;
            next.htlName = _receivedData[HOTEL_NAME];
            next.num_rooms = @"1";
            next.isChangeMode = YES;
            
            [self presentViewController:next animated:YES completion:^{}];
        }
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
