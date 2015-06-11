//
//  PWLogin.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/08/14.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "PWLogin.h"

@interface PWLogin ()

@end

@implementation PWLogin

NSArray *inputItems;


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
    
    NSArray *buttons = @[_NoPasswordButton, _NewRegButton, _LoginButton];
    
    for(UIButton *btn in buttons)
    {
        btn.clipsToBounds = YES;
        btn.layer.cornerRadius = 10;
    }
    
    inputItems = @[
                   [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"生年月日(西暦)", @"value":@"", @"identifier":BIRTHDATE, @"hint":@"生年月日（例：19750215）", @"clear":@(YES)/*@"required":@(YES),*/ /*@"secure":@(YES)*/}mutableCopy],
                   [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"パスワード", @"value":@"", @"identifier":PASSWORD, @"hint":@"パスワード", @"clear":@(YES),/*@"required":@(YES),*/ @"secure":@(YES)}mutableCopy]
                   ];
    
    if(_targetTableVC)
    {
        UITableView *tableview = _targetTableVC.tableView;
#if 1
        [tableview.layer setBorderWidth:0.0f];
        tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableview.separatorColor = [UIColor clearColor];
        
        //For iOS 6/7 compatiblilty, because setSeparatorInset is available from iOS 7
        if ([tableview respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableview setSeparatorInset:UIEdgeInsetsMake(0.f, 0.f, 0.f, tableview.bounds.size.width)];
        }
#endif
        [_targetTableVC reload:inputItems];
        
        [tableview layoutIfNeeded];
        NSLog(@"table total height:%f", [tableview contentSize].height);
        
        if([tableview contentSize].height < tableview.frame.size.height)
        {
            CGFloat diff = [tableview contentSize].height - tableview.frame.size.height;
            NSLog(@"diff: %f", diff);
            CGRect r = _containerView.frame;
            r.size.height = [tableview contentSize].height;
            [_containerView setFrame:r];
            
            NSArray *buttons = @[_LoginButton, _NoPasswordButton,_NewRegButton];
            
            for(UIButton *btn in buttons)
            {
                r = btn.frame;
                r.origin.y += diff;
                [btn setFrame:r];
            }
        }
    }
}

#if 0
-(void) viewDidDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];

    if(!jumpToRoot)
        return;
 
    //[self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popToViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"SearchEntry"] animated:YES];

}
#endif
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
        //[_targetTableVC.tableView.layer setBorderColor:[UIColor blackColor].CGColor];
        //[_targetTableVC.tableView.layer setBorderWidth:0.5f];
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
- (IBAction)LoginPressed:(id)sender {
    self.delegate = self;
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    
    //check if the 2 identifiers exist or not to avoid null pointer
    if([_targetTableVC findRow:BIRTHDATE] && [_targetTableVC findRow:PASSWORD])
    {
        dict[BIRTHDATE] = [_targetTableVC findRow:BIRTHDATE][@"value"];
        dict[PASSWORD] = [_targetTableVC findRow:PASSWORD][@"value"];
    }
    
    [self addRequestFields:dict];
    [self setApiName:@"attests_birth_date_password_api"];
    [self setSecure:NO];
    
    [self sendRequest];
}

- (IBAction)NoPasswordPressed:(id)sender {
}

- (IBAction)NewRegPressed:(id)sender {
    //go back to the login choice view to choose which kind of new registration
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)ParsedDataReady:(NSDictionary*)data
{
    NSLog(@"data: %@", data);
    
    if([data[@"errrCode"] isEqualToString:@"BCMN0000"]) //success
    {
        NSString *uid = data[PERSON_UID];
        NSString *member_num = data[MEMBER_NUM];
        NSString *fmlyName = data[FAMILY_NAME];
        NSString *frstName = data[GIVEN_NAME];
        NSString *sex = data[GENDER];
        NSString *nationCode = data[NATIONALITY];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setObject:uid forKey:PERSON_UID];
        [defaults setObject:fmlyName forKey:FAMILY_NAME];
        [defaults setObject:frstName forKey:GIVEN_NAME];
        [defaults setObject:sex forKey:GENDER];
        [defaults setObject:nationCode forKey:NATIONALITY];
        if(member_num)
            [defaults setObject:member_num forKey:MEMBER_NUM];
        
        [defaults synchronize];
        
        //go back to root view
       [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    }
    else //TODO: handle exceptions
    {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"確認" message:@"ログインできません。入力情報をもう一度ご確認ください。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"はい", nil];
        [alert show];
    }
}

-(void)connectionFailed:(NSError*)error
{
}
@end
