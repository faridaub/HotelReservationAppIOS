//
//  UIButton+BGColor.m
//  toyoko-inn
//
//  Created by toyokoinn on 2015/01/27.
//  Copyright (c) 2015年 中崎拓真. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UIButton+BGColor.h"

#import <QuartzCore/QuartzCore.h>
//#import "UIColor-Expanded.h"

@implementation UIButton (BGColor)

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state {
    CGRect buttonSize = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UIView *bgView = [[UIView alloc] initWithFrame:buttonSize] ;
    bgView.layer.cornerRadius = 5;
    bgView.clipsToBounds = true;
    bgView.backgroundColor = color;
    UIGraphicsBeginImageContext(self.frame.size);
    [bgView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self setBackgroundImage:screenImage forState:state];
}

#if 0
- (void)setBackgroundColorString:(NSString *)colorStr forState:(UIControlState)state {
    UIColor *color = [UIColor colorWithHexString:colorStr];
    [self setBackgroundColor:color forState:state];
}

#endif
@end