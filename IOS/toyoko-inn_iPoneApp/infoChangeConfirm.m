//
//  infoChangeConfirm.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/08/12.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "infoChangeConfirm.h"
#import "Constant.h"
#import "infoChangeDone.h"

@interface infoChangeConfirm ()

@end

@implementation infoChangeConfirm

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
    
    NSString *memberStr;
    
    if([_inputDict[MEMBER_FLAG] isEqualToString:@"Y"])
    {
        memberStr = @"東横INNｸﾗﾌﾞｶｰﾄﾞ会員";
    }
    else
    {
        memberStr = @"一般";
    }
    
    inputItems = @[
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"会員/一般", @"title2":memberStr, @"identifier":MEMBER_FLAG},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"姓(半角アルファベット)", @"title2":_inputDict[FAMILY_NAME], @"identifier":FAMILY_NAME},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"名(半角アルファベット)", @"title2":_inputDict[GIVEN_NAME], @"identifier":GIVEN_NAME},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"国籍", @"title2":[Constant NationalityNameFromCode:_inputDict[NATIONALITY] lang:@"ja"], @"identifier":NATIONALITY},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"性別", @"title2":[Constant GenderNameFromCode:_inputDict[GENDER] lang:@"ja"], @"identifier":GENDER},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"電話番号", @"title2":_inputDict[TEL_NUM], @"identifier":TEL_NUM},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"メールアドレス1", @"title2":_inputDict[PC_EMAIL], @"identifier":PC_EMAIL},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"メールアドレス2(任意)", @"title2":_inputDict[MB_EMAIL], @"identifier":MB_EMAIL},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"お得情報を受信する", @"title2":[Constant YesNoNameFromCode:_inputDict[NEWSLETTER] lang:@"ja"], @"identifier":NEWSLETTER},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"パスワード", @"title2":@"ｾｷｭﾘﾃｨの観点から表示しません", @"identifier":PASSWORD},
#if 0
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"パスワード・確認用(任意)", @"title2":@"ｾｷｭﾘﾃｨの観点から表示しません", @"identifier":@"password2"},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"パスワードの削除", @"title2":[Constant YesNoNameFromCode:_inputDict[@"pw_delete"] lang:@"ja"], @"identifier":@"pw_delete"},
#endif
                   ];
#if 0
    CGRect r = [[UIScreen mainScreen] bounds];
    
    [_OKButton setFrame:CGRectMake(_OKButton.frame.origin.x, r.size.height-_OKButton.frame.size.height,_OKButton.frame.size.width, _OKButton.frame.size.height)];
    [_containerView setFrame:CGRectMake(_containerView.frame.origin.x, _containerView.frame.origin.y,
                                        _containerView.frame.size.width, r.size.height-_containerView.frame.origin.y-_OKButton.frame.size.height)];
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
        [_targetTableVC reload:inputItems];
    }
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
    self.delegate = self;
    [self addRequestFields:_inputDict];
    [self setApiName:@"change_customer_information_api"];
    [self setSecure:NO];
    
    [self sendRequest];
}

-(void)ParsedDataReady:(NSDictionary*)data
{
    if([data[@"errrCode"] isEqualToString:@"BCMN0000"]) //success
    {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        
        [ud setObject:[_inputDict[FAMILY_NAME] uppercaseString] forKey:FAMILY_NAME];
        [ud setObject:[_inputDict[GIVEN_NAME] uppercaseString] forKey:GIVEN_NAME];
        [ud synchronize];
        
        infoChangeDone *next = [self.storyboard instantiateViewControllerWithIdentifier:@"infoChangeDone"];
        [self presentViewController:next animated:YES completion:^ {
            
        }];
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
