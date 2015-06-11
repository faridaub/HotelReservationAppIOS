//
//  DestSearch.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/07/01.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLTreeTableViewController.h"
#import "ToyokoNetBase.h"
#import "CustomTableVC.h"

@protocol DestSearchDelegate<NSObject>
@required
-(void)SetKeyword:(NSString*)keyword;
-(void)SetArea:(NSDictionary*)area;
@end

@interface DestSearch : ToyokoNetBase<ToyokoNetBaseDelegate, CustomTableDelegate, UISearchBarDelegate>//UIViewController
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegment;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property id<DestSearchDelegate> searchDelegate;

//@property NSString *searchKeyword;
@property NSMutableDictionary *areaResult;
@property NSMutableArray *DestResult;
@property NSInteger type;
@property NSMutableDictionary *searchDict;
@property BOOL hideNumber;
- (IBAction)BackPressed:(id)sender;
- (IBAction)typeChanged:(id)sender;

@end
