//
//  ToyokoTextCell.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/07/15.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "ToyokoCustomCell.h"

@interface ToyokoTextCell : ToyokoCustomCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic) NSString *value;
@property (nonatomic) NSMutableDictionary *dict;
@property NSCharacterSet *validSet;
- (IBAction)textChanged:(id)sender;
- (id)getValue;
- (void)setSecure:(BOOL)secure;
- (void)setHint:(NSString*)hint;
- (void)setClear:(BOOL)clear;
- (void)setValid:(NSString*)type;
- (void)setUpperCase:(BOOL)upper;
@end
