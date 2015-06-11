//
//  ResetPasswd1.m
//  toyoko-inn
//
//  Created by toyokoinn on 2015/01/08.
//  Copyright (c) 2015年 中崎拓真. All rights reserved.
//

#import "ResetPasswd1.h"
#import "Constant.h"
#import "ResetPasswd2.h"

@interface ResetPasswd1 ()

@end

@implementation ResetPasswd1

static NSArray *inputItems;
static UIScrollView *scrollView;

static UITextField *activeField = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *labels = @[_Step1, _Step2, _Step3, _Step4];
    
    for(UILabel *label in labels)
    {
        label.clipsToBounds = YES;
        label.layer.cornerRadius = 10;
    }
    
    _Step1.layer.borderWidth = 1.0f;
    _Step1.layer.borderColor = _Step1.textColor.CGColor;
    
    _ConfirmButton.clipsToBounds = YES;
    _ConfirmButton.layer.cornerRadius = 10;
    
    inputItems = @[
              [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"メールアドレス", @"value":@"", @"valid":@"email", @"hint":@"例：taro.toyoko@toyoko-inn.com", @"identifier":@"emlAddrss", @"clear":@(YES), @"required":@(YES), /*@"secure":@(YES)*/}mutableCopy],
              [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"姓(半角アルファベット)", @"value":@"", @"identifier":FAMILY_NAME, @"valid":@"letter", @"hint":@"例：TOYOKO", @"upper":@(YES), @"clear":@(YES), @"required":@(YES)}mutableCopy],
              [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"名(半角アルファベット)", @"value":@"", @"identifier":GIVEN_NAME, @"valid":@"letter", @"hint":@"例：TARO", @"upper":@(YES), @"clear":@(YES), @"required":@(YES)}mutableCopy],
              //@{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"姓名は半角アルファベットで入力して下さい", @"color":[Constant AppRedColor], @"identifier":@"name_desc"},
              [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"生年月日(数字8桁)", @"value":@"", @"identifier":BIRTHDATE, @"hint":@"例：19750215", @"clear":@(YES), @"valid":@"decimal", @"required":@(YES)}mutableCopy],
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
            //CGFloat diff = [tableview contentSize].height - _containerView.frame.size.height/*tableview.frame.size.height*/;
            CGRect r = _containerView.frame/*tableview.frame*/;
            r.size.height = [tableview contentSize].height+1;
            [_containerView/*tableview*/ setFrame:r];
        }
    }
    
    activeField = nil;
    
    //20150423: added for scrollbar
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.contentSize = self.view.bounds.size;
    scrollView.bounces = NO;
    [scrollView addSubview:self.view];
    
    self.view = scrollView;
    
    [self registerForKeyboardNotifications];
    [self registerForTextFieldNotifications];
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

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)registerForTextFieldNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldTextDidBeginEditing:)
                                                 name:UITextFieldTextDidBeginEditingNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldTextDidEndEdition:)
                                                 name:UITextFieldTextDidEndEditingNotification
                                               object:nil];
}

- (void)textFieldTextDidBeginEditing:(NSNotification *)aNotification {
    activeField = aNotification.object;
}

- (void)textFieldTextDidEndEdition:(NSNotification *)aNotification {
    activeField = nil;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    //NSLog(@"keyboard show");
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(20.0f, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    
    [scrollView scrollRectToVisible:_containerView.frame animated:YES];
    
    double delayInSeconds = 0.5f; //delay 0.1 sec
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        UITableView *tableview = _targetTableVC.tableView;
        tableview.contentOffset = CGPointZero;
        CGRect frame = [activeField.superview convertRect:activeField.frame toView:self.view];
        //NSLog(@"tf frame: %@", NSStringFromCGRect(frame));
        [scrollView scrollRectToVisible:frame animated:YES];
    });
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    //NSLog(@"keyboard disappear");
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)ConfirmPressed:(id)sender {
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
                NSString *title = item[@"title"];
                NSString *alertMsg = [NSString stringWithFormat:@"%@が未入力です。", title];
                alert =
                [[UIAlertView alloc] initWithTitle:@"確認" message:alertMsg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
                return;
            }
        }
    }
    
    NSString *VALUE = @"value";
    NSString *ID = @"identifier";
    
    NSString *mail = [_targetTableVC findRow:@"emlAddrss"][VALUE];
    if([Constant IsValidEmail:mail] == NO) //e-mail format invalid
    {
        alert =
        [[UIAlertView alloc] initWithTitle:@"確認" message:@"メールアドレスが正しくありません。もう一度ご確認ください。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
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
    
    
    self.delegate = self;
    [self addRequestFields:dict];
    [self setApiName:@"send_password_forgotten_mail_api"];
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
        ResetPasswd2 *next = (ResetPasswd2*)[self.storyboard instantiateViewControllerWithIdentifier:@"ResetPasswd2"];
        next.inputDict = [data copy];
        
        NSString *VALUE = @"value";
        next.inputMailAddr = [_targetTableVC findRow:@"emlAddrss"][VALUE];
        
        [self presentViewController:next animated:YES completion:^ {
            
        }];
    }
    else if([data[@"errrCode"] isEqualToString:@"BGNL0006" ])
    {
        alert =
        [[UIAlertView alloc] initWithTitle:@"確認" message:@"メールアドレスや個人情報が正しくありません。もう一度ご確認ください。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    else
    {
        alert = [[UIAlertView alloc] initWithTitle:@"確認" message:data[@"errrMssg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
}

-(void)connectionFailed:(NSError*)error
{
}
@end
