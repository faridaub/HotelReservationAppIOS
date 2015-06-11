//
//  infoChange.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/08/04.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "infoChange.h"
#import "Constant.h"
#import "infoChangeConfirm.h"

@interface infoChange ()

@end

@implementation infoChange

static NSArray *inputItems;

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
    
    inputItems = @[
#if 0
                   //TODO: convert memeber flag to value
                   [@{@"cellName":@"Segment", @"type":@"ToyokoSegmentCell", @"title":@"東横INNｸﾗﾌﾞｶｰﾄﾞ会員", @"choices":@[@"会員",@"一般"], @"value":@(0), @"identifier":MEMBER_FLAG} mutableCopy],
                   @{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"新たにカード会員になられた方（カードを発行された方）は「会員」にチェックを入れてください。", @"identifier":@"member_desc"},
                   [@{@"cellName":@"Text1", @"type":@"ToyokoTextCell", @"title":@"姓", @"value":_inputDict[FAMILY_NAME], @"identifier":FAMILY_NAME, @"valid":@"letter", @"required":@(YES)}mutableCopy],
                   [@{@"cellName":@"Text1", @"type":@"ToyokoTextCell", @"title":@"名", @"value":_inputDict[GIVEN_NAME], @"identifier":GIVEN_NAME, @"valid":@"letter", @"required":@(YES)}mutableCopy],
                   @{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"会員様はカード記載のｱﾙﾌｧﾍﾞｯﾄを入力してください。", @"identifier":@"name_desc"},
                   //TODO: convert nationality to localized string
                   [@{@"cellName":@"Picker", @"type":@"ToyokoPickerCell", @"title":@"国籍", @"choices":@[@"オーストラリア", @"日本",@"アメリカ",@"台湾",@"中国",@"イギリス"], @"value":@(1), @"expanded":@(NO), @"minHeight":@(44), @"maxHeight":@(220), @"identifier":NATIONALITY, @"required":@(YES)}mutableCopy],
                   //TODO: convert gender to localized string
                   [@{@"cellName":@"Segment", @"type":@"ToyokoSegmentCell", @"title":@"性別", @"choices":@[@"男性",@"女性"], @"value":@(0), @"identifier":GENDER, @"required":@(YES)}mutableCopy],
                   [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"電話番号", @"value":_inputDict[TEL_NUM], @"identifier":TEL_NUM, @"valid":@"decimal", @"required":@(YES), /*@"secure":@(YES)*/}mutableCopy],
                   [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"メールアドレス1", @"value":_inputDict[PC_EMAIL], @"identifier":PC_EMAIL, @"required":@(YES), /*@"secure":@(YES)*/}mutableCopy],
                   [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"メールアドレス2(任意)", @"value":_inputDict[MB_EMAIL], @"identifier":MB_EMAIL, @"required":@(NO), /*@"secure":@(YES)*/}mutableCopy],
                   @{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"ドメイン指定受信設定をしている場合は「@toyoko-inn.com」からのメールを受信できるように設定してください。", @"identifier":@"email_desc"},
                   //TODO: convert Y/N to localized string
                   [@{@"cellName":@"Segment", @"type":@"ToyokoSegmentCell", @"title":@"お得情報を受信する", @"choices":@[@"はい",@"いいえ"], @"value":@(0), @"identifier":NEWSLETTER, @"required":@(YES)}mutableCopy],
                   [@{@"cellName":@"Text1", @"type":@"ToyokoTextCell", @"title":@"パスワード(任意)", @"value":_inputDict[PASSWORD], @"identifier":PASSWORD, @"secure":@(YES)}mutableCopy],
                   [@{@"cellName":@"Text1", @"type":@"ToyokoTextCell", @"title":@"パスワード・確認用(任意)", @"value":@"", @"identifier":@"password2", @"secure":@(YES)}mutableCopy],
                   @{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"アルファベット・数字を組合せ、6文字以上で設定してください。生年月日や電話番号など、第三者に推測されやすいパスワードは避けて下さい。", @"identifier":@"pw_desc"},
