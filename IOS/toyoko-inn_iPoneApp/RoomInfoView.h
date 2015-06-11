//
//  RoomInfoView.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/07/16.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToyokoNetBase.h"

@interface RoomInfoView : ToyokoNetBase<ToyokoNetBaseDelegate, UITableViewDelegate, UITableViewDataSource>//UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *OKButton;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) UIImageView *roomImageView;
@property (strong, nonatomic) UIButton *prevButton;
@property (strong, nonatomic) UIButton *nextButton;
- (IBAction)OKButtonPressed:(id)sender;
- (IBAction)BackPressed:(id)sender;
- (IBAction)NightsChanged:(id)sender;
@property NSMutableDictionary *searchDict;
@property NSDictionary *inputDict;
@property NSString *htlName;

@end
