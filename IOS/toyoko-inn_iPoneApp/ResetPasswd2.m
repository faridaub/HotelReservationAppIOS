//
//  ResetPasswd2.m
//  toyoko-inn
//
//  Created by toyokoinn on 2015/01/09.
//  Copyright (c) 2015年 中崎拓真. All rights reserved.
//

#import "ResetPasswd2.h"
#import "ResetPasswd3.h"

@interface ResetPasswd2 ()

@end

@implementation ResetPasswd2

static NSArray *inputItems;
static UIScrollView *scrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *labels = @[_Step1, _Step2, _Step3, _Step4];
    
    for(UILabel *label in labels)
    {
        label.clipsToBounds = YES;
        label.layer.cornerRadius = 10;
    }
    
    _Step2.layer.borderWidth = 1.0f;
    _Step2.layer.borderColor = _Step2.textColor.CGColor;
    
    _ConfirmButton.clipsToBounds = YES;
    _ConfirmButton.layer.cornerRadius = 10;
    
    _mailAddr.text = _inputMailAddr;
    
    inputItems = @[
                   [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"認証キー(半角英数字)", @"value":@"", @"identifier":AUTH_KEY, @"clear":@(YES), @"required":@(YES), /*@"secure":@(YES)*/}mutableCopy],
                   @{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":
                         @"確認メールに記載されている認証キーを入力する",@"color":[UIColor darkGrayColor], @"identifier":@"done_desc"},
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

                //[_targetTableVC reload:inputItems];
        
        [tableview layoutIfNeeded];
        [tableview sizeToFit];
        
        if([tableview contentSize].height < _containerView.frame.size.height/*_targetTableVC.tableView.frame.size.height*/)
        {
            //CGFloat diff = [tableview contentSize].height - _containerView.frame.size.height/*tableview.frame.size.height*/;
            CGRect r = _containerView.frame/*tableview.frame*/;
            r.size.height = [tableview contentSize].height+1;
            [_containerView/*tableview*/ setFrame:r];
#if 1
            r = tableview.frame;
            r.size.height = [tableview contentSize].height;
            tableview.frame = r;
            tableview.bounces = NO;
            tableview.alwaysBounceVertical = NO;
#endif
#if 0
            r = _ConfirmButton.frame;
            r.origin.y += diff;
            [_ConfirmButton setFrame:r];
#endif
        }

    }
    
    //20150423: added for scrollbar
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.contentSize = self.view.bounds.size;
    scrollView.bounces = NO;
    [scrollView addSubview:self.view];

    self.view = scrollView;
    
    [self registerForKeyboardNotifications];
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

- (void)registerForKeyboardNotifications

{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(20.0, 0.0, kbSize.height, 0.0);
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
    });
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}

- (IBAction)BackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

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
    
    NSString *inputKey = _inputDict[AUTH_KEY];
    NSString *authKey = dict[AUTH_KEY];
    
    if([inputKey isEqualToString:authKey]) //correct key
    {
        ResetPasswd3 *next = (ResetPasswd3*)[self.storyboard instantiateViewControllerWithIdentifier:@"ResetPasswd3"];
        
        next.inputDict = [_inputDict copy];
        
        [self presentViewController:next animated:YES completion:^ {
            
        }];
    }
    else //key incorrect, show error message
    {
        alert =
        [[UIAlertView alloc] initWithTitle:@"確認" message:@"認証キーが正しくありません。もう一度ご確認ください。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
}
@end
