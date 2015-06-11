//
//  HotelInfoView.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/06/04.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToyokoNetBase.h"
#import "FavoriteList.h"

@interface HotelInfoView : ToyokoNetBase<ToyokoNetBaseDelegate, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>//UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UINavigationBar *NaviBar;
@property (weak, nonatomic) IBOutlet UITableView *InfoTable;
@property (weak, nonatomic) IBOutlet UIButton *RoomButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) UIImageView *hotelImageView;
@property (strong, nonatomic) UIButton *prevButton;
@property (strong, nonatomic) UIButton *nextButton;
@property (strong, nonatomic) UIButton *aroundButton;
@property (strong, nonatomic) UIButton *routeButton;
@property (strong, nonatomic) UIButton *favoriteButton;
@property (strong, nonatomic) UIButton *mapButton;
@property NSDictionary *inputDict; //hotel code for information query
@property NSString *hotelCode;
- (void)AroundPressed:(id)sender;
- (void)RoutePressed:(id)sender;
- (void)FavoritePressed:(id)sender;
- (IBAction)RoomTypePressed:(id)sender;
- (IBAction)BackPressed:(id)sender;
- (void)MapPressed:(id)sender;

@end
