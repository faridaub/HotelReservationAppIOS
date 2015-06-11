//
//  reservDone.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/08/06.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToyokoCustomTableVC.h"
#import "ToyokoNetBase.h"

@interface reservDone : ToyokoNetBase<ToyokoNetBaseDelegate>//UIViewController
@property ToyokoCustomTableVC *targetTableVC;
@property NSDictionary *inputDict;
@property NSDictionary *resultDict;
@property NSDictionary *priceDetail;
@property NSString *htlName;
@property NSString *num_rooms;
@property BOOL isChangeMode;
@property (weak, nonatomic) IBOutlet UIView *containerView;
- (IBAction)ConfirmPressed:(id)sender;
- (IBAction)MailPressed:(id)sender;
- (IBAction)LinePressed:(id)sender;
- (IBAction)HomePressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *ConfirmButton;
@property (weak, nonatomic) IBOutlet UIButton *MailButton;
@property (weak, nonatomic) IBOutlet UIButton *LineButton;
@property (weak, nonatomic) IBOutlet UINavigationBar *NaviBar;

@end
