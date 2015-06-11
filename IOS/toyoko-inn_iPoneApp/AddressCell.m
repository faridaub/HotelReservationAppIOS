//
//  AddressCell.m
//  toyoko-inn
//
//  Created by toyokoinn on 2015/03/25.
//  Copyright (c) 2015年 中崎拓真. All rights reserved.
//

#import "AddressCell.h"

@implementation AddressCell

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
    
    CGRect r = self.textLabel.frame;
    r.size.width = _mapButton.frame.origin.x - r.origin.x - MARGIN;
    self.textLabel.frame = r;
}

- (CGFloat)getTextlabelWidth
{
    CGRect r = self.textLabel.frame;
    r.size.width = _mapButton.frame.origin.x - r.origin.x - MARGIN;
    return r.size.width;
}

@end
