//
//  infoRegAdd2.m
//  toyoko-inn
//
//  Created by toyokoinn on 2015/01/20.
//  Copyright (c) 2015年 中崎拓真. All rights reserved.
//

#import "infoRegAdd2.h"
#import "Constant.h"
#import "ViewController.h"
#import "MailPasswdConfirm.h"
#import "initialDup.h"

@interface infoRegAdd2 ()

@end

@implementation infoRegAdd2

static NSArray *inputItems;
static NSString *mailAddrStr;
static NSMutableDictionary *dict;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
#if 0
    NSLog(@"inputDict: %@", _inputDict);
#endif
    
    _ConfirmButton.clipsToBounds = YES;
    _ConfirmButton.layer.cornerRadius = 10;
    
    NSString *ruleStr = _RuleButton.titleLabel.text;
    UIColor *color = _RuleButton.titleLabel.textColor;
    UIFont *font = _RuleButton.titleLabel.font;
    
    //create a attributed string with underline to make the button like a link
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:ruleStr attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:color, NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSUnderlineColorAttributeName: color}];
    
    _RuleButton.titleLabel.attributedText = attrStr;
    
    mailAddrStr = _inputDict[PC_EMAIL];
    if(mailAddrStr == nil || mailAddrStr.length == 0)
    {
        mailAddrStr = _inputDict[MB_EMAIL];
        if(mailAddrStr == nil || mailAddrStr.length == 0) //mobile email is also null, avoid error
        {
            mailAddrStr = @"";
        }
    }
    
    //_mail1.text = mailAddrStr;
    
    NSString *memberStr;
    
    if([_inputDict[MEMBER_FLAG] isEqualToString:@"Y"])
    {
        memberStr = @"東横INNクラブカード会員";
    }
    else
    {
        memberStr = @"一般";
    }
    
    NSString *memberNum = _inputDict[MEMBER_NUM];
    if(memberNum == nil) //no member number
        memberNum = @"";
    
    NSString *newsletter = _inputDict[NEWSLETTER];
    if(newsletter == nil)
        newsletter = @"Y"; //default value
    
    if(_inputDict[MB_EMAIL])
    {
        _inputDict[@"emlAddrss2"] = _inputDict[MB_EMAIL];
    }
    else
    {
        _inputDict[@"emlAddrss2"] = @"";
    }
    
    inputItems = @[
#if 1
                   @{@"cellName":@"Title1", @"type":@"ToyokoCustomCell", @"title":@"ログイン情報", @"identifier":@"login_title"},
                   [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"ID(メールアドレス)", @"value":mailAddrStr, @"valid":@"email", @"identifier":LOGIN_ID, @"clear":@(YES), @"required":@(YES), @"hint":@"例：taro.toyoko@toyoko-inn.com", @"separator":@(NO)/*@"secure":@(YES)*/}mutableCopy],
                   [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"確認のため再入力してください", @"value":@"", @"valid":@"email", @"identifier":@"lgnId2", @"clear":@(YES), @"required":@(YES), @"hint":@"例：taro.toyoko@toyoko-inn.com", @"plain":@(YES), @"font":@(15), @"separator":@(NO)/*@"secure":@(YES)*/}mutableCopy],
                   [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"パスワード", @"value":@"", @"clear":@(YES), @"identifier":LOGIN_PASSWD, @"secure":@(YES), @"required":@(YES), @"separator":@(NO)}mutableCopy],
                   [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"確認のため再入力してください", @"value":@"", @"clear":@(YES), @"identifier":@"password2", @"secure":@(YES), @"required":@(YES), @"plain":@(YES), @"font":@(15), @"separator":@(NO)}mutableCopy],
                   @{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"アルファベット・数字を組合せ、6文字以上で設定してください。生年月日や電話番号など、第三者に推測されやすいパスワードは避けて下さい。\n ", @"identifier":@"pw_input_desc"},
#endif
                   @{@"cellName":@"Title1", @"type":@"ToyokoCustomCell", @"title":@"お客様基本情報",  @"identifier":@"info_title"},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"会員/一般", @"title2":memberStr, @"identifier":MEMBER_FLAG},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"会員番号", @"title2":memberNum, @"identifier":MEMBER_NUM},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"姓(半角アルファベット)", @"title2":_inputDict[FAMILY_NAME], @"identifier":FAMILY_NAME},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"名(半角アルファベット)", @"title2":_inputDict[GIVEN_NAME], @"identifier":GIVEN_NAME},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"生年月日", @"title2":[Constant convertToLocalDate:_inputDict[BIRTHDATE]], @"identifier":BIRTHDATE},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"国籍", @"title2":[Constant NationalityNameFromCode:_inputDict[NATIONALITY] lang:@"ja"], @"identifier":NATIONALITY},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"性別", @"title2":[Constant GenderNameFromCode:_inputDict[GENDER] lang:@"ja"], @"identifier":GENDER },
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"電話番号", @"title2":_inputDict[TEL_NUM], @"identifier":TEL_NUM},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"メールアドレス2", @"title2":_inputDict[@"emlAddrss2"], @"identifier":MB_EMAIL},
                   @{@"cellName":@"Title1", @"type":@"ToyokoCustomCell", @"title":@"メール配信設定",  @"identifier":@"news_title"},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"お得情報を受信する", @"title2":[Constant YesNoNameFromCode:newsletter lang:@"ja"], @"identifier":NEWSLETTER},
                   ];
    
    if(_targetTableVC)
    {
        [_targetTableVC reload:inputItems];
    }
    
#if 0
    NSArray *textfields = @[_mail1, _mailAddrInput, _passwd1, _passwd2];
    for(UITextField *tf in textfields)
    {
        tf.delegate = self;
        [self textChanged:tf];
    }
