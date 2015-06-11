//
//  ListOptionMenu.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/04/18.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListOptionMenu : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIToolbar *BackBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *BackButton;
@property (weak, nonatomic) NSArray *cellNames;
- (IBAction)ReservePressed:(id)sender;
- (IBAction)PointPessed:(id)sender;
- (IBAction)SettingPressed:(id)sender;
- (IBAction)GuidePressed:(id)sender;
- (IBAction)InquiryPressed:(id)sender;
- (IBAction)BackPressed:(id)sender;

@end
