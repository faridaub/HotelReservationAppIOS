//
//  MailPasswdConfirm.m
//  toyoko-inn
//
//  Created by toyokoinn on 2015/01/08.
//  Copyright (c) 2015年 中崎拓真. All rights reserved.
//

#import "MailPasswdConfirm.h"
#import "Constant.h"
#import "initialDone.h"

@interface MailPasswdConfirm ()

@end

@implementation MailPasswdConfirm

static NSArray *inputItems;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _RegButton.clipsToBounds = YES;
    _RegButton.layer.cornerRadius = 10;
    
    NSString *memberStr;
    
    if([_inputDict[MEMBER_FLAG] isEqualToString:@"Y"])
    {
        memberStr = @"東横INNｸﾗﾌﾞｶｰﾄﾞ会員";
    }
    else
    {
        memberStr = @"一般";
    }
    
    NSString *memberNum = _inputDict[MEMBER_NUM];
    if(memberNum == nil) //no member number
        memberNum = @"";
    
    NSString *password;
    password = [@"" stringByPaddingToLength: [_inputDict[LOGIN_PASSWD] length] withString: @"*" startingAtIndex:0];
    
    inputItems = @[
                   @{@"cellName":@"Title1", @"type":@"ToyokoCustomCell", @"title":@"ログイン情報",  @"identifier":@"login_title"},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"ID", @"title2":_inputDict[LOGIN_ID], @"identifier":LOGIN_ID},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"パスワード", @"title2":password, @"identifier":LOGIN_PASSWD},
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
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"お得情報を受信する", @"title2":[Constant YesNoNameFromCode:_inputDict[NEWSLETTER] lang:@"ja"], @"identifier":NEWSLETTER},
                   ];
    
    if(_targetTableVC)
    {
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

- (IBAction)BackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}
- (IBAction)RegPressed:(id)sender {
    self.delegate = self;
    [self addRequestFields:_inputDict];
    [self setApiName:@"entry_initialization_api"];
    [self setSecure:NO];
    
    [self sendRequest];
}

-(void)ParsedDataReady:(NSDictionary*)data
{
    NSLog(@"data: %@", data);
    UIAlertView *alert;
    
    if([data[@"errrCode"] isEqualToString:@"BCMN0000"])
    {
        UIViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"initialDone"];
        [self presentViewController:next animated:YES completion:nil];
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
