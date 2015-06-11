//
//  reservDone.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/08/06.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "reservDone.h"
#import "Constant.h"
#import "ReservList.h"

@interface reservDone ()

@end

@implementation reservDone
NSMutableArray *inputItems;

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
    _ConfirmButton.clipsToBounds = YES;
    _ConfirmButton.layer.cornerRadius = 10;
    
    inputItems = [[NSMutableArray alloc]init];
    
    NSString *title;
    if(!_isChangeMode)
    {
        title = @"予約が完了しました。";
        _NaviBar.topItem.title = @"予約成立";
    }
    else
    {
        title = @"予約を変更しました。";
        _NaviBar.topItem.title = @"予約変更";
    }
    
    [inputItems addObject:
      @{@"cellName":@"Title0", @"type":@"ToyokoCustomCell", @"title":title, @"identifier":@"reserv_done"}];

    NSMutableArray *arr = [NSMutableArray array];
    for(int i=1;i<=4;i++)
    {
        NSString *ID = [NSString stringWithFormat:@"room%d_rsrv_nmbr",i];
        NSString *reservID = _resultDict[ID];
        
        if(reservID == nil)
            continue;
        if([reservID isEqualToString:@""])
            continue;
        else
            [arr addObject:reservID];
    }
    [inputItems addObject:@{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"予約番号", @"title2":[arr componentsJoinedByString:@", "], @"identifier":@"rsrv_nmbr"}];
    
#if 1
    NSString *total_price = _priceDetail[TOTAL_PRICE];
    NSString *total_price_tax = _priceDetail[TOTAL_PRICE_TAX];
    
    [inputItems addObject:
     @{@"cellName":@"Title0", @"type":@"ToyokoCustomCell", @"title":_htlName, @"identifier":HOTEL_NAME}];
    [inputItems addObject:@{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"チェックイン", @"title2":[Constant convertToLocalDate:_inputDict[@"room1_chcknDate"]], @"identifier":CHECKIN_DATE}];
    [inputItems addObject:@{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"チェックアウト", @"title2":[Constant convertToLocalDate:_inputDict[@"room1_chcktDate"]], @"identifier":@"checkout"}];
    [inputItems addObject:@{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"部屋数", @"title2":_num_rooms, @"identifier":NUM_ROOMS}];
    [inputItems addObject:@{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"お支払金額", @"title2":[NSString stringWithFormat:@"%@(税込%@)",total_price, total_price_tax], @"identifier":@"total_price"}];
//    [inputItems addObjectsFromArray:template];
#endif    
    [_MailButton.layer setBorderColor:[UIColor blackColor].CGColor];
    [_MailButton.layer setBorderWidth: 0.5f];
    
    [_LineButton.layer setBorderColor:[UIColor blackColor].CGColor];
    [_LineButton.layer setBorderWidth: 0.5f];
    
    //TODO: hide the LINE button if line:// protocol is not available (LINE is not installed)
    
    
    if(_targetTableVC)
    {
        [_targetTableVC reload:inputItems];
        
        UITableView *tableview = _targetTableVC.tableView;

        [tableview layoutIfNeeded];
        NSLog(@"table total height:%f", [_targetTableVC.tableView contentSize].height);
        
        if([_targetTableVC.tableView contentSize].height < _containerView.frame.size.height/*_targetTableVC.tableView.frame.size.height*/)
        {
            CGFloat diff = [tableview contentSize].height - _containerView.frame.size.height/*tableview.frame.size.height*/;
            CGRect r = _containerView.frame/*tableview.frame*/;
            r.size.height = [tableview contentSize].height;
            [_containerView/*tableview*/ setFrame:r];

            
            NSArray *buttons = @[_ConfirmButton, _MailButton, _LineButton];
            
            for(UIButton *btn in buttons)
            {
                r = btn.frame;
                r.origin.y += diff;
                [btn setFrame:r];
            }
        }
    }
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)ConfirmPressed:(id)sender {
    //TODO: jump to reservation list instead of reservation info,
    //      because of current structure is difficult to jump to
    //      reservation info from reservation done (lack of info)
    
    UIViewController *ToVC = self.presentingViewController;
    while(ToVC != nil)
    {
        if ([NSStringFromClass([ToVC class]) isEqualToString:@"ReservList"])
        {
            break;
        }
        ToVC = ToVC.presentingViewController;
    }
    
    if(ToVC!=nil)
    {
        ReservList *vc = (ReservList*)ToVC;
        [vc setReload];
        [ToVC dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        //dismiss to root view and jump to reservation list view
        UIViewController *root = self.view.window.rootViewController;
        [root dismissViewControllerAnimated:NO completion:^{
#if 1
            UIViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"ReservList"];
            [root presentViewController:next animated:YES completion:nil];
#endif
        }];

    }
}

- (IBAction)MailPressed:(id)sender {
}

- (IBAction)LinePressed:(id)sender {
}

- (IBAction)HomePressed:(id)sender {
    //jump to the home view in one line
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)ParsedDataReady:(NSDictionary*)data
{
}
-(void)connectionFailed:(NSError*)error
{
}
@end
