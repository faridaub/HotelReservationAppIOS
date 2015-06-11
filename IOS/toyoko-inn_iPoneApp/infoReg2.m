//
//  infoReg2.m
//  toyoko-inn
//
//  Created by toyokoinn on 2015/01/07.
//  Copyright (c) 2015年 中崎拓真. All rights reserved.
//

#import "infoReg2.h"
#import "Constant.h"
#import "MailPasswdConfirm.h"
#import "ViewController.h"

@interface infoReg2 ()

@end

@implementation infoReg2

static NSArray *inputItems;
static NSMutableDictionary *dict;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _ConfirmButton.clipsToBounds = YES;
    _ConfirmButton.layer.cornerRadius = 10;
    
    NSString *ruleStr = _RuleButton.titleLabel.text;
    UIColor *color = _RuleButton.titleLabel.textColor;
    UIFont *font = _RuleButton.titleLabel.font;
    
    //create a attributed string with underline to make the button like a link
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:ruleStr attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:color, NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSUnderlineColorAttributeName: color}];
    
    _RuleButton.titleLabel.attributedText = attrStr;
    
    inputItems = @[
                   @{@"cellName":@"Title1", @"type":@"ToyokoCustomCell", @"title":@"ログイン情報", @"identifier":@"login_title"},
                   [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"ID(メールアドレス)", @"value":@"", @"valid":@"email", @"identifier":LOGIN_ID, @"clear":@(YES), @"required":@(YES), @"hint":@"例：taro.toyoko@toyoko-inn.com"/*@"secure":@(YES)*/}mutableCopy],
                   [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"確認のため再入力してください", @"value":@"", @"valid":@"email", @"identifier":@"lgnId2", @"clear":@(YES), @"required":@(YES), @"hint":@"例：taro.toyoko@toyoko-inn.com", @"plain":@(YES), @"font":@(15)/*@"secure":@(YES)*/}mutableCopy],
                   [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"パスワード", @"value":@"", @"clear":@(YES), @"identifier":LOGIN_PASSWD, @"secure":@(YES), @"required":@(YES)}mutableCopy],
                   [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"確認のため再入力してください", @"value":@"", @"clear":@(YES), @"identifier":@"password2", @"secure":@(YES), @"required":@(YES), @"plain":@(YES), @"font":@(15)}mutableCopy],
                   @{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"アルファベット・数字を組合せ、6文字以上で設定してください。生年月日や電話番号など、第三者に推測されやすいパスワードは避けて下さい。\n ", @"identifier":@"pw_input_desc"},
                   @{@"cellName":@"Title1", @"type":@"ToyokoCustomCell", @"title":@"お客様基本情報", @"identifier":@"customer_title"},
                   [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"姓(半角アルファベット)", @"value":@"", @"identifier":FAMILY_NAME, @"valid":@"letter", @"hint":@"例：TOYOKO", @"clear":@(YES), @"upper":@(YES), @"required":@(YES)}mutableCopy],
                   [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"名(半角アルファベット)", @"value":@"", @"identifier":GIVEN_NAME, @"valid":@"letter", @"hint":@"例：TARO", @"clear":@(YES), @"upper":@(YES), @"required":@(YES)}mutableCopy],
                   //@{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"姓名は半角アルファベットで入力して下さい", @"color":[Constant AppRedColor], @"identifier":@"name_desc"},
                   [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"生年月日(数字8桁)", @"value":@"", @"identifier":BIRTHDATE, @"hint":@"例：19750215", @"clear":@(YES), @"valid":@"decimal", @"required":@(YES)}mutableCopy],
                   [@{@"cellName":@"Picker", @"type":@"ToyokoPickerCell", @"title":@"国籍", @"choices":[Constant getNationalityNames:@"ja"], @"value":@(0), @"expanded":@(NO), @"minHeight":@(44), @"maxHeight":@(220), @"identifier":NATIONALITY, @"required":@(YES)}mutableCopy],
#if 0
                   [@{@"cellName":@"Segment", @"type":@"ToyokoSegmentCell", @"title":@"性別", @"choices":[Constant getGenderNames:@"ja"], @"value":@(0), @"identifier":GENDER, @"required":@(YES)}mutableCopy],
#else
                   [@{@"cellName":@"Picker", @"type":@"ToyokoPickerCell", @"title":@"性別", @"choices":[Constant getGenderNames:@"ja"], @"value":@(0), @"expanded":@(NO), @"minHeight":@(44), @"maxHeight":@(220), @"identifier":GENDER, @"required":@(YES)}mutableCopy],
