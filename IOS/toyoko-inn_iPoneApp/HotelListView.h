//
//  HotelListView.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/06/24.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToyokoNetBase.h"

@interface HotelListView : ToyokoNetBase<ToyokoNetBaseDelegate, UIActionSheetDelegate>//UIViewController
- (IBAction)BackPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *ConstraintButton;
@property (weak, nonatomic) IBOutlet UIButton *SortButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationBar *NaviBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *BackButton;
- (IBAction)ConstraintPressed:(id)sender;
- (IBAction)SortPressed:(id)sender;
- (IBAction)MapPressed:(id)sender;
- (void)MoveToHotel:(NSString*)htlCode;
@property NSArray *inputArray;
//@property NSString *title;
@property double lttd, lngtd;
@property NSDictionary *searchDict;
@property NSString* keyword;
@end
