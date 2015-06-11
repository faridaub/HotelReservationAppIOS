//
//  infoRegAdd.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/08/12.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "infoRegAdd.h"
#import "Constant.h"
#import "infoRegConfirm.h"

@interface infoRegAdd ()

@end

@implementation infoRegAdd

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
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"会員/一般", @"title2":@"東横INNｸﾗﾌﾞｶｰﾄﾞ会員", @"identifier":@"member"},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"会員番号", @"title2":_inputDict[MEMBER_NUM], @"identifier":MEMBER_NUM},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"姓(半角アルファベット)", @"title2":_inputDict[FAMILY_NAME], @"identifier":FAMILY_NAME},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"名(半角アルファベット)", @"title2":_inputDict[GIVEN_NAME], @"identifier":GIVEN_NAME},
                   //TODO: wait for the birthdate to be added
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"生年月日", @"title2":[Constant convertToLocalDate:_inputDict[BIRTHDATE]], @"identifier":BIRTHDATE},
                   [@{@"cellName":@"Picker", @"type":@"ToyokoPickerCell", @"title":@"国籍", @"choices":[Constant getNationalityNames:@"ja"], @"value":[Constant NationalityIndexFromCode:_inputDict[NATIONALITY]], @"expanded":@(NO), @"minHeight":@(44), @"maxHeight":@(220), @"identifier":NATIONALITY, @"required":@(YES)}mutableCopy],
                   //TODO: make the coversion between M/F -> 男/女
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"性別", @"title2":[Constant GenderNameFromCode:_inputDict[GENDER] lang:@"ja"], @"identifier":GENDER },
                   [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"電話番号", @"value":_inputDict[TEL_NUM], @"identifier":TEL_NUM, @"clear":@(YES), @"valid":@"decimal", @"required":@(YES), /*@"secure":@(YES)*/}mutableCopy],
                   [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"メールアドレス1", @"value":_inputDict[PC_EMAIL], @"valid":@"email", @"clear":@(YES), @"identifier":PC_EMAIL, @"required":@(YES), /*@"secure":@(YES)*/}mutableCopy],
                   [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"メールアドレス2(任意)", @"value":_inputDict[MB_EMAIL], @"valid":@"email",  @"clear":@(YES), @"identifier":MB_EMAIL, @"required":@(NO), /*@"secure":@(YES)*/}mutableCopy],
                   @{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"ドメイン指定受信設定をしている場合は「@toyoko-inn.com」からのメールを受信できるように設定してください。", @"identifier":@"email_desc"},
                   [@{@"cellName":@"Segment", @"type":@"ToyokoSegmentCell", @"title":@"お得情報を受信する", @"choices":@[@"はい",@"いいえ"], @"value":@(0), @"identifier":NEWSLETTER, @"required":@(YES)}mutableCopy],
                   @{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"パスワードを設定しておくと、次回から生年月日とパスワードでログインができます。", @"identifier":@"pw_desc"},
                   [@{@"cellName":@"Text1", @"type":@"ToyokoTextCell", @"title":@"パスワード(任意)", @"value":@"", @"clear":@(YES), @"identifier":PASSWORD, @"secure":@(YES)}mutableCopy],
                   [@{@"cellName":@"Text1", @"type":@"ToyokoTextCell", @"title":@"パスワード・確認用(任意)", @"value":@"", @"clear":@(YES), @"identifier":@"password2", @"secure":@(YES)}mutableCopy],
                   @{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"アルファベット・数字を組合せ、6文字以上で設定してください。生年月日や電話番号など、第三者に推測されやすいパスワードは避けて下さい。", @"identifier":@"pw_input_desc"},
                   ];
#if 0
    CGRect r = [[UIScreen mainScreen] bounds];
    
    [_OKButton setFrame:CGRectMake(_OKButton.frame.origin.x, r.size.height-_OKButton.frame.size.height,_OKButton.frame.size.width, _OKButton.frame.size.height)];
    [_containerView setFrame:CGRectMake(_containerView.frame.origin.x, _containerView.frame.origin.y,
                                        _containerView.frame.size.width, r.size.height-_containerView.frame.origin.y-_OKButton.frame.size.height)];
#endif
    if(_targetTableVC)
    {
        [_targetTableVC reload:inputItems];
    }
#if 1
    //NSLog(@"nation codes: %@", [Constant getNationalityList]);
#endif
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

- (IBAction)OKPressed:(id)sender {
    //TODO: make the new dictionary for next view display
    NSArray *itemNames = @[TEL_NUM, PC_EMAIL, MB_EMAIL];
    NSDictionary *dict;
    
    NSString *VALUE = @"value";
    
    NSString *pw1 = [_targetTableVC findRow:PASSWORD][VALUE];
    NSString *pw2 = [_targetTableVC findRow:@"password2"][VALUE];
    
    UIAlertView *alert;
    if([pw1 length]!=0)
    {
        //password 1 and 2 are inconsistent
        if(![pw1 isEqualToString:pw2])
        {
            alert = [[UIAlertView alloc] initWithTitle:@"確認" message:@"1度目に入力したパスワードと確認のために入力したパスワードが一致していません。"
                                      delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            return;
        }
        _inputDict[PASSWORD] = pw1;
    }
    
    //To check e-mail format
    NSString *pc_mail = [_targetTableVC findRow:PC_EMAIL][VALUE];
    if([Constant IsValidEmail:pc_mail] == NO) //e-mail format invalid
    {
        alert =
        [[UIAlertView alloc] initWithTitle:@"確認" message:@"メールアドレス1は正しくない" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
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
    
    for(NSString *str in itemNames)
    {
        dict = [_targetTableVC findRow:str];
        if(dict[@"required"]) //required is set
        {
            if([dict[@"required"]boolValue])
            {
                NSString *strValue = dict[VALUE];
                if([strValue length] == 0) //required item is empty
                {
                    alert =
                    [[UIAlertView alloc] initWithTitle:@"確認" message:@"未入力の必須項目があります。ご確認ください。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    [alert show];
                    return;
                }
            }
        }
        //required check passed
        _inputDict[str] = dict[VALUE];
    }
    
    dict = [_targetTableVC findRow:NEWSLETTER];
    if([dict[VALUE] integerValue] == 0) //0: YES
        _inputDict[NEWSLETTER] = @"Y";
    else
        _inputDict[NEWSLETTER] = @"N";
    
    dict = [_targetTableVC findRow:NATIONALITY];
    _inputDict[NATIONALITY] = [Constant getNationalityCode:[dict[VALUE]integerValue]];
    
    //To prepare the data
    _inputDict[PROCESSING_TYPE] = @"1"; //1: new registration or modification
    _inputDict[MEMBER_FLAG] = @"Y"; //in this view, the user must be a club member

#if 0 //to send in next view
    self.delegate = self;
    [self addRequestFields:_inputDict];
    [self setApiName:@"entry_personal_information_api"];
    [self setSecure:NO];
    
    [self sendRequest];
#endif
    
    //To show the registration confirm view
    infoRegConfirm *next = [self.storyboard instantiateViewControllerWithIdentifier:@"infoRegConfirm"];
    next.inputDict = _inputDict;
    [self presentViewController:next animated:YES completion:^ {
        
    }];
}


@end
