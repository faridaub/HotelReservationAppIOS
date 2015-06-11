//
//  ToyokoSwitchCell.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/12/04.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "ToyokoSwitchCell.h"

@implementation ToyokoSwitchCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)valueChanged:(id)sender {
    UISwitch *sw = (UISwitch*)sender;
    _dict[@"value"] = @(sw.on);
}

-(void)setValue:(id)value
{
    if([value isKindOfClass:[NSNumber class]])
    {
        _SwitchControl.on = [value boolValue];
    }
}

-(id)getValue
{
    return @(_SwitchControl.on);
}

-(void)setDict:(NSMutableDictionary *)dict
{
    _dict = dict;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    //make the text label auto-shrink and vertically center aligned
    self.textLabel.adjustsFontSizeToFitWidth = YES;
    self.textLabel.minimumScaleFactor = 0.5f;
    self.textLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    
    //[self adjustSubview];
    
    CGRect r = self.textLabel.frame;
    r.size.width = _SwitchControl.frame.origin.x - self.textLabel.frame.origin.x - self.leftMargin;
    [self.textLabel setFrame: r];
}
@end
