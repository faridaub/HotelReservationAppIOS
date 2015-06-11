//
//  reservOperation.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/08/12.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToyokoCustomTableVC.h"
#import "ToyokoNetBase.h"

@interface reservOperation : ToyokoNetBase<ToyokoNetBaseDelegate>//UIViewController
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property ToyokoCustomTableVC *targetTableVC;
@property NSMutableDictionary *inputDict;
- (IBAction)ChangePressed:(id)sender;
- (IBAction)CancelPressed:(id)sender;
- (IBAction)BackPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *ChangeButton;
@property (weak, nonatomic) IBOutlet UIButton *CancelButton;

@end
