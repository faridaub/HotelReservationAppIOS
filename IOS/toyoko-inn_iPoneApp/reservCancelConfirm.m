//
//  reservCancelConfirm.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/08/12.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "reservCancelConfirm.h"
#import "Constant.h"
#import "reservCancel.h"
#import "TextView.h"

@interface reservCancelConfirm ()

@end

@implementation reservCancelConfirm

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
    
//    NSString *txtFilePath = [[NSBundle mainBundle] pathForResource: @"cancelPolicy" ofType: @"txt"];
//    NSString *cancelPolicy = [NSString stringWithContentsOfFile:txtFilePath encoding:NSUTF8StringEncoding error:NULL];
    
    NSString *ruleStr = _RuleButton.titleLabel.text;
    UIColor *color = _RuleButton.titleLabel.textColor;
    UIFont *font = _RuleButton.titleLabel.font;
    
    //create a attributed string with underline to make the button like a link
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:ruleStr attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:color, NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSUnderlineColorAttributeName: color}];
    
    _RuleButton.titleLabel.attributedText = attrStr;
    
    inputItems = [_inputDict mutableCopy];
    //[inputItems addObject: @{@"cellName":@"Rule", @"type":@"ToyokoRuleCell", @"str1":@"キャンセルについて",  @"str2":@"キャンセル料は以下のとおり請求させていただきます。\n当日16時～22時：　宿泊代金の50％\n当日22時以降／不泊：　宿泊代金の100％", @"identifier":@"rule"}];
#if 0
    @[

                   @{@"cellName":@"Title0", @"type":@"ToyokoCustomCell", @"title":[NSString stringWithFormat:@"予約番号：%@",_inputDict[RESERV_NUM]], @"identifier":RESERV_NUM},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"宿泊日", @"title2":[NSString stringWithFormat:@"%@〜%ld泊", [Constant convertToLocalDate:_inputDict[CHECKIN_DATE]],[_inputDict[NUM_NIGHTS]integerValue]], @"identifier":CHECKIN_DATE},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"宿泊先", @"title2":_inputDict[HOTEL_NAME], @"identifier":@"hotel_name"},
                   @{@"cellName":@"Button", @"type":@"ToyokoButtonCell", @"title":@"喫煙ダブル", @"icon":@"喫煙マーク", @"buttonTitle":@"変更する", @"identifier":@"type_room1", @"hidden":@(YES)},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"ご利用人数", @"title2":@"2名（部屋あたり）", @"identifier":@"people_room1"},
                   @{@"cellName":@"Title2", @"type":@"ToyokoCustomCell", @"title":@"宿泊者情報", @"identifier":@"guest_room1"},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"姓", @"title2":@"Suzuki", @"identifier":@"fmlyname_room1", /*@"bgcolor":[UIColor lightGrayColor]*/},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"名", @"title2":@"Akane", @"identifier":@"name_room1", /*@"bgcolor":[UIColor lightGrayColor]*/},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"会員/一般", @"title2":@"東横INNｸﾗﾌﾞｶｰﾄﾞ会員", @"identifier":@"member_room1",/* @"bgcolor":[UIColor lightGrayColor]*/},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"国籍", @"title2":@"日本", @"identifier":@"nation_room1", /*@"bgcolor":[UIColor lightGrayColor]*/},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"性別", @"title2":@"男性", @"identifier":@"gender_room1", /*@"bgcolor":[UIColor lightGrayColor]*/},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"電話番号", @"title2":@"090-0000-0000", @"identifier":@"tel_room1", /*@"bgcolor":[UIColor lightGrayColor]*/},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"チェックイン予定時刻", @"title2":@"17:00", @"identifier":@"checkintime_room1", /*@"bgcolor":[UIColor lightGrayColor]*/},
                   @{@"cellName":@"Title2", @"type":@"ToyokoCustomCell", @"title":@"選択したオプション", @"identifier":@"options_room1"},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"連泊ECOプラン", @"title2":@"1/12, 1/14", @"identifier":@"option1_room1", /*@"bgcolor":[UIColor lightGrayColor]*/},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"ビジネスパック", @"title2":@"ビジネスパック100", @"identifier":@"option2_room1", /*@"bgcolor":[UIColor lightGrayColor]*/},
                   @{@"cellName":@"TotalPrice", @"type":@"ToyokoPriceCell", @"str1":@"お支払金額",  @"str2":@"　29,500円（税込31,860）", @"identifier":@"price_total"},
                   @{@"cellName":@"Title1", @"type":@"ToyokoCustomCell", @"title":@"内訳", @"identifier":@"price_detail"},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"1泊目(会員料金)", @"title2":@"7,000円", @"identifier":@"room1_night1_detail"},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"2泊目(会員料金)", @"title2":@"7,000円", @"identifier":@"room1_night2_detail"},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"オプション", @"title2":@"+1,200円", @"identifier":@"room1_option_detail"},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"小計", @"title2":@"14,200円\n(税込15,336円)", @"identifier":@"room1_total_detail"},
                   @{@"cellName":@"Rule", @"type":@"ToyokoRuleCell", @"str1":@"キャンセルについて",  @"str2":@"キャンセル料は以下のとおり頂戴いたします。\n                当日16時～22時：　宿泊代金の50％\n当日22時以降／不泊：　宿泊代金の100％\n※チェックイン予定時刻を過ぎる場合や宿泊の予定がなくなった場合は、必ず事前にホテルまでご連絡をお願いします。連絡なくお見えにならなかった場合、または当日16時以降にキャンセルされた場合には規定のキャンセル料を請求させていただきます。\n※10名様以上のご予約については、団体扱いとなり別途契約が必要になる場合がございます。団体のキャンセル料は以下となります。\n＜団体予約のキャンセル料＞\n7日前：　宿泊代金の10％\n2～6日前：　宿泊代金の30％\n前日：　宿泊代金の50％\n当日／不泊：　宿泊代金の100％"/*@"キャンセル料は以下のとおり請求させていただきます。\n当日16時～22時：宿泊代金の50％\n当日22時以降／不泊：宿泊代金の100％"*/, @"identifier":@"rule"},
                   ];
