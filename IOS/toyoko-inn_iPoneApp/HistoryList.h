//
//  HistoryList.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/07/02.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToyokoNetBase.h"

@interface HistoryList : ToyokoNetBase<ToyokoNetBaseDelegate, UITableViewDataSource, UITableViewDelegate>//UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)BackPressed:(id)sender;

@end