#endif
                   [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"電話番号", @"value":@"", @"identifier":TEL_NUM, @"valid":@"decimal", @"clear":@(YES), @"required":@(YES), @"hint":@"例：09012345678"/*@"secure":@(YES)*/}mutableCopy],
                   [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"メールアドレス2(任意)", @"value":@"", @"valid":@"email", @"clear":@(YES), @"identifier":@"emlAddrss2", @"required":@(NO), @"hint":@"例：taro.toyoko@toyoko-inn.co.jp"/*@"secure":@(YES)*/}mutableCopy],
                   @{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"ドメイン指定受信設定をしている場合は「@toyoko-inn.com」からのメールを受信できるように設定してください。\n ", @"identifier":@"email_desc"},
                   @{@"cellName":@"Title1", @"type":@"ToyokoCustomCell", @"title":@"メール配信設定", @"identifier":@"mail_title"},
                   @{@"cellName":@"Cell", @"type":@"ToyokoCustomCell", @"title":@"東横INNメルマガ", @"identifier":@"mailmaga_title"},
                   @{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"お得情報満載＆プレゼント付き！", @"identifier":@"mailmaga_desc"},
                   [@{@"cellName":@"Segment", @"type":@"ToyokoSegmentCell", @"title":@"", @"choices":@[@"受信する",@"受信しない"], @"value":@(0), @"identifier":NEWSLETTER, @"plain":@(YES)/*@"required":@(YES)*/}mutableCopy],
                   @{@"cellName":@"Cell", @"type":@"ToyokoCustomCell", @"title":@"宿泊前の最終確認メール", @"identifier":@"reminder_title"},
                   @{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"チェックイン日の3日前に予約の最終確認メールをお送りします。", @"identifier":@"reminder_desc"},
                   [@{@"cellName":@"Segment", @"type":@"ToyokoSegmentCell", @"title":@"", @"choices":@[@"受信する",@"受信しない"], @"value":@(0), @"identifier":@"reminder", @"plain":@(YES)/*@"required":@(YES)*/}mutableCopy],
                   @{@"cellName":@"Cell", @"type":@"ToyokoCustomCell", @"title":@"サンクスメール", @"identifier":@"thanks_title"},
                   @{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"チェックイン後にご宿泊のお礼とアンケート（ご意見）のお願いのメールをお送りします。", @"identifier":@"thanks_desc"},
                   [@{@"cellName":@"Segment", @"type":@"ToyokoSegmentCell", @"title":@"", @"choices":@[@"受信する",@"受信しない"], @"value":@(0), @"identifier":@"thanks", @"plain":@(YES)/*@"required":@(YES)*/}mutableCopy],
#if 0
                   @{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"パスワードを設定しておくと、次回から生年月日とパスワードでログインができます。", @"identifier":@"pw_desc"},
                   [@{@"cellName":@"Text1", @"type":@"ToyokoTextCell", @"title":@"パスワード(任意)", @"value":@"", @"clear":@(YES), @"identifier":PASSWORD, @"secure":@(YES)}mutableCopy],
                   [@{@"cellName":@"Text1", @"type":@"ToyokoTextCell", @"title":@"パスワード・確認用(任意)", @"value":@"", @"clear":@(YES), @"identifier":@"password2", @"secure":@(YES)}mutableCopy],
#endif
                   ];
    
    if(_targetTableVC)
    {
#if 1
        UITableView *tableview = _targetTableVC.tableView;
        [tableview.layer setBorderWidth:0.0f];
        tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableview.separatorColor = [UIColor clearColor];
        
        //For iOS 6/7 compatiblilty, because setSeparatorInset is available from iOS 7
        if ([tableview respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableview setSeparatorInset:UIEdgeInsetsMake(0.f, 0.f, 0.f, tableview.bounds.size.width)];
        }
#endif
        [_targetTableVC reload:inputItems];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
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
        //[_targetTableVC.tableView.layer setBorderColor:[UIColor blackColor].CGColor];
        //[_targetTableVC.tableView.layer setBorderWidth:0.5f];
        //_targetTableVC.dialogScript = inputItems;
    }
}