#if 0
                   //TODO: convert Y/N to localized string
                   [@{@"cellName":@"Segment", @"type":@"ToyokoSegmentCell", @"title":@"パスワードの削除", @"choices":@[@"はい",@"いいえ"], @"value":@(1), @"identifier":@"pw_delete", @"required":@(NO)}mutableCopy],
                   @{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"パスワードを設定しておくと、次回から生年月日とパスワードでログインができます。", @"identifier":@"pw_delete_desc"}
#endif
#endif
                   ];
#if 0
    CGRect r = [[UIScreen mainScreen] bounds];
    
    [_OKButton setFrame:CGRectMake(_OKButton.frame.origin.x, r.size.height-_OKButton.frame.size.height,_OKButton.frame.size.width, _OKButton.frame.size.height)];
    [_containerView setFrame:CGRectMake(_containerView.frame.origin.x, _containerView.frame.origin.y, _containerView.frame.size.width, r.size.height-_containerView.frame.origin.y-_OKButton.frame.size.height)];
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
    
    //To send request and to load person information
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if([ud stringForKey:PERSON_UID])
    {
        NSDictionary *dict=@{PERSON_UID:[ud stringForKey:PERSON_UID]};
        
        self.delegate = self;
        [self addRequestFields:dict];
        [self setApiName:@"search_customer_information_api"];
        [self setSecure:NO];
        
        [self sendRequest];
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

- (IBAction)OKPressed:(id)sender
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    UIAlertView *alert;
    
#if 0
    NSLog(@"num of inputItems: %lu", (unsigned long)[inputItems count]);

    NSMutableArray *keyArray = [@[] mutableCopy];
    for(NSDictionary *dict in inputItems)
    {
        [keyArray addObject:dict[@"identifier"]];
    }
    NSLog(@"keys: %@", keyArray);
#endif
    //To check the required items
    for(id tmp in inputItems)
    {
        //item for input
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
                return;
            }
        }
    }
    
    NSString *VALUE = @"value";
    NSString *ID = @"identifier";
    
    NSString *pw1 = [_targetTableVC findRow:LOGIN_PASSWD][VALUE];
    NSString *pw2 = [_targetTableVC findRow:@"password2"][VALUE];
    
    if([pw1 isEqualToString:pw2] == NO) //pw1 and pw2 are not identical
    {
        alert = [[UIAlertView alloc] initWithTitle:@"確認" message:@"1度目に入力したパスワードと確認のために入力したパスワードが一致していません。"
                                          delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    
    if(pw1.length < 6) //too short
    {
        alert =
        [[UIAlertView alloc] initWithTitle:@"確認" message:@"パスワードは6文字以上で入力してください。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    
    BOOL containsDigit = NO, containsAlpha = NO;
    
    for(int i=0;i < pw1.length; i++)
    {
        unichar c = [pw1 characterAtIndex:i];
        
        containsDigit |= [[NSCharacterSet decimalDigitCharacterSet] characterIsMember:c];
        containsAlpha |= [[NSCharacterSet letterCharacterSet] characterIsMember:c];
    }
    
    if(!(containsDigit && containsAlpha)) //at least one restrict is not satisfied
    {
        alert =
        [[UIAlertView alloc] initWithTitle:@"確認" message:@"パスワードはアルファベットと数字を組み合わせ、6文字以上で設定してください。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    
    if(![Constant IsValidPasswd:pw1])
    {
        alert =
        [[UIAlertView alloc] initWithTitle:@"確認" message:@"パスワードはアルファベットと数字のみを設定してください。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    
    //To check e-mail format
    NSString *pc_mail = [_targetTableVC findRow:PC_EMAIL][VALUE];
    if([Constant IsValidEmail:pc_mail] == NO) //e-mail format invalid
    {
        alert =
        [[UIAlertView alloc] initWithTitle:@"確認" message:@"メールアドレス1の形式が不正です。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    
    NSString *mb_mail = [_targetTableVC findRow:MB_EMAIL][VALUE];
    if(mb_mail.length > 0) //avoid empty mobile email
    {
        if([Constant IsValidEmail:mb_mail] == NO) //e-mail format invalid
        {
            alert =
            [[UIAlertView alloc] initWithTitle:@"確認" message:@"メールアドレス2の形式が不正です。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            return;
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
            return;
        }
    }
    
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
    
    //To convert non-textfield items
    NSUInteger memberIndex = [[_targetTableVC findRow:MEMBER_FLAG][VALUE] integerValue];
    if(memberIndex == 0) //member
        dict[MEMBER_FLAG] = @"Y";
    else
        dict[MEMBER_FLAG] = @"N";
    
    NSUInteger genderIndex = [[_targetTableVC findRow:GENDER][VALUE] integerValue];
    dict[GENDER] = [Constant getGenderCode:genderIndex];
    
    NSUInteger newsletterIndex = [[_targetTableVC findRow:NEWSLETTER][VALUE] integerValue];
    if(newsletterIndex == 0)
        dict[NEWSLETTER] = @"Y";
    else
        dict[NEWSLETTER] = @"N";
#if 0
    NSUInteger pwDeleteIndex = [[_targetTableVC findRow:@"pw_delete"][VALUE] integerValue];
    if(pwDeleteIndex == 0)
        dict[@"pw_delete"] = @"Y";
    else
        dict[@"pw_delete"] = @"N";
#endif
    NSUInteger nationaIndex = [[_targetTableVC findRow:NATIONALITY][VALUE] integerValue];
    dict[NATIONALITY] = [Constant getNationalityCode:nationaIndex];
    
    //show the confirm view
    //To prepare the data
    dict[PROCESSING_TYPE] = @"1"; //1: new registration or modification
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    dict[PERSON_UID] = [ud stringForKey:PERSON_UID];
    if([ud stringForKey:MEMBER_NUM])
        dict[MEMBER_NUM] = [ud stringForKey:MEMBER_NUM];
    
    //for the new added parameter birthdate
    dict[BIRTHDATE] = _receivedData[BIRTHDATE];
    
    //20150126 -- add code for new login scheme
    dict[LOGIN_ID] = dict[PC_EMAIL];
    //dict[LOGIN_PASSWD] = dict[PASSWORD];
    dict[PASSWORD] = _receivedData[PASSWORD]; //keep old password field for B service compatibility
    
    //To show the registration confirm view
    infoChangeConfirm *next = [self.storyboard instantiateViewControllerWithIdentifier:@"infoChangeConfirm"];
    next.inputDict = dict;
    [self presentViewController:next animated:YES completion:^ {
        
    }];
}

-(void)PrepareTableData:(NSDictionary*)data
{
    NSInteger memberIndex = 1;
    if([data[MEMBER_FLAG] isEqualToString:@"Y"])
    {
        memberIndex =0;
    }
    else
    {
        memberIndex = 1;
    }
    
    NSInteger newsletterIndex = 0;
    if([data[NEWSLETTER] isEqualToString:@"Y"])
    {
        newsletterIndex = 0;
    }
    else
    {
        newsletterIndex = 1;
    }
    
    NSString *mb_email;
    if(data[MB_EMAIL] == nil)
    {
        mb_email = @"";
    }
    else
    {
        mb_email = data[MB_EMAIL];
    }
    
    NSString *password;
    if(data[PASSWORD] == nil)
    {
        password = @"";
    }
    else
    {
        password = data[LOGIN_PASSWD];
    }
    
    inputItems = @[
#if 1
                   @{@"cellName":@"Title1", @"type":@"ToyokoCustomCell", @"title":@"ログイン情報", @"identifier":@"login_title"},
#if 1
                   [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"メールアドレス1", @"value":data[PC_EMAIL], @"valid":@"email", @"identifier":PC_EMAIL, @"clear":@(YES), @"required":@(YES), /*@"secure":@(YES)*/}mutableCopy],
#endif
                   [@{@"cellName":@"Text1", @"type":@"ToyokoTextCell", @"title":@"ﾊﾟｽﾜｰﾄﾞ", @"value":password, @"clear":@(YES), @"identifier":LOGIN_PASSWD/*PASSWORD*/, @"secure":@(YES)}mutableCopy],
                   [@{@"cellName":@"Text1", @"type":@"ToyokoTextCell", @"title":@"ﾊﾟｽﾜｰﾄﾞ・確認用", @"value":@"", @"clear":@(YES), @"identifier":@"password2", @"secure":@(YES)}mutableCopy],
                   @{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"アルファベット・数字を組合せ、6文字以上で設定してください。生年月日や電話番号など、第三者に推測されやすいパスワードは避けて下さい。", @"identifier":@"pw_desc"},
#endif
                   @{@"cellName":@"Title1", @"type":@"ToyokoCustomCell", @"title":@"お客様基本情報", @"identifier":@"customer_title"},
                   [@{@"cellName":@"Segment", @"type":@"ToyokoSegmentCell", @"title":@"東横INNｸﾗﾌﾞｶｰﾄﾞ会員", @"choices":@[@"会員",@"一般"], @"value":[NSNumber numberWithInteger:memberIndex], @"identifier":MEMBER_FLAG} mutableCopy],
                   @{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"新たにカード会員になられた方（カードを発行された方）は「会員」にチェックを入れてください。\n ", @"identifier":@"member_desc"},
                   [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"姓(半角アルファベット)", @"value":data[FAMILY_NAME], @"hint":@"例：TOYOKO", @"identifier":FAMILY_NAME, @"clear":@(YES), @"valid":@"letter", @"upper":@(YES), @"required":@(YES)}mutableCopy],
                   [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"名(半角アルファベット)", @"hint":@"例：TARO", @"value":data[GIVEN_NAME], @"identifier":GIVEN_NAME, @"valid":@"letter", @"clear":@(YES), @"upper":@(YES), @"required":@(YES)}mutableCopy],
                   @{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"会員様はカード記載のｱﾙﾌｧﾍﾞｯﾄを入力してください。", @"identifier":@"name_desc"},
                   [@{@"cellName":@"Picker", @"type":@"ToyokoPickerCell", @"title":@"国籍", @"choices":[Constant getNationalityNames:@"ja"], @"value":[Constant NationalityIndexFromCode:data[NATIONALITY]], @"expanded":@(NO), @"minHeight":@(44), @"maxHeight":@(220), @"identifier":NATIONALITY, @"required":@(YES)}mutableCopy],
#if 0
                   [@{@"cellName":@"Segment", @"type":@"ToyokoSegmentCell", @"title":@"性別", @"choices":[Constant getGenderNames:@"ja"], @"value":[Constant GenderIndexFromCode:data[GENDER]], @"identifier":GENDER, @"required":@(YES)}mutableCopy],
#else
                   [@{@"cellName":@"Picker", @"type":@"ToyokoPickerCell", @"title":@"性別", @"choices":[Constant getGenderNames:@"ja"], @"value":[Constant GenderIndexFromCode:data[GENDER]], @"expanded":@(NO), @"minHeight":@(44), @"maxHeight":@(220), @"identifier":GENDER, @"required":@(YES)}mutableCopy],
#endif
                   [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"電話番号", @"value":data[TEL_NUM], @"identifier":TEL_NUM, @"valid":@"decimal", @"clear":@(YES), @"required":@(YES), /*@"secure":@(YES)*/}mutableCopy],
#if 0
                   [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"メールアドレス1", @"value":data[PC_EMAIL], @"valid":@"email", @"identifier":PC_EMAIL, @"clear":@(YES), @"required":@(YES), /*@"secure":@(YES)*/}mutableCopy],
#endif
                   [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"メールアドレス2(任意)", @"value":mb_email, @"valid":@"email", @"identifier":MB_EMAIL, @"clear":@(YES), @"required":@(NO), /*@"secure":@(YES)*/}mutableCopy],
                   @{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"ドメイン指定受信設定をしている場合は「@toyoko-inn.com」からのメールを受信できるように設定してください。", @"identifier":@"email_desc"},
                   @{@"cellName":@"Title1", @"type":@"ToyokoCustomCell", @"title":@"メール配信設定", @"identifier":@"mail_title"},
                   @{@"cellName":@"Cell", @"type":@"ToyokoCustomCell", @"title":@"東横INNメルマガ", @"identifier":@"mailmaga_title"},
                   @{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"お得情報満載＆プレゼント付き！", @"identifier":@"mailmaga_desc"},
#if 1
                   [@{@"cellName":@"Segment", @"type":@"ToyokoSegmentCell", @"title":@"", @"choices":@[@"はい",@"いいえ"], @"value":@(newsletterIndex), @"identifier":NEWSLETTER, @"plain":@(YES)/*@"required":@(YES)*/}mutableCopy],
#else
                   [@{@"cellName":@"Picker", @"type":@"ToyokoPickerCell", @"title":@"", @"choices":@[@"はい",@"いいえ"], @"value":@(newsletterIndex), @"expanded":@(NO), @"minHeight":@(44), @"maxHeight":@(220), @"identifier":NEWSLETTER, @"plain":@(YES)/*@"required":@(YES)*/}mutableCopy],
#endif
                   @{@"cellName":@"Cell", @"type":@"ToyokoCustomCell", @"title":@"宿泊前の最終確認メール", @"identifier":@"reminder_title"},
                   @{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"チェックイン日の3日前に予約の最終確認メールをお送りします。", @"identifier":@"reminder_desc"},
#if 1
                   [@{@"cellName":@"Segment", @"type":@"ToyokoSegmentCell", @"title":@"", @"choices":@[@"受信する",@"受信しない"], @"value":@(0), @"identifier":@"reminder", @"plain":@(YES)/*@"required":@(YES)*/}mutableCopy],
#else
                   [@{@"cellName":@"Picker", @"type":@"ToyokoPickerCell", @"title":@"", @"choices":@[@"はい",@"いいえ"], @"value":@(0), @"expanded":@(NO), @"minHeight":@(44), @"maxHeight":@(220), @"identifier":@"reminder", @"plain":@(YES)/*@"required":@(YES)*/}mutableCopy],
#endif
                   @{@"cellName":@"Cell", @"type":@"ToyokoCustomCell", @"title":@"サンクスメール", @"identifier":@"thanks_title"},
                   @{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"チェックイン後にご宿泊のお礼とアンケート（ご意見）のお願いのメールをお送りします。", @"identifier":@"thanks_desc"},
#if 1
                   [@{@"cellName":@"Segment", @"type":@"ToyokoSegmentCell", @"title":@"", @"choices":@[@"受信する",@"受信しない"], @"value":@(0), @"identifier":@"thanks", @"plain":@(YES)/*@"required":@(YES)*/}mutableCopy],
#else
                   [@{@"cellName":@"Picker", @"type":@"ToyokoPickerCell", @"title":@"", @"choices":@[@"はい",@"いいえ"], @"value":@(0), @"expanded":@(NO), @"minHeight":@(44), @"maxHeight":@(220), @"identifier":@"reminder", @"plain":@(YES)/*@"required":@(YES)*/}mutableCopy],
#endif
#if 0
                   @{@"cellName":@"Title1", @"type":@"ToyokoCustomCell", @"title":@"ログイン情報", @"identifier":@"login_title"},
                   [@{@"cellName":@"Text1", @"type":@"ToyokoTextCell", @"title":@"ﾊﾟｽﾜｰﾄﾞ", @"value":password, @"clear":@(YES), @"identifier":LOGIN_PASSWD/*PASSWORD*/, @"secure":@(YES)}mutableCopy],
                   [@{@"cellName":@"Text1", @"type":@"ToyokoTextCell", @"title":@"ﾊﾟｽﾜｰﾄﾞ・確認用", @"value":@"", @"clear":@(YES), @"identifier":@"password2", @"secure":@(YES)}mutableCopy],
                   @{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"アルファベット・数字を組合せ、6文字以上で設定してください。生年月日や電話番号など、第三者に推測されやすいパスワードは避けて下さい。", @"identifier":@"pw_desc"},
#endif
#if 0
                   //TODO: convert Y/N to localized string
                   [@{@"cellName":@"Segment", @"type":@"ToyokoSegmentCell", @"title":@"パスワードの削除", @"choices":@[@"はい",@"いいえ"], @"value":@(1), @"identifier":@"pw_delete", @"required":@(NO)}mutableCopy],
                   @{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"パスワードを設定しておくと、次回から生年月日とパスワードでログインができます。", @"identifier":@"pw_delete_desc"}
#endif
                   ];

}

-(void)ParsedDataReady:(NSDictionary*)data
{
    NSLog(@"data: %@", data);
    
    if([data[@"errrCode"] isEqualToString:@"BCMN0000"])
    {
        _receivedData = data;
        [self PrepareTableData:data];
#if 1
        [_targetTableVC reload:inputItems];
#endif
    }
    else
    {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"確認" message:data[@"errrMssg"]/*@"システムエラー。少しお待ちください。"*/
                                  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"はい", nil];
        [alert show];
        return;
    }
}

-(void)connectionFailed:(NSError*)error
{
}
@end
