//
//  infoReg.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/08/12.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToyokoCustomTableVC.h"
#import "ToyokoNetBase.h"

@interface infoReg: UIViewController /*ToyokoNetBase<ToyokoNetBaseDelegate>*/ 
@property ToyokoCustomTableVC *targetTableVC;
//@property NSMutableDictionary *inputDict;
- (IBAction)OKPressed:(id)sender;
- (IBAction)BackPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *OKButton;

@end
