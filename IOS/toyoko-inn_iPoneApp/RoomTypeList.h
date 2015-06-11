//
//  RoomTypeList.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/06/27.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToyokoNetBase.h"

@interface RoomTypeList : ToyokoNetBase<ToyokoNetBaseDelegate>//UIViewController
- (IBAction)BackPressed:(id)sender;
- (IBAction)MapPressed:(id)sender;
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *mapButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSDictionary* searchDict;
@property (weak, nonatomic) IBOutlet UINavigationBar *NaviBar;
//@property NSString *title;
@property NSString *htlName;

@end
