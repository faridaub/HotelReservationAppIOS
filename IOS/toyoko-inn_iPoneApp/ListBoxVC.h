//
//  ListBoxVC.h
//  toyoko-inn
//
//  Created by toyokoinn on 2015/04/15.
//  Copyright (c) 2015年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ListBoxDelegate <NSObject>
@required
- (void)SetIndex:(NSInteger)index;
@end

@interface ListBoxVC : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property NSArray *list;
@property NSInteger selectedIndex;
@property id<ListBoxDelegate> delegate;

-(void)setData:(NSArray*)list index:(NSInteger)index;
@end
