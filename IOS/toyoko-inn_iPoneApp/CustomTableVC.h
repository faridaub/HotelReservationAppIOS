//
//  CustomTableVC.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/07/09.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "TLTreeTableViewController.h"
#import "ToyokoNetBase.h"

@protocol CustomTableDelegate<NSObject>
@required
-(void)SearchKeyword:(NSString*)keyword;
-(void)SearchArea:(NSDictionary*)area;
@end


@interface CustomTableVC : TLTreeTableViewController<TLTreeTableViewControllerDelegate>
@property (strong, nonatomic) NSArray *keywordList;
@property (strong, nonatomic) NSArray *areaList;
@property (strong, nonatomic) TLIndexPathTreeItem *currPlace;
@property (nonatomic) BOOL defaultKeyword;
@property id<CustomTableDelegate> embeddingView;
-(void)reloadData;
- (TLIndexPathTreeItem *)itemWithId:(id)identifier type:(NSString*)type children:(NSArray *)children;
- (TLIndexPathTreeItem *)itemWithId:(id)identifier type:(NSString*)type children:(NSArray *)children data:(id)data;
@end
