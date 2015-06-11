//
//  reservInput.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/07/24.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToyokoCustomTableVC.h"
#import "ToyokoNetBase.h"

@interface reservInput : ToyokoNetBase<ToyokoNetBaseDelegate>//UIViewController

@property ToyokoCustomTableVC *targetTableVC;
@property NSMutableDictionary *inputDict;
@property (weak, nonatomic) IBOutlet UIView *contaierView;
- (IBAction)BackPressed:(id)sender;
- (IBAction)OKPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *OKButton;
@property NSString *htlName;
@property NSDictionary *roomDict;
@property NSDictionary *htlDict;

@end
