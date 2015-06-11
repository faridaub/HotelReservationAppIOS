//
//  infoRegDone.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/08/07.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "infoRegDone.h"
#import "AppDelegate.h"

@interface infoRegDone ()

@end

@implementation infoRegDone
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
    
    NSArray *buttons = @[_infoChangeButton, _reservButton];
    
    for(UIButton *btn in buttons)
    {
        btn.clipsToBounds = YES;
        btn.layer.cornerRadius = 10;
    }
    
    inputItems = @[
                   @{@"cellName":@"Cell", @"type":@"ToyokoCustomCell", @"title":@"お客様情報登録完了",  @"identifier":@"done_title"},
                   @{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"*お客様情報を変更しました。\n変更内容は以下のページからご確認ください。",@"color":[UIColor darkGrayColor], @"identifier":@"done_desc"},
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
        
        if([tableview contentSize].height < _containerView.frame.size.height/*_targetTableVC.tableView.frame.size.height*/)
        {
            CGFloat diff = [tableview contentSize].height - _containerView.frame.size.height/*tableview.frame.size.height*/;
            CGRect r = _containerView.frame/*tableview.frame*/;
            r.size.height = [tableview contentSize].height;
            [_containerView/*tableview*/ setFrame:r];
            
            NSArray *buttons = @[_infoChangeButton, _reservButton];
            
            for(UIButton *btn in buttons)
            {
                r = btn.frame;
                r.origin.y += diff;
                [btn setFrame:r];
            }
        }
    }
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if(appDelegate.reservData == nil) //login/reg during reservation?
        _reservButton.hidden = YES;
    else
        _reservButton.hidden = NO;
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
- (IBAction)infoChangePressed:(id)sender {
    //TODO: jump to the info change view
    
    //dismiss to root view and jump to reservation list view
    UIViewController *root = self.view.window.rootViewController;
    [root dismissViewControllerAnimated:NO completion:^{
#if 1
        UIViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"infoChange"];
        [root presentViewController:next animated:YES completion:nil];
#endif
    }];
}

- (IBAction)reservPressed:(id)sender {
    //TODO: jump to the reservation view and use the reservation data to continue
}
@end
