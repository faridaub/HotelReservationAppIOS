//
//  CreditCell.m
//  toyoko-inn
//
//  Created by toyokoinn on 2015/03/26.
//  Copyright (c) 2015年 中崎拓真. All rights reserved.
//

#import "CreditCell.h"

@implementation CreditCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#define MARGIN 5.0f
#define CELL_HEIGHT 50.0f

- (void) layoutSubviews {
    [super layoutSubviews];
    
    UIImage *img = _cardImage.image;
    CGSize size = img.size;
    
    CGRect rect;
    rect.size.width = size.width/2.0;
    rect.size.height = size.height/2.0;
    rect.origin.x = self.indentationWidth;
    rect.origin.y = CELL_HEIGHT - size.height/2 - MARGIN;
    
    _cardImage.contentMode = UIViewContentModeScaleAspectFit;
    _cardImage.frame = rect;
}
@end
