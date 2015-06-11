//
//  reservChange.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/08/01.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToyokoCustomTableVC.h"
#import "ToyokoNetBase.h"

@interface reservChange : ToyokoNetBase<ToyokoNetBaseDelegate>//UIViewController
@property ToyokoCustomTableVC *targetTableVC;
@property NSMutableDictionary *inputDict;
@property NSMutableDictionary *receivedData;
@property (weak, nonatomic) IBOutlet UIView *containerView;
- (IBAction)BackPressed:(id)sender;
- (IBAction)OKPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *OKButton;

@end
