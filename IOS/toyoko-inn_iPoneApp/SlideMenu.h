//
//  SlideMenu.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/04/21.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"

@interface SlideMenu : UIViewController <UITableViewDataSource, UITabBarControllerDelegate>
@property (nonatomic, strong) NSArray *cellNames;
@property (nonatomic, strong) NSArray *picNames;
@property (nonatomic, strong) NSArray *hlpics;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)DestPressed:(id)sender;
- (IBAction)DatePressed:(id)sender;
- (IBAction)MapPressed:(id)sender;
- (IBAction)HotelPressed:(id)sender;

@end
