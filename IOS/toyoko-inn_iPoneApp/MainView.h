//
//  MainView.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/04/03.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>
#if 1
#import <QuartzCore/QuartzCore.h>
#import "ECSlidingViewController.h"
#endif

@interface MainView : UIViewController<UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UIButton *DestButton;
@property (weak, nonatomic) IBOutlet UIButton *DateButton;
@property (weak, nonatomic) IBOutlet UIButton *MapButton;
@property (weak, nonatomic) IBOutlet UIButton *TopButton;
@property (weak, nonatomic) IBOutlet UIButton *HotelListButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *TypeSelect;
@property (weak, nonatomic) IBOutlet UISearchBar *HotelSearch;
@property (weak, nonatomic) IBOutlet UIButton *AdButton;
@property (weak, nonatomic) IBOutlet UIButton *TopButton2;
@property (weak, nonatomic) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIPageControl *AdPageControl;
- (IBAction)TopPressed:(id)sender;
- (IBAction)DestPressed:(id)sender;
- (IBAction)DatePressed:(id)sender;
- (IBAction)MapPressed:(id)sender;
- (IBAction)HotelPressed:(id)sender;
- (IBAction)AdPressed:(id)sender;
- (IBAction)PageValueChanged:(id)sender;
- (IBAction)MenuPressed:(id)sender;
- (void)adButtonUpdate:(NSTimer*)timer;
- (void)LoadAdPics:(NSArray*)adlist;
@end