#endif
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
    //set the border of the background label
    [_backgroundLabel.layer setBorderColor:[UIColor redColor].CGColor];
    [_backgroundLabel.layer setBorderWidth:1.0f];

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
#if 0
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    dict[PERSON_UID] = [ud stringForKey:PERSON_UID];
    dict[@"nmbrRsrvtns"] = @"1"; //cancel one reservation each time
    //Add array index into string
    dict[[NSString stringWithFormat:@"%@[]", RESERV_ID]] = _receivedData[RESERV_ID];
    dict[/*[NSString stringWithFormat:@"%@[]", */HOTEL_CODE/*]*/] = _receivedData[HOTEL_CODE];
    dict[[NSString stringWithFormat:@"%@[]", RESERV_NUM]] = _receivedData[RESERV_NUM];
    
    self.delegate = self;
    
    [self addRequestFields:dict];
    [self setApiName:@"cancel_reservation_api"];
    [self setSecure:NO];
    
    [self sendRequest];
#else
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:@"確認" message:@"予約をキャンセルします。よろしいですか？" delegate:self cancelButtonTitle:@"いいえ" otherButtonTitles:@"はい", nil];
    [alert show];
#endif
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"button index: %ld", buttonIndex);
    
    if(buttonIndex == 1) //yes pressed
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        
        dict[PERSON_UID] = [ud stringForKey:PERSON_UID];
        dict[@"nmbrRsrvtns"] = @"1"; //cancel one reservation each time
        //Add array index into string
        dict[[NSString stringWithFormat:@"%@[]", RESERV_ID]] = _receivedData[RESERV_ID];
        dict[/*[NSString stringWithFormat:@"%@[]", */HOTEL_CODE/*]*/] = _receivedData[HOTEL_CODE];
        dict[[NSString stringWithFormat:@"%@[]", RESERV_NUM]] = _receivedData[RESERV_NUM];
        
        self.delegate = self;
        
        [self addRequestFields:dict];
        [self setApiName:@"cancel_reservation_api"];
        [self setSecure:NO];
        
        [self sendRequest];
    }
}

- (IBAction)BackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)ParsedDataReady:(NSDictionary*)data
{
    NSLog(@"data: %@", data);
#if 1
    if([data[@"errrCode"] isEqualToString:@"BCMN0000"]) //success
    {
        reservCancel *next = [self.storyboard instantiateViewControllerWithIdentifier:@"reservCancel"];
        next.inputDict = _receivedData;
        [self presentViewController:next animated:YES completion:^ {
            
        }];
    }
    else
    {
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:@"確認" message:data[@"errrMssg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
#endif
}

-(void)connectionFailed:(NSError*)error
{
}

- (IBAction)RulePressed:(id)sender {
    UIButton *btn = (UIButton*)sender;
    NSString *title = btn.titleLabel.text;
    
    NSString *txtFilePath = [[NSBundle mainBundle] pathForResource: @"cancelPolicy" ofType: @"txt"];
    NSString *cancelPolicy = [NSString stringWithContentsOfFile:txtFilePath encoding:NSUTF8StringEncoding error:NULL];
    
    TextView *next = [self.storyboard instantiateViewControllerWithIdentifier:@"TextView"];
    
    next.viewTitle = title;
    next.text = cancelPolicy;
    
    [self presentViewController:next animated:YES completion:^ {
    }];
}
@end
