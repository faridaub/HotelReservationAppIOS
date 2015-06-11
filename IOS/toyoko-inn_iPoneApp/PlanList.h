//
//  PlanList.h
//  toyoko-inn
//
//  Created by toyokoinn on 2015/06/02.
//  Copyright (c) 2015年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToyokoNetBase.h"

@interface PlanList : UIViewController<UITableViewDelegate, UITableViewDataSource>
- (IBAction)BackPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableDictionary *searchDict;
@property (weak, nonatomic) IBOutlet UINavigationBar *NaviBar;
@property (weak, nonatomic) IBOutlet UILabel *roomLabel;
@property NSArray *planlist;
@property NSString *htlName;
@end
