//
//  reservConfirm.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/08/07.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "reservConfirm.h"
#import "Constant.h"
#import "reservDone.h"

@interface reservConfirm ()

@end

@implementation reservConfirm
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
    NSArray *buttons = @[_ModifyButton, _ConfirmButton];
    for(UIButton *btn in buttons)
    {
        btn.clipsToBounds = YES;
        btn.layer.cornerRadius = 10;
        btn.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        [btn.imageView setContentMode: UIViewContentModeCenter];
    }
    
    
    inputItems = [[NSMutableArray alloc]init];
    
    int num_people = [_inputDict[NUM_PEOPLE]intValue];
    int num_rooms = [_inputDict[NUM_ROOMS]intValue];
    int num_nights = [_inputDict[NUM_NIGHTS]intValue];
    //int max_people = [_roomDict[NUM_PEOPLE]intValue];
    
    NSString *checkoutDate = [Constant calCheckoutDate:_inputDict[CHECKIN_DATE] nights:num_nights];
    
    NSString *smokingIcon;
    if([_roomDict[SMOKING_FLAG] isEqualToString:@"Y"])
    {
        smokingIcon = @"喫煙マーク";
    }
    else
    {
        smokingIcon = @"禁煙マーク";
    }
    
    [inputItems addObjectsFromArray:@[
                   @{@"cellName":@"Title0", @"type":@"ToyokoCustomCell", @"title":_htlName, @"identifier":HOTEL_NAME},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"チェックイン", @"title2":[Constant convertToLocalDate:_inputDict[CHECKIN_DATE]], @"identifier":CHECKIN_DATE},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"チェックアウト", @"title2":checkoutDate, @"identifier":@"checkout"}]];
    for(int i=1; i<= num_rooms;i++)
    {
        NSString *memberFlag;
        memberFlag = _inputtedForm[[NSString stringWithFormat:@"room%d_mmbrshpFlag", i]];
        if([memberFlag isEqualToString:@"Y"])
        {
            memberFlag = @"東横INNｸﾗﾌﾞｶｰﾄﾞ会員";
        }
        else
        {
            memberFlag = @"一般";
        }
        
        NSString *nationCode = _inputtedForm[[NSString stringWithFormat:@"room%d_ntnltyCode", i]];
        NSString *gender = _inputtedForm[[NSString stringWithFormat:@"room%d_sex", i]];
        NSString *telnum = _inputtedForm[[NSString stringWithFormat:@"room%d_phnNmbr",i]];
        NSString *checkinTime = _inputtedForm[[NSString stringWithFormat:@"room%d_chcknTime",i]];
        
        NSString *ecoDates, *businessPak;
        NSString *ecoPlan = _inputtedForm[[NSString stringWithFormat:@"room%d_ecoFlag", i]];
        if([ecoPlan isEqualToString:@"Y"])
        {
            NSString *keyword = [NSString stringWithFormat:@"room%d_ecoDtsList", i];
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
        
        NSString *busiFlag = _inputtedForm[[NSString stringWithFormat:@"room%d_bsnssPackFlag",i]];
        if([busiFlag isEqualToString:@"Y"])
        {
            businessPak = [NSString stringWithFormat:@"ビジネスパック%@00",_inputtedForm[[NSString stringWithFormat:@"room%d_bsnssPackType", i]]];
        }
        else
        {
            businessPak = @"";
        }
        
        NSString *vodFlag = _inputtedForm[[NSString stringWithFormat:@"room%d_vodFlag",i]];
        NSString *shareBedFlag = _inputtedForm[[NSString stringWithFormat:@"room%d_chldrnShrngBed", i]];
        
        NSString *receipt_type = _inputtedForm[[NSString stringWithFormat:@"room%d_%@", i, RECEIPT_TYPE]];
        NSString *receipt_name = @"";
        if([receipt_type isEqualToString:@"1"])
        {
            receipt_name = @"宿泊者";
        }
        else if([receipt_type isEqualToString:@"2"])
        {
            receipt_name = @"予約者";
        }
        else //type 3
        {
            receipt_name = _inputtedForm[[NSString stringWithFormat:@"room%d_%@", i, RECEIPT_NAME]];
        }
        
        NSArray *template1 = @[
                               @{@"cellName":@"Title1", @"type":@"ToyokoCustomCell", @"title":[NSString stringWithFormat:@"お部屋%d", i], @"identifier":[NSString stringWithFormat:@"room%d",i], @"bgColor":[UIColor clearColor], @"border":@[@"top",  @"left", @"right"]},
                               @{@"cellName":@"Button", @"type":@"ToyokoButtonCell", @"title":_inputDict[PLAN_NAME]/*_roomDict[ROOM_NAME]*/, @"icon":smokingIcon, @"buttonTitle":@"変更する", @"identifier":[NSString stringWithFormat:@"room%d_%@",i,ROOM_TYPE], @"hidden":@(YES), @"bgColor":[UIColor clearColor], @"border":@[@"left", @"right"]},
                               @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"ご利用人数", @"title2":[NSString stringWithFormat:@"%d名（部屋あたり）",num_people], @"identifier":[NSString stringWithFormat:@"room%d_%@",i, NUM_PEOPLE], @"bgColor":[UIColor clearColor], @"border":@[@"left", @"right"]},
                               @{@"cellName":@"Title2", @"type":@"ToyokoCustomCell", @"title":@"宿泊者情報", @"identifier":[NSString stringWithFormat:@"room%d_guest", i], @"bgColor":[UIColor clearColor], @"border":@[@"left", @"right"]},
                               @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"姓(半角アルファベット)", @"title2":_inputtedForm[[NSString stringWithFormat:@"room%d_fmlyName", i]], @"identifier":[NSString stringWithFormat:@"room%d_fmlyName", i], @"bgColor":[UIColor clearColor], @"border":@[@"left", @"right"]},
                               @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"名(半角アルファベット)", @"title2":_inputtedForm[[NSString stringWithFormat:@"room%d_frstName", i]], @"identifier":[NSString stringWithFormat:@"room%d_frstName", i], @"bgColor":[UIColor clearColor], @"border":@[@"left", @"right"]},
                               @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"会員/一般", @"title2":memberFlag, @"identifier":[NSString stringWithFormat:@"room%d_mmbrshpFlag", i], @"bgColor":[UIColor clearColor], @"border":@[@"left", @"right"]},
                               @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"国籍", @"title2":[Constant NationalityNameFromCode:nationCode lang:@"ja"], @"identifier":[NSString stringWithFormat:@"room%d_ntnltyCode", i], @"bgColor":[UIColor clearColor], @"border":@[@"left", @"right"]},
                               @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"性別", @"title2":[Constant GenderNameFromCode:gender lang:@"ja"], @"identifier":[NSString stringWithFormat:@"room%d_sex", i], @"bgColor":[UIColor clearColor], @"border":@[@"left", @"right"]},
                               @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"電話番号", @"title2":telnum, @"identifier":[NSString stringWithFormat:@"room%d_phnNmbr",i], @"bgColor":[UIColor clearColor], @"border":@[@"left", @"right"]},
                               @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"領収書名義", @"title2":receipt_name, @"identifier":[NSString stringWithFormat:@"room%d_%@",i,RECEIPT_NAME], @"bgColor":[UIColor clearColor], @"border":@[@"left", @"right"]},
                               @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"チェックイン予定時刻", @"title2":checkinTime, @"identifier":[NSString stringWithFormat:@"room%d_chcknTime",i], @"bgColor":[UIColor clearColor], @"border":@[@"left", @"right"]},
                               /*@{@"cellName":@"Title2", @"type":@"ToyokoCustomCell", @"title":@"選択したオプション", @"identifier":[NSString stringWithFormat:@"room%d_options",i], @"bgColor":[UIColor clearColor], @"border":@[@"left", @"right"]}*/];
        [inputItems addObjectsFromArray:template1];
        
        if([ecoPlan isEqualToString:@"Y"] ||
           [busiFlag isEqualToString:@"Y"] ||
           [vodFlag isEqualToString:@"Y"] ||
           [shareBedFlag isEqualToString:@"Y"])
        {
            [inputItems addObject:@{@"cellName":@"Title2", @"type":@"ToyokoCustomCell", @"title":@"選択したオプション", @"identifier":[NSString stringWithFormat:@"room%d_options",i], @"bgColor":[UIColor clearColor], @"border":@[@"left", @"right"]}];
        }
        
        if([ecoPlan isEqualToString:@"Y"])
        {
            [inputItems addObject:@{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"連泊ECOプラン", @"title2":ecoDates, @"identifier":[NSString stringWithFormat:@"room%d_ecoDtsList",i], @"bgColor":[UIColor clearColor], @"border":@[@"left", @"right"]}];
        }
        if([busiFlag isEqualToString:@"Y"])
        {
            [inputItems addObject:@{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"ビジネスパック", @"title2":businessPak, @"identifier":[NSString stringWithFormat:@"room%d_bsnssPackType", i], @"bgColor":[UIColor clearColor], @"border":@[@"left", @"right"]}];
        }
        if([vodFlag isEqualToString:@"Y"])
        {
            [inputItems addObject:@{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"VOD", @"title2":@"", @"identifier":[NSString stringWithFormat:@"room%d_vodFlag", i], @"bgColor":[UIColor clearColor], @"border":@[@"left", @"right"]}];
        }
        if([shareBedFlag isEqualToString:@"Y"])
        {
            [inputItems addObject:@{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"お子様添い寝", @"title2":@"", @"identifier":[NSString stringWithFormat:@"room%d_chldrnShrngBed", i], @"bgColor":[UIColor clearColor], @"border":@[@"left", @"right"]}];
        }
        
        //new added for space between each room input
        [inputItems addObject:@{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@" ", @"identifier":[NSString stringWithFormat:@"room%d_bottom",i], @"bgColor":[UIColor clearColor], @"border":@[@"bottom", @"left", @"right"]}];
        [inputItems addObject:@{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@" ", @"identifier":[NSString stringWithFormat:@"room%d_space",i]}];
    }
    
    NSString *total_price = _priceDetail[TOTAL_PRICE];
    NSString *total_price_tax = _priceDetail[TOTAL_PRICE_TAX];
    NSArray *template3 = @[
                           @{@"cellName":@"TotalPrice", @"type":@"ToyokoPriceCell", @"str1":@"お支払金額",  @"str2":[NSString stringWithFormat:@"　%@（税込%@）", total_price, total_price_tax], @"identifier":@"price_total"},
                           @{@"cellName":@"Title1", @"type":@"ToyokoCustomCell", @"title":@"内訳", @"identifier":@"price_detail"}];
    
    [inputItems addObjectsFromArray:template3];
    
    for(int i=1;i<=num_rooms;i++)
    {
        NSDictionary *template4 =
        @{@"cellName":@"Title2", @"type":@"ToyokoCustomCell", @"title":[NSString stringWithFormat:@"部屋%d", i], @"identifier":[NSString stringWithFormat:@"room%d_detail",i]};
        
        [inputItems addObject:template4];
        
        NSString *memberFlag;
        memberFlag = _inputtedForm[[NSString stringWithFormat:@"room%d_mmbrshpFlag", i]];
        if([memberFlag isEqualToString:@"Y"])
        {
            memberFlag = @"会員";
        }
        else
        {
            memberFlag = @"一般";
        }

        NSString *identifer = [NSString stringWithFormat:@"room%d_prcList",i];
        NSArray *priceList = _priceDetail[identifer];
        
        for (int j=1; j<=num_nights; j++) {
            NSDictionary *priceDict = priceList[j-1];
            
            NSDictionary *template5 =
            @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":[NSString stringWithFormat:@"%d泊目(%@料金)",j,memberFlag], @"title2":priceDict[@"prc"], @"identifier":[NSString stringWithFormat:@"room%d_night%d_detail",i,j]};
            
            [inputItems addObject:template5];
        }
        
        identifer = [NSString stringWithFormat:@"room%d_optnPrc",i];
        NSString *optionalPrice = _priceDetail[identifer];
        identifer = [NSString stringWithFormat:@"room%d_sbttlPrc",i];
        NSString *subTotal = _priceDetail[identifer];
        identifer = [NSString stringWithFormat:@"room%d_sbttlPrcIncldngTax",i];
        NSString *subTotalTax = _priceDetail[identifer];
        
        NSArray *template6 = @[
                               @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"オプション", @"title2":optionalPrice, @"identifier":[NSString stringWithFormat:@"room%d_option_detail",i]},
                               @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"小計", @"title2":[NSString stringWithFormat:@"%@(税込%@)", subTotal, subTotalTax], @"identifier":[NSString stringWithFormat:@"room%d_total_detail",i]}];
        
        [inputItems addObjectsFromArray:template6];
    }
    NSDictionary *template7 = @{@"cellName":@"Rule", @"type":@"ToyokoRuleCell", @"str1":@"規約",  @"str2":@"チェックイン時には必ずフロントにカードをご提示ください。提示がない場合は・・・（内容後日送付します）", @"identifier":@"rule"};
    
    [inputItems addObject:template7];
