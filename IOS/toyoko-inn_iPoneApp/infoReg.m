//
//  infoReg.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/08/12.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "infoReg.h"
#import "Constant.h"
#import "infoRegConfirm.h"

@interface infoReg ()

@end

@implementation infoReg

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
                   [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"姓(半角アルファベット)", @"value":@"", @"identifier":FAMILY_NAME, @"valid":@"letter", @"hint":@"例：TOYOKO", @"clear":@(YES), @"required":@(YES)}mutableCopy],
                   [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"名(半角アルファベット)", @"value":@"", @"identifier":GIVEN_NAME, @"valid":@"letter", @"hint":@"例：TARO", @"clear":@(YES), @"required":@(YES)}mutableCopy],
                   //@{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"姓名は半角アルファベットで入力して下さい", @"color":[Constant AppRedColor], @"identifier":@"name_desc"},
                   [@{@"cellName":@"Text1", @"type":@"ToyokoTextCell", @"title":@"生年月日", @"value":@"", @"identifier":BIRTHDATE, @"hint":@"例：19750215", @"clear":@(YES), @"valid":@"decimal", @"required":@(YES)}mutableCopy],
                   [@{@"cellName":@"Picker", @"type":@"ToyokoPickerCell", @"title":@"国籍", @"choices":[Constant getNationalityNames:@"ja"], @"value":@(0), @"expanded":@(NO), @"minHeight":@(44), @"maxHeight":@(220), @"identifier":NATIONALITY, @"required":@(YES)}mutableCopy],
                   [@{@"cellName":@"Segment", @"type":@"ToyokoSegmentCell", @"title":@"性別", @"choices":[Constant getGenderNames:@"ja"], @"value":@(0), @"identifier":GENDER, @"required":@(YES)}mutableCopy],
                   [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"電話番号", @"value":@"", @"identifier":TEL_NUM, @"valid":@"decimal", @"clear":@(YES), @"required":@(YES), /*@"secure":@(YES)*/}mutableCopy],
                   [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"メールアドレス1", @"value":@"", @"valid":@"email", @"identifier":PC_EMAIL, @"clear":@(YES), @"required":@(YES), /*@"secure":@(YES)*/}mutableCopy],
                   [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"メールアドレス2(任意)", @"value":@"", @"valid":@"email", @"clear":@(YES), @"identifier":MB_EMAIL, @"required":@(NO), /*@"secure":@(YES)*/}mutableCopy],
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

- (IBAction)OKPressed:(id)sender {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    UIAlertView *alert;
    
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
    
    NSString *pw1 = [_targetTableVC findRow:PASSWORD][VALUE];
    NSString *pw2 = [_targetTableVC findRow:@"password2"][VALUE];
    
    if([pw1 isEqualToString:pw2] == NO) //pw1 and pw2 are not identical
    {
        alert = [[UIAlertView alloc] initWithTitle:@"確認" message:@"1度目に入力したパスワードと確認のために入力したパスワードが一致していません。"
                                          delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
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
    dict[PROCESSING_TYPE] = @"1"; //1: new registration or modification
    dict[MEMBER_FLAG] = @"N"; //in this view, the user must not be a club member
    
    //To show the registration confirm view
    infoRegConfirm *next = [self.storyboard instantiateViewControllerWithIdentifier:@"infoRegConfirm"];
    next.inputDict = dict;
    [self presentViewController:next animated:YES completion:^ {
        
    }];
}

- (IBAction)BackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}


@end
