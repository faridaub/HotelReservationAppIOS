//
//  SearchEntry.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/06/16.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToyokoNetBase.h"
#import <CoreLocation/CoreLocation.h>
#import "DestSearch.h"

@interface SearchEntry : ToyokoNetBase<ToyokoNetBaseDelegate, UIAlertViewDelegate, /*UISearchBarDelegate*,*/ CLLocationManagerDelegate, DestSearchDelegate>
@property (weak, nonatomic) IBOutlet UIButton *CurrentPlaceButton;
@property (weak, nonatomic) IBOutlet UIButton *FavoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *HotelSearchButton;
@property (weak, nonatomic) IBOutlet UIButton *ConstraintButton;
@property (weak, nonatomic) IBOutlet UIButton *DestButton;
@property (weak, nonatomic) IBOutlet UIButton *OnePxOneRoomButton;
@property (weak, nonatomic) IBOutlet UIButton *TwoPxOneRoomButtom;
@property (weak, nonatomic) IBOutlet UIButton *OnePxTwoRoomButton;
//@property (weak, nonatomic) IBOutlet UISearchBar *DestSearchBar;
@property (weak, nonatomic) IBOutlet UILabel *DestLabel;
@property (weak, nonatomic) IBOutlet UINavigationBar *Navibar;
@property (weak, nonatomic) IBOutlet UILabel *BGLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *MenuButton;
- (IBAction)MenuPressed:(id)sender;
- (IBAction)MessagePressed:(id)sender;
- (IBAction)SearchPressed:(id)sender;
- (IBAction)ConstraintPressed:(id)sender;
- (IBAction)ConstraintButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *bgLabel2;

- (void)AddImageToButton:(UIButton*)button image:(UIImage*)img;
- (IBAction)RoomTypePressed:(id)sender;
- (void)HandleRadioGroup:(UIButton*)selected group:(NSArray*)group bgOnly:(bool)bgOnly;

@end
