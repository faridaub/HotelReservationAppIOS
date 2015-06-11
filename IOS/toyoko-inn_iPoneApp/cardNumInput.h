//
//  cardNumInput.h
//  toyoko-inn
//
//  Created by toyokoinn on 2015/01/07.
//  Copyright (c) 2015年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cardNumInput : UIViewController
- (IBAction)PrefixPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *PrefixButton;
@property (weak, nonatomic) IBOutlet UITextField *memNum2;
@property (weak, nonatomic) IBOutlet UITextField *memNum3;
@property (weak, nonatomic) IBOutlet UIPickerView *prefixPicker;
@property (weak, nonatomic) IBOutlet UILabel *bgLabel;
@property (weak, nonatomic) IBOutlet UIButton *ConfirmButton;
- (IBAction)noCardChanged:(id)sender;
- (IBAction)ConfirmPressed:(id)sender;
- (IBAction)BackPressed:(id)sender;

@end
