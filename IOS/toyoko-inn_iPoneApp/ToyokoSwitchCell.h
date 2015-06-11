//
//  ToyokoSwitchCell.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/12/04.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "ToyokoCustomCell.h"

@interface ToyokoSwitchCell : ToyokoCustomCell
@property (weak, nonatomic) IBOutlet UISwitch *SwitchControl;
- (IBAction)valueChanged:(id)sender;
@property (nonatomic) NSMutableDictionary *dict;
//@property (nonatomic) BOOL value;
@end
