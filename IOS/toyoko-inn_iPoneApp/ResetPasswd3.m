//
//  ResetPasswd3.m
//  toyoko-inn
//
//  Created by toyokoinn on 2015/01/09.
//  Copyright (c) 2015年 中崎拓真. All rights reserved.
//

#import "ResetPasswd3.h"
#import "Constant.h"

@interface ResetPasswd3 ()

@end

@implementation ResetPasswd3

static NSArray *inputItems;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *labels = @[_Step1, _Step2, _Step3, _Step4];
    
    for(UILabel *label in labels)
    {
        label.clipsToBounds = YES;
        label.layer.cornerRadius = 10;
    }
    
    _Step3.layer.borderWidth = 1.0f;
    _Step3.layer.borderColor = _Step3.textColor.CGColor;
    
    _ConfirmButton.clipsToBounds = YES;
    _ConfirmButton.layer.cornerRadius = 10;
    
    inputItems = @[
                   [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"パスワード", @"value":@"", @"clear":@(YES), @"identifier":LOGIN_PASSWD, @"secure":@(YES), @"required":@(YES)}mutableCopy],
                   @{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"※アルファベット・数字を組合せ、6文字以上で設定してください。生年月日や電話番号など、第三者に推測されやすいパスワードは避けて下さい。", @"color":[Constant AppRedColor], @"identifier":@"pass_desc"},
                   [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"確認のためもう一度入力してください", @"value":@"", @"clear":@(YES), @"identifier":@"password2", @"secure":@(YES), @"required":@(YES), @"plain":@(YES), @"font":@(15)}mutableCopy],
                   ];
    
    
    if(_targetTableVC)
    {
        UITableView *tableview = _targetTableVC.tableView;
#if 1
        //UITableView *tableview = _targetTableVC.tableView;
        [tableview.layer setBorderWidth:0.0f];
        tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableview.separatorColor = [UIColor clearColor];
        
        //For iOS 6/7 compatiblilty, because setSeparatorInset is available from iOS 7
        if ([tableview respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableview setSeparatorInset:UIEdgeInsetsMake(0.f, 0.f, 0.f, tableview.bounds.size.width)];
        }
#endif
        [_targetTableVC reload:inputItems];
        
        [_targetTableVC reload:inputItems];
        
        [tableview layoutIfNeeded];
        
        if([tableview contentSize].height < _containerView.frame.size.height/*_targetTableVC.tableView.frame.size.height*/)
        {
            CGFloat diff = [tableview contentSize].height - _containerView.frame.size.height/*tableview.frame.size.height*/;
            CGRect r = _containerView.frame/*tableview.frame*/;
            r.size.height = [tableview contentSize].height+1;
            [_containerView/*tableview*/ setFrame:r];
            
            r = _ConfirmButton.frame;
            r.origin.y += diff;
            [_ConfirmButton setFrame:r];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)BackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)ConfirmPressed:(id)sender {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
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
            
            NSString *str = item[@"value"];
            if([str length] == 0) //required item is empty string
            {
                NSString *title;
                if([item[ID] isEqualToString:LOGIN_PASSWD])
                {
                    title = @"パスワード";
                }
                else
                {
                    title = @"確認用パスワード";
                }
                NSString *alertMsg = [NSString stringWithFormat:@"%@が未入力です。", title];
                alert =
                [[UIAlertView alloc] initWithTitle:@"確認" message:alertMsg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
                return;
            }
        }
    }
    
    NSString *pass1 = [_targetTableVC findRow:LOGIN_PASSWD][VALUE];
    NSString *pass2 = [_targetTableVC findRow:@"password2"][VALUE];
    
    if([pass1 isEqualToString:pass2] == NO) //not identical
    {
        alert =
        [[UIAlertView alloc] initWithTitle:@"確認" message:@"パスワードが一致してません。ご確認ください。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    else //identical, format check. minimum 6 characters, alphabet and decimal mix
    {
        if(pass1.length < 6) //too short
        {
            alert =
            [[UIAlertView alloc] initWithTitle:@"確認" message:@"パスワードは6文字以上で入力してください。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            return;
        }
        
        BOOL containsDigit = NO, containsAlpha = NO;
        
        for(int i=0;i < pass1.length; i++)
        {
            unichar c = [pass1 characterAtIndex:i];
            
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
        
        if(![Constant IsValidPasswd:pass1])
        {
            alert =
            [[UIAlertView alloc] initWithTitle:@"確認" message:@"パスワードはアルファベットと数字のみを設定してください。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            return;
        }
        else //totally satisfied
        {
            NSArray *keys = @[AUTH_KEY, PERSON_UID, LOGIN_ID];
            
            for(NSString *key in keys) //copy items passed from previous view
            {
                dict[key] = _inputDict[key];
            }
            dict[LOGIN_PASSWD] = pass1; //fill the new password
            
            self.delegate = self;
            [self addRequestFields:dict];
            [self setApiName:@"reset_password_api"];
            [self setSecure:NO];
            
            [self sendRequest];
        }
    }
}

-(void)ParsedDataReady:(NSDictionary*)data
{
    NSLog(@"data: %@", data);
    UIAlertView *alert;
    
    if([data[@"errrCode"] isEqualToString:@"BCMN0000"])
    {
        UIViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"ResetPasswd4"];
        [self presentViewController:next animated:YES completion:^ {
            
        }];
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
