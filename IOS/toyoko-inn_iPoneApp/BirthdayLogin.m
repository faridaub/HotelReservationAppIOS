//
//  BirthdayLogin.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/08/14.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "BirthdayLogin.h"
#import "sameBirthWarning.h"
#import "infoRegAdd2.h"
#import "initialAlready.h"
#import "Constant.h"

@interface BirthdayLogin ()

@end

@implementation BirthdayLogin

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
    NSArray *buttons = @[_LoginButton, _NewRegButton];
    
    for(UIButton *btn in buttons)
    {
        btn.clipsToBounds = YES;
        btn.layer.cornerRadius = 10;
    }
    
    inputItems = @[
                   @{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"東横INNクラブカード会員様は、カードに記載されているお名前（ｱﾙﾌｧﾍﾞｯﾄ）を入力してください。", @"identifier":@"input_desc"},
                   [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"姓(半角アルファベット)", @"value":@"", @"identifier":FAMILY_NAME, @"hint":@"姓（例：YAMADA）", @"valid":@"letter", @"clear":@(YES), @"upper":@(YES)/*@"required":@(YES),*/ /*@"secure":@(YES)*/}mutableCopy],
                   [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"名(半角アルファベット)", @"value":@"", @"identifier":GIVEN_NAME, @"hint":@"名（例：TARO）", @"valid":@"letter", @"clear":@(YES), @"upper":@(YES)/*@"required":@(YES),*/ /*@"secure":@(YES)*/}mutableCopy],
                   [@{@"cellName":@"Text2", @"type":@"ToyokoTextCell", @"title":@"生年月日(数字8桁)", @"value":@"", @"identifier":BIRTHDATE, @"hint":@"生年月日（例：19750215）", @"valid":@"decimal", @"clear":@(YES)/*@"required":@(YES),*/ /*@"secure":@(YES)*/}mutableCopy],
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
            CGFloat diff = [tableview contentSize].height - tableview.frame.size.height -1;
            NSLog(@"diff: %f", diff);
            CGRect r = _containerView.frame;
            r.size.height = [tableview contentSize].height+1;
            [_containerView setFrame:r];
            
            NSArray *buttons = @[_LoginButton, _NewRegButton];
            
            for(UIButton *btn in buttons)
            {
                r = btn.frame;
                r.origin.y += diff;
                [btn setFrame:r];
            }
        }
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
    if([_targetTableVC findRow:BIRTHDATE] && [_targetTableVC findRow:GIVEN_NAME] && [_targetTableVC findRow:FAMILY_NAME])
    {
        dict[BIRTHDATE] = [_targetTableVC findRow:BIRTHDATE][@"value"];
        dict[FAMILY_NAME] = [_targetTableVC findRow:FAMILY_NAME][@"value"];
        dict[GIVEN_NAME] = [_targetTableVC findRow:GIVEN_NAME][@"value"];
    }
    
    NSArray *keys = @[BIRTHDATE, FAMILY_NAME, GIVEN_NAME];
    for(NSString *key in keys)
    {
        NSString *str = dict[key];
        if(str.length == 0)
        {
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle:@"確認" message:@"未入力の必須項目があります。ご確認ください。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            return;
        }
    }
    
    NSString *birth = [_targetTableVC findRow:BIRTHDATE][@"value"];
    if([Constant IsValidDate:birth] == NO)
    {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"確認" message:@"生年月日が正しくありません。もう一度ご確認ください。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    
    [self addRequestFields:dict];
    [self setApiName:@"attests_name_birth_date_api"];
    [self setSecure:NO];
    
    [self sendRequest];
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
#if 0
        NSString *uid = data[PERSON_UID];
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
        [defaults synchronize];
        
        //go back to root view
        [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
#endif
        //jump to info reg add view
        if([data[LOGIN_ID] isEqualToString:@""])
        {
            infoRegAdd2 *next = (infoRegAdd2*)[self.storyboard instantiateViewControllerWithIdentifier:@"infoRegAdd2"];
            next.inputDict = [data mutableCopy];
            
            //avoid nil item
            if(!next.inputDict[BIRTHDATE])
                next.inputDict[BIRTHDATE] = [_targetTableVC findRow:BIRTHDATE][@"value"];
            
            if(!next.inputDict[MB_EMAIL])
                next.inputDict[MB_EMAIL] = @"";
            
            if(!next.inputDict[MEMBER_FLAG])
                next.inputDict[MEMBER_FLAG] = @"N";
            
            [self presentViewController:next animated:YES completion:^ {
                
            }];
        }
        else //login ID already set
        {
            initialAlready *next = (initialAlready*)[self.storyboard instantiateViewControllerWithIdentifier:@"initialAlready"];
            
            next.inputDict = [data mutableCopy];
            
            if(!next.inputDict[BIRTHDATE])
                next.inputDict[BIRTHDATE] = [_targetTableVC findRow:BIRTHDATE][@"value"];
            
            if(!next.inputDict[MB_EMAIL])
                next.inputDict[MB_EMAIL] = @"";
            
            if(!next.inputDict[MEMBER_FLAG])
                next.inputDict[MEMBER_FLAG] = @"N";
            
            [self presentViewController:next animated:YES completion:^ {
                
            }];
        }
    }
    else if([data[@"errrCode"] isEqualToString:@"BGNL0004"]) //2 or more people exist
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        
        dict[BIRTHDATE] = [_targetTableVC findRow:BIRTHDATE][@"value"];
        dict[FAMILY_NAME] = [_targetTableVC findRow:FAMILY_NAME][@"value"];
        dict[GIVEN_NAME] = [_targetTableVC findRow:GIVEN_NAME][@"value"];
        
        sameBirthWarning *next = [self.storyboard instantiateViewControllerWithIdentifier:@"sameBirthWarning"];
        next.inputDict = dict;
        
        [self presentViewController:next animated:YES completion:^ {
            
        }];
    }
    else if([data[@"errrCode"] isEqualToString:@"BGNL0001"])
    {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"確認" message:/*data[@"errrMssg"]*/@"お客様情報を確認できませんでした。氏名･生年月日をご確認の上、再度お試しください。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"はい", nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"確認" message:data[@"errrMssg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"はい", nil];
        [alert show];
    }
}

-(void)connectionFailed:(NSError*)error
{
}
@end
