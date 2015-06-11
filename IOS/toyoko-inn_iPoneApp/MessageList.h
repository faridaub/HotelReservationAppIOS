//
//  MessageList.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/07/07.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageList : UIViewController
- (IBAction)BackPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
