//
//  ToyokoStepperCell.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/07/15.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "ToyokoStepperCell.h"

@implementation ToyokoStepperCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _label.text = [NSString stringWithFormat:_format, _currValue];
#if 0
        _stepper.minimumValue = (double)_min;
        _stepper.maximumValue = (double)_max;
        _stepper.stepValue = (double)1.0f;
#endif
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)setupStepper:(double)step min:(double)min max:(double)max
{
    _stepper.minimumValue = min;
    _stepper.maximumValue = max;
    _stepper.stepValue = step;
    
    _min = min;
    _max = max;
    
    _label.text = [NSString stringWithFormat:_format, (int)_currValue];
}

-(void)setFormatString:(NSString*)str
{
    _format = str;
}

- (IBAction)valueChanged:(id)sender {
    UIStepper *stepper = (UIStepper*)sender;
    _currValue = (NSInteger)stepper.value;
    
    _label.text = [NSString stringWithFormat:_format, (int)_currValue];
    _dict[@"value"] = [NSNumber numberWithInt:(int)_stepper.value];
}

-(void)setValue:(id)value
{
    if([value isKindOfClass:[NSNumber class]])
    {
        _currValue = [value doubleValue];
        _stepper.value = _currValue;
    }
}

-(id)getValue
{
    return [NSNumber numberWithDouble:_currValue];
}

-(void)setDict:(NSMutableDictionary *)dict
{
    _dict = dict;
}

-(void)adjustSubview
{
    //NSLog(@"contentView:%@",NSStringFromCGRect(self.contentView.frame));
    //NSLog(@"stepper:%@",NSStringFromCGRect(_stepper.frame));
    CGRect r;
    r.origin.y = (self.contentView.frame.size.height - _stepper.frame.size.height)/2;
    r.origin.x = self.contentView.frame.size.width - _stepper.frame.size.width - self.rightMargin;
    r.size = _stepper.frame.size;
    
    [_stepper setFrame:r];
    self.textLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;

}

- (void) layoutSubviews {
    [super layoutSubviews];
    [self adjustSubview];
}
@end
