//
//  AppDelegate.h
//  toyoko-inn_iPoneApp
//
//  Created by 中崎拓真 on 2014/01/28.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class JASidePanelController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

#if 0
@property (strong, nonatomic) JASidePanelController *viewController;
#endif
//temporary storage of reserv input data if login is required during reservation
@property (strong, nonatomic) NSMutableDictionary *reservData;
@property (strong, nonatomic) NSDictionary *roomDict;
@property (strong, nonatomic) NSString *htlName;
@property (strong, nonatomic) NSString *loginID;
@property (strong, nonatomic) UIViewController *lastVC;

@end
