//
//  reservCancelConfirm.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/08/12.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToyokoCustomTableVC.h"
#import "ToyokoNetBase.h"

@interface reservCancelConfirm : ToyokoNetBase<ToyokoNetBaseDelegate>//UIViewController
@property (weak, nonatomic) IBOutlet UIView *containerView;
- (IBAction)OKPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *OKButton;
@property ToyokoCustomTableVC *targetTableVC;
@property NSMutableArray *inputDict;
@property NSDictionary *receivedData;
- (IBAction)BackPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *backgroundLabel;
- (IBAction)RulePressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *RuleButton;

@end
