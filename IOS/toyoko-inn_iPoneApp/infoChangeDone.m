//
//  infoChangeDone.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/08/07.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "infoChangeDone.h"

@interface infoChangeDone ()

@end

@implementation infoChangeDone
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
    
    _ConfirmButton.clipsToBounds = YES;
    _ConfirmButton.layer.cornerRadius = 10;
    
    // Do any additional setup after loading the view.
    inputItems = @[
                   @{@"cellName":@"Cell", @"type":@"ToyokoCustomCell", @"title":@"お客様情報変更完了",  @"identifier":@"done_title"},
                   @{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"お客様情報を変更しました。\n変更内容は以下のページからご確認ください。",@"color":[UIColor darkGrayColor], @"identifier":@"done_desc"},
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
            CGRect r = _containerView.frame;
            r.size.height = [tableview contentSize].height+1;
            [_containerView setFrame:r];
            
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
        //[_targetTableVC.tableView.layer setBorderColor:[UIColor blackColor].CGColor];
        //[_targetTableVC.tableView.layer setBorderWidth:0.5f];
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
    //[self dismissViewControllerAnimated:YES completion:^{}];
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)ConfirmPressed:(id)sender {
    //Back to the info change view
    UIViewController *ToVC = self.presentingViewController;
    while(ToVC != nil)
    {
        if ([NSStringFromClass([ToVC class]) isEqualToString:@"infoChange"])
        {
            break;
        }
        ToVC = ToVC.presentingViewController;
    }
    
    if(ToVC!=nil)
    {
        [ToVC dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