#if 0
    CGRect r = [[UIScreen mainScreen] bounds];
    
    CGFloat diff = r.size.height - (_ConfirmButton.frame.origin.y + _ConfirmButton.frame.size.height);
    
    if(diff != 0.0)
    {
        r = _containerView.frame;
        r.size.height += diff;
        [_containerView setFrame:r];
    }

    //NSArray *buttons = @[_ModifyButton, _ConfirmButton];
    for(UIButton *btn in buttons)
    {
        btn.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
#if 0
        r = btn.frame;
        r.origin.y += diff;
        [btn setFrame:r];
#endif
        [btn.imageView setContentMode: UIViewContentModeCenter];
    }
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

- (IBAction)BackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)ConfirmPressed:(id)sender {
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
    
    for(int i=1;i<=4;i++)
    {
        NSString *ID = [NSString stringWithFormat:@"room%d_chcknTime",i];
        NSString *checkinTime = tmpDict[ID];
        if(checkinTime == nil)
            continue; //no such room
        
        checkinTime = [[checkinTime componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
        checkinTime = [NSString stringWithFormat:@"%@00", checkinTime];
        tmpDict[ID] = checkinTime;
    }
    
    [self addRequestFields:tmpDict];
    [self setApiName:@"register_reservation_api"];
    [self setSecure:NO];
    
    [self sendRequest];
}

-(void)ParsedDataReady:(NSDictionary*)data
{
    NSLog(@"data: %@", data);
    
    if([data[@"errrCode"] isEqualToString:@"BCMN0000"])
    {
        reservDone *next = [self.storyboard instantiateViewControllerWithIdentifier:@"reservDone"];
        next.priceDetail = _priceDetail;
        next.resultDict = data;
        next.inputDict = _inputtedForm;
        next.htlName = _htlName;
        next.num_rooms = _inputDict[NUM_ROOMS];
        next.isChangeMode = NO;
        
        [self presentViewController:next animated:YES completion:^{}];
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
