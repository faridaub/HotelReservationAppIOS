//
//  reservCancel.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/08/07.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "reservCancel.h"
#import "Constant.h"
#import "ReservList.h"

@interface reservCancel ()

@end

@implementation reservCancel
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
    _ConfirmButton.clipsToBounds = YES;
    _ConfirmButton.layer.cornerRadius = 10;
    
    inputItems = @[
                   @{@"cellName":@"Title0", @"type":@"ToyokoCustomCell", @"title":@"予約をキャンセルしました。", @"identifier":@"reserv_done"},
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"予約番号", @"title2":_inputDict[RESERV_NUM], @"identifier":RESERV_NUM},
                   @{@"cellName":@"Title0", @"type":@"ToyokoCustomCell", @"title":_inputDict[HOTEL_NAME], @"identifier":HOTEL_NAME},
                   
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"チェックイン", @"title2":[Constant convertToLocalDate:_inputDict[CHECKIN_DATE]], @"identifier":CHECKIN_DATE},
                   
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"チェックアウト", @"title2":[Constant convertToLocalDate:_inputDict[CHECKOUT_DATE]], @"identifier":CHECKOUT_DATE},
                   //Cancel one room at once
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"部屋数", @"title2":@"1部屋", @"identifier":NUM_ROOMS},
                   //TODO: combine the 2 prices into one string with currency unit
                   @{@"cellName":@"2Cols", @"type":@"ToyokoCustomCell", @"title":@"お支払金額", @"title2":[NSString stringWithFormat:@"%@円（税込%@円）", _inputDict[TOTAL_PRICE], _inputDict[TOTAL_PRICE_TAX]], @"identifier":@"total_price"}
                   ];
    
    if(_targetTableVC)
    {
        [_targetTableVC reload:inputItems];
        
        [_targetTableVC.tableView layoutIfNeeded];
        NSLog(@"table total height:%f", [_targetTableVC.tableView contentSize].height);
        
        if([_targetTableVC.tableView contentSize].height < _containerView.frame.size.height/*_targetTableVC.tableView.frame.size.height*/)
        {
            CGFloat diff = [_targetTableVC.tableView contentSize].height - _containerView.frame.size.height/*_targetTableVC.tableView.frame.size.height*/;
            CGRect r = _containerView.frame/*_targetTableVC.tableView.frame*/;
            r.size.height = [_targetTableVC.tableView contentSize].height;
            [_containerView/*_targetTableVC.tableView*/ setFrame:r];
            
            r = _ConfirmButton.frame;
            r.origin.y += diff;
            [_ConfirmButton setFrame:r];
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

- (IBAction)HomePressed:(id)sender {
    //jump to root view
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)ConfirmPressed:(id)sender {
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
}

@end