- (IBAction)ConfirmPressed:(id)sender {
    dict = [[NSMutableDictionary alloc]init];
    UIAlertView *alert;
    
    NSString *VALUE = @"value";
    NSString *ID = @"identifier";
    
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
            
            NSString *str = item[VALUE];
            if([str length] == 0) //required item is empty string
            {
                alert =
                [[UIAlertView alloc] initWithTitle:@"確認" message:@"未入力の必須項目があります。ご確認ください。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
                return;
            }
        }
    }
    
    NSString *login1 = [_targetTableVC findRow:LOGIN_ID][VALUE];
    NSString *login2 = [_targetTableVC findRow:@"lgnId2"][VALUE];
    
    if([login1 isEqualToString:login2] == NO) //pw1 and pw2 are not identical
    {
        alert = [[UIAlertView alloc] initWithTitle:@"確認" message:@"1度目に入力したID（メールアドレス）と確認のために入力したものが一致していません。"
                                          delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    
    if([Constant IsValidEmail:login1] == NO) //e-mail format invalid
    {
        alert =
        [[UIAlertView alloc] initWithTitle:@"確認" message:@"ID（メールアドレス）の形式が不正です。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    
    NSString *birth = [_targetTableVC findRow:BIRTHDATE][VALUE];
    if([Constant IsValidDate:birth] == NO)
    {
        alert =
        [[UIAlertView alloc] initWithTitle:@"確認" message:@"生年月日が正しくありません。もう一度ご確認ください。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    
    NSString *mail2 = [_targetTableVC findRow:@"emlAddrss2"][VALUE];
    if(mail2.length > 0)
    {
        if([Constant IsValidEmail:mail2] == NO) //e-mail format invalid
        {
            alert =
            [[UIAlertView alloc] initWithTitle:@"確認" message:@"メールアドレス2の形式が不正です。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            return;
        }
    }
    
    NSString *passwd = [_targetTableVC findRow:LOGIN_PASSWD][VALUE];
    NSString *passwd2 = [_targetTableVC findRow:@"password2"][VALUE];
    
    if(![passwd isEqualToString:passwd2]) //passwords are not identical
    {
        alert =
        [[UIAlertView alloc] initWithTitle:@"確認" message:@"1度目に入力したパスワードと確認のために入力したパスワードが一致していません。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
 
    if(passwd.length < 6) //too short
    {
        alert =
        [[UIAlertView alloc] initWithTitle:@"確認" message:@"パスワードは6文字以上で入力してください。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    
    BOOL containsDigit = NO, containsAlpha = NO;
    
    for(int i=0;i < passwd.length; i++)
    {
        unichar c = [passwd characterAtIndex:i];
        
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
    
    if(![Constant IsValidPasswd:passwd])
    {
        alert =
        [[UIAlertView alloc] initWithTitle:@"確認" message:@"パスワードはアルファベットと数字のみを設定してください。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
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
    NSUInteger genderIndex = [[_targetTableVC findRow:GENDER][VALUE] integerValue];
    dict[GENDER] = [Constant getGenderCode:genderIndex];
    
    NSUInteger newsletterIndex = [[_targetTableVC findRow:NEWSLETTER][VALUE] integerValue];
    if(newsletterIndex == 0)
        dict[NEWSLETTER] = @"Y";
    else
        dict[NEWSLETTER] = @"N";
    NSUInteger nationaIndex = [[_targetTableVC findRow:NATIONALITY][VALUE] integerValue];
    dict[NATIONALITY] = [Constant getNationalityCode:nationaIndex];
    
    //show the confirm view
    //To prepare the data
    dict[PROCESSING_TYPE] = @"3"; //3: new registration or modification
    dict[MEMBER_FLAG] = @"N";
    dict[@"emlAddrss"] = login1;
    
    self.delegate = self;
    [self addRequestFields:dict];
    [self setApiName:@"check_initialization_api"];
    [self setSecure:NO];
    
    [self sendRequest];
}

- (IBAction)BackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)RulePressed:(id)sender {
    NSString *URL = @"http://www.toyoko-inn.com/yoyaku/praivacy/policy_ja.html";
    
    ViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
    next.URL = URL;
    [self presentViewController:next animated:YES completion:^ {
        
    }];
}

-(void)ParsedDataReady:(NSDictionary*)data
{
    NSLog(@"data: %@", data);
    UIAlertView *alert;
    
    if([data[@"errrCode"] isEqualToString:@"BCMN0000"])
    {
        NSInteger memberCount = [data[@"cntMmbrshp"] integerValue];
        if(memberCount == 0) //no member matched, new registration
        {
        }
        else //at least one member matched
        {
            if(memberCount == 1) //normal condition
            {
                dict[MEMBER_FLAG] = @"Y";
                NSArray *memberlist = data[@"mmbrshpNmbrList"];
                NSDictionary *tmpDict = memberlist[0];
                dict[MEMBER_NUM] = tmpDict[MEMBER_NUM];
            }
        }
        MailPasswdConfirm *next = (MailPasswdConfirm*)[self.storyboard instantiateViewControllerWithIdentifier:@"mailPasswdConfirm"];
        next.inputDict = dict;
        
        [self presentViewController:next animated:YES completion:^ {
            
        }];
    }
    else if([data[@"errrCode"] isEqualToString:@"BGNL0004"])
    {
        alert =
        [[UIAlertView alloc] initWithTitle:@"確認" message:@"メールアドレスや個人情報が別のアカウントとして使われております。メールアドレスと個人情報をご確認の上、もう一度入力しなおしてください。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    else
    {
        alert =
        [[UIAlertView alloc] initWithTitle:@"確認" message:data[@"errrMssg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
}

-(void)connectionFailed:(NSError*)error
{
}
@end
