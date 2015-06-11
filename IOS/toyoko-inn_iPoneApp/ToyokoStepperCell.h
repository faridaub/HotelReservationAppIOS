//
//  ToyokoStepperCell.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/07/15.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "ToyokoCustomCell.h"

@interface ToyokoStepperCell : ToyokoCustomCell
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (weak, nonatomic) IBOutlet UILabel *label;
- (IBAction)valueChanged:(id)sender;

@property (nonatomic) NSString *format;
@property double max, min, currValue;
@property (nonatomic) NSMutableDictionary *dict;

-(void)setFormatString:(NSString*)str;
-(void)setupStepper:(double)step min:(double)min max:(double)max;

@end
