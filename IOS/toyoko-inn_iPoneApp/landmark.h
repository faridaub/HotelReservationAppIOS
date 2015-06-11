//
//  landmark.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/08/15.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToyokoNetBase.h"
#import <GoogleMaps/GoogleMaps.h>

@interface landmark : UIView
@property (weak, nonatomic) IBOutlet UIButton *roomsLeftButton;
@property (weak, nonatomic) IBOutlet UIImageView *hotelImageView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *distanceImg;

@property BOOL isSingleHotelMode;
@property GMSMapView *mapView;

-(void)setDict:(NSDictionary*)dict;
- (IBAction)ClosePressed:(id)sender;

@end
