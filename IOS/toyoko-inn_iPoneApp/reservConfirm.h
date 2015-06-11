//
//  reservConfirm.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/08/07.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToyokoCustomTableVC.h"
#import "ToyokoNetBase.h"

@interface reservConfirm : ToyokoNetBase<ToyokoNetBaseDelegate>//UIViewController

@property ToyokoCustomTableVC *targetTableVC;
@property NSDictionary *inputDict;
@property NSDictionary *inputtedForm;
@property NSString *htlName;
@property NSDictionary *roomDict;
@property NSDictionary *htlDict;
@property NSDictionary *priceDetail;
- (IBAction)BackPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *containerView;
- (IBAction)ConfirmPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *ConfirmButton;
@property (weak, nonatomic) IBOutlet UIButton *ModifyButton;

@end
