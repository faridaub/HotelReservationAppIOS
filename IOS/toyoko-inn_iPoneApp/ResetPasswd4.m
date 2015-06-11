//
//  ResetPasswd4.m
//  toyoko-inn
//
//  Created by toyokoinn on 2015/01/09.
//  Copyright (c) 2015年 中崎拓真. All rights reserved.
//

#import "ResetPasswd4.h"

@interface ResetPasswd4 ()

@end

@implementation ResetPasswd4

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
    
    _Step4.layer.borderWidth = 1.0f;
    _Step4.layer.borderColor = _Step4.textColor.CGColor;
    
    _ConfirmButton.clipsToBounds = YES;
    _ConfirmButton.layer.cornerRadius = 10;
    
    inputItems = @[
                   @{@"cellName":@"Cell", @"type":@"ToyokoCustomCell", @"title":@"パスワード再設定完了",  @"identifier":@"done_title"},
                   @{@"cellName":@"Description", @"type":@"ToyokoCustomCell", @"title":@"パスワードを再設定しました。",@"color":[UIColor darkGrayColor], @"font":@(14), @"space":@(5) ,@"identifier":@"done_desc"},
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
    
    UIViewController *ToVC = self.presentingViewController;
    while(ToVC != nil)
    {
        if ([NSStringFromClass([ToVC class]) isEqualToString:@"loginChoices2"])
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
