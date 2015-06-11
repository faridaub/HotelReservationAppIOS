//
//  MapView.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/05/28.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "ToyokoNetBase.h"

@interface MapView : ToyokoNetBase<ToyokoNetBaseDelegate, GMSMapViewDelegate>/*UIViewController<GMSMapViewDelegate>*/
- (IBAction)BackPressed:(id)sender;
- (IBAction)ListPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UINavigationBar *NaviBar;
@property (weak, nonatomic) IBOutlet UIButton *ResetButton;
@property (weak, nonatomic) IBOutlet UIButton *ConstraintButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *BackButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *ListButton;
@property NSDictionary *searchDict;
@property NSArray *inputArray;
@property double centerLatt, centerLngtd;
- (IBAction)ResetPressed:(id)sender;
- (IBAction)ConstraintPressed:(id)sender;
//@property NSString *title;
@property BOOL isSingleHotelMode;

@end
