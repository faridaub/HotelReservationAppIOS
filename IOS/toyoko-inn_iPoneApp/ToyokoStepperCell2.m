//
//  ToyokoStepperCell2.m
//  toyoko-inn
//
//  Created by toyokoinn on 2015/01/30.
//  Copyright (c) 2015年 中崎拓真. All rights reserved.
//

#import "ToyokoStepperCell2.h"

@implementation ToyokoStepperCell2

- (IBAction)plusPressed:(id)sender {
    _currValue += _step;
    [self updateDisplay];
    [self updateButtons];
}

- (IBAction)minusPressed:(id)sender {
    _currValue -= _step;
    [self updateDisplay];
    [self updateButtons];
}

-(void)setupStepper:(NSInteger)step min:(NSInteger)min max:(NSInteger)max
{
    _step = step;
    _min = min;
    _max = max;
    [self updateButtons];
}

-(void)setValue:(id)value
{
    if([value isKindOfClass:[NSNumber class]])
    {
        _currValue = [value integerValue];
        [self updateDisplay];
        [self updateButtons];
    }
}

-(void)updateDisplay
{
    _digitLabel.text = [NSString stringWithFormat:@"%ld", (long)_currValue];
}

-(void)updateButtons
{
    //boundary checks
    if((_currValue + _step) > _max)
    {
        _plusButton.enabled = NO;
    }
    else
    {
        _plusButton.enabled = YES;
    }
    
    if((_currValue - _step) < _min)
    {
        _minusButton.enabled = NO;
    }
    else
    {
        _minusButton.enabled = YES;
    }
}

-(void)setDict:(NSMutableDictionary *)dict
{
    _dict = dict;
}

- (void)valueChanged
{
    _dict[@"value"] = @(_currValue);
}
@end
