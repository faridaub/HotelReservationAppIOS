//
//  PlanCell.m
//  toyoko-inn
//
//  Created by toyokoinn on 2015/06/02.
//  Copyright (c) 2015年 中崎拓真. All rights reserved.
//

#import "PlanCell.h"

@implementation PlanCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#define MARGIN 5.0f
- (void) layoutSubviews {
    [super layoutSubviews];
    
    UIView *label = [self.contentView viewWithTag:1];
    UIView *bglabel = [self.contentView viewWithTag:2];
    
    CGRect rect = self.textLabel.frame;
    CGFloat width = rect.size.width;
    
    if(label) //not nil
        width -= label.frame.size.width;
    if(bglabel)
        width -= bglabel.frame.size.width;
    
    rect.size.width = width;
    self.textLabel.frame = rect;
}
@end