#endif
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self textChanged:textField];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(UITextFieldTextDidChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //NSLog(@"tf.text = %@", textField.text);
    // enter closes the keyboard
    if ([string isEqualToString:@"\n"])
    {
        [textField resignFirstResponder];
        return NO;
    }
    else if ([string isEqualToString:@""]) //handle backspace
    {
        return YES;
    }
    
    return YES;
}

- (IBAction)textChanged:(id)sender {
#if 0
    UITextField *tf = (UITextField*)sender;
    NSLog(@"text changed: %@", tf.text);
#endif
    
#if 0
    NSString *value = tf.text;
    //TODO: add warning mark
    if(value.length == 0)
    {
        UIImage *warning = [UIImage imageNamed:@"警告"];
        UIImageView *warningMark = [[UIImageView alloc] initWithImage:warning];
        warningMark.transform = CGAffineTransformMakeScale(0.5, 0.5);
        warningMark.contentMode = UIViewContentModeCenter;
        warningMark.frame = CGRectMake(0, 0, warning.size.width+10.0f, warning.size.height);
        tf.rightView = warningMark;
        tf.rightViewMode = UITextFieldViewModeUnlessEditing;
    }
    else
    {
        tf.rightView = nil;
    }
#endif
}

- (void) UITextFieldTextDidChange:(NSNotification*)notification
{
    UITextField * textfield = (UITextField*)notification.object;
    [self textChanged:textfield];
}

- (IBAction)RulePressed:(id)sender {
    NSString *URL = @"http://www.toyoko-inn.com/yoyaku/praivacy/policy_ja.html";
    
    ViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
    next.URL = URL;
    [self presentViewController:next animated:YES completion:^ {
        
    }];
}

- (IBAction)ConfirmPressed:(id)sender {
#if 1
    NSString *VALUE = @"value";
    NSString *mail1 = [_targetTableVC findRow:LOGIN_ID][VALUE];
    NSString *mail2 = [_targetTableVC findRow:@"lgnId2"][VALUE];
    NSString *pass1 = [_targetTableVC findRow:LOGIN_PASSWD][VALUE];
    NSString *pass2 = [_targetTableVC findRow:@"password2"][VALUE];
#else
    NSString *mail1 = _mail1.text;
    NSString *mail2 = _mailAddrInput.text;
    NSString *pass1 = _passwd1.text;
    NSString *pass2 = _passwd2.text;
#endif
    UIAlertView *alert;

    if([mail2 isEqualToString:mail1] == NO) //not identical
    {
        alert =
        [[UIAlertView alloc] initWithTitle:@"確認" message:@"1度目に入力したID（メールアドレス）と確認のために入力したものが一致していません。。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    
    if([pass1 isEqualToString:pass2] == NO) //not identical
    {
        alert =
        [[UIAlertView alloc] initWithTitle:@"確認" message:@"パスワードが一致してません。ご確認ください。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    
    NSString *passwd = pass1;
    
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
    
    dict = [[NSMutableDictionary alloc]init];
    [dict addEntriesFromDictionary:_inputDict];
    dict[LOGIN_ID] = mail2;
    dict[LOGIN_PASSWD] = pass1;
    
    if(_inputDict[MEMBER_FLAG])
    {
        NSString *memberFlag = _inputDict[MEMBER_FLAG];
        
        if([memberFlag isEqualToString:@"Y"])
        {
            dict[PROCESSING_TYPE] = @"1"; //1: club member
        }
        else
            dict[PROCESSING_TYPE] = @"2"; //2: normal user
    }
    else //flag not set
    {
        NSString *memberNum = _inputDict[MEMBER_NUM];
        if(memberNum) //member number exists
        {
            dict[MEMBER_FLAG] = @"Y";
            dict[PROCESSING_TYPE] = @"1";
        }
        else
        {
            dict[MEMBER_FLAG] = @"N";
            dict[PROCESSING_TYPE] = @"2";
        }
    }
    
    dict[@"emlAddrss"] = mail2;
    dict[@"emlAddrss2"] = _inputDict[MB_EMAIL];
    if(_inputDict[NEWSLETTER] == nil)
    {
        dict[NEWSLETTER] = @"Y";
    }
    
    self.delegate = self;
    [self addRequestFields:dict];
    [self setApiName:@"check_initialization_api"];
    [self setSecure:NO];
    
    [self sendRequest];
}

- (IBAction)BackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)ParsedDataReady:(NSDictionary*)data
{
    NSLog(@"data: %@", data);
    UIAlertView *alert;
    
    if([data[@"errrCode"] isEqualToString:@"BCMN0000"])
    {
        //TODO: check the response and decide what to show
        NSInteger memberCount = [data[@"cntMmbrshp"] integerValue];
        if(memberCount == 0) //no member matched, new registration
        {
        }
        else //at least one member matched
        {
            //TODO: change the data in dictionary to show and show the confirm view
            if(memberCount == 1) //normal condition
            {
                dict[MEMBER_FLAG] = @"Y";
                NSArray *memberlist = data[@"mmbrshpNmbrList"];
                if(memberlist == nil)
                {
                    memberlist = data[@"mmbrshpNmbrArry"];
                }
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
#if 0
        alert =
        [[UIAlertView alloc] initWithTitle:@"確認" message:@"メールアドレスが別のアカウントととして使われております。メールアドレスをご確認の上、もう一度入力しなおしてください。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
#else
        initialDup *next = (initialDup*)[self.storyboard instantiateViewControllerWithIdentifier:@"initialDup"];
        [self presentViewController:next animated:YES completion:^ {
            
        }];
#endif
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
