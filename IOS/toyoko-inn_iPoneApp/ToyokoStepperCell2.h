//
//  ToyokoStepperCell2.h
//  toyoko-inn
//
//  Created by toyokoinn on 2015/01/30.
//  Copyright (c) 2015年 中崎拓真. All rights reserved.
//

#import "ToyokoCustomCell.h"

@interface ToyokoStepperCell2 : ToyokoCustomCell
@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;
@property (weak, nonatomic) IBOutlet UILabel *digitLabel;
- (IBAction)plusPressed:(id)sender;
- (IBAction)minusPressed:(id)sender;
@property NSInteger max, min, currValue;
@property NSInteger step;
@property (nonatomic) NSMutableDictionary *dict;
-(void)setupStepper:(NSInteger)step min:(NSInteger)min max:(NSInteger)max;

@end
