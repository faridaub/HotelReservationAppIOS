//
//  UITableViewCell2.m
//  toyoko-inn
//
//  Created by toyokoinn on 2015/02/25.
//  Copyright (c) 2015年 中崎拓真. All rights reserved.
//

#import "UITableViewCell2.h"

@implementation UITableViewCell2

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if(selected)
    {
        NSLog(@"cell2 selected");
        //[self restoreColorToWhite];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    if(highlighted)
    {
        NSLog(@"cell2 highlighted");
        //[self restoreColorToWhite];
    }
}

-(void)restoreColorToWhite
{
    for(UIView *view in self.subviews)
    {
        if([view isKindOfClass:[UIImageView class]])
        {
            view.backgroundColor = [UIColor whiteColor];
        }
    }
}

@end
