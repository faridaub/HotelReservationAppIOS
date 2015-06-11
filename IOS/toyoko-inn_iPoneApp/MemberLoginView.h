//
//  MemberLoginView.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/06/12.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToyokoNetBase.h"

@interface MemberLoginView : ToyokoNetBase<ToyokoNetBaseDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate> //UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *PrefixButton;
- (IBAction)PrefixButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *PrefixPicker;
- (IBAction)BackPressed:(id)sender;
- (IBAction)OKPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *OKButton;
@property (weak, nonatomic) IBOutlet UITextField *memberNum1;
@property (weak, nonatomic) IBOutlet UITextField *memberNum2;
@property (weak, nonatomic) IBOutlet UITextField *FamilyName;
@property (weak, nonatomic) IBOutlet UITextField *GivenName;

@end
