//
//  ListBox.h
//  toyoko-inn
//
//  Created by toyokoinn on 2015/04/06.
//  Copyright (c) 2015年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ListBoxDelegate <NSObject>
@required
- (void)SetIndex:(NSInteger)index;
@end

@interface ListBox : UIView<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSArray *list;
@property NSInteger selectedIndex;
@property id<ListBoxDelegate> delegate;

-(void)setData:(NSArray*)list index:(NSInteger)index;
@end
