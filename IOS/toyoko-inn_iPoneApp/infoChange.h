//
//  infoChange.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/08/04.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToyokoCustomTableVC.h"
#import "ToyokoNetBase.h"

@interface infoChange : ToyokoNetBase<ToyokoNetBaseDelegate>//UIViewController
@property ToyokoCustomTableVC *targetTableVC;
//@property NSMutableDictionary *inputDict;
@property NSDictionary *receivedData;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *OKButton;

- (IBAction)BackPressed:(id)sender;
- (IBAction)OKPressed:(id)sender;

@end
