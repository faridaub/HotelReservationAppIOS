//
//  reservChangeConfirm.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/08/12.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToyokoCustomTableVC.h"
#import "ToyokoNetBase.h"

@interface reservChangeConfirm : ToyokoNetBase<ToyokoNetBaseDelegate>//UIViewController
@property (weak, nonatomic) IBOutlet UIButton *OKButton;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property ToyokoCustomTableVC *targetTableVC;
@property NSDictionary *inputDict;
@property NSDictionary *inputtedForm;
@property NSDictionary *priceDetail;
@property NSDictionary *receivedData;
- (IBAction)BackPressed:(id)sender;
- (IBAction)OKPressed:(id)sender;
@end
